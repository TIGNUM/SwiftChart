//
//  ChatViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 20.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import Anchorage

protocol ChatViewControllerDelegate: class {

    func cellDidAppear(viewController: UIViewController,
                       collectionView: UICollectionView,
                       destination: AppCoordinator.Router.Destination?)
}

private struct SizeCacheKey: Hashable {

    let text: String
    let styleID: String
    let maxWidth: CGFloat

    static func == (lhs: SizeCacheKey, rhs: SizeCacheKey) -> Bool {
        return lhs.text == rhs.text
            && lhs.styleID == rhs.styleID
            && lhs.maxWidth == rhs.maxWidth
    }

    var hashValue: Int {
        return text.hashValue ^ styleID.hashValue ^ maxWidth.hashValue
    }
}

final class GenericCacheKey<T: Hashable>: NSObject {

    let key: T

    init(_ key: T) {
        self.key = key
    }

    override func isEqual(_ object: Any?) -> Bool {
        return key == (object as? GenericCacheKey<T>)?.key
    }

    override var hash: Int {
        return key.hashValue
    }
}

final class ChatViewController<T: ChatChoice>: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private var sizingCell = ChatViewCell()
    private var sizeCache: NSCache<GenericCacheKey<SizeCacheKey>, NSValue> = NSCache()
    private var items: [ChatItem<T>] = []
    private var fadeMaskLocation: UIView.FadeMaskLocation?
    private var visionChoice: VisionGeneratorChoice?
    weak var routerDelegate: ChatViewControllerDelegate?
    var destination: AppCoordinator.Router.Destination?
    let viewModel: ChatViewModel<T>
    let pageName: PageName
    var didSelectChoice: ((T, ChatViewController) -> Void)?
    var visionGeneratorInteractor: VisionGeneratorInteractorInterface?

    static func deliveredFooter(includeFooter: Bool) -> String? {
        guard includeFooter == true else { return nil }
        let time = DateFormatter.displayTime.string(from: Date())
        return R.string.localized.prepareChatFooterDeliveredTime(time)
    }

    private lazy var collectionView: UICollectionView = {
        let layout = ChatViewLayout()
        layout.delegate = self
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white60, for: .normal)
        let style = Style.headlineSmall("Pick 4 to continue", .white60).attributedString(lineSpacing: 2)
        button.setAttributedTitle(style, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.white60.cgColor
        button.addTarget(self, action: #selector(didPressBottomButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Actions

    @objc func didPressBottomButton() {
        guard let choice = visionChoice else { return }
        visionGeneratorInteractor?.didPressBottomButton(choice)
    }

    // MARK: - Init

    init(pageName: PageName,
         viewModel: ChatViewModel<T>,
         backgroundImage: UIImage? = nil,
         fadeMaskLocation: UIView.FadeMaskLocation) {
        self.pageName = pageName
        self.viewModel = viewModel
        self.fadeMaskLocation = fadeMaskLocation
        super.init(nibName: nil, bundle: nil)
        setupView(withBackgroundImage: backgroundImage) // FIXME: putting this in viewDidLoad() crashes
    }

    init(pageName: PageName,
         viewModel: ChatViewModel<T>,
         backgroundImage: UIImage?,
         configure: Configurator<ChatViewController>) {
        self.pageName = pageName
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupVisionGeneratorView(withBackgroundImage: backgroundImage)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerReusableViews()
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload(let items):
                self.items = items
                self.collectionView.reloadData()
                self.scrollToSnapOffset(animated: true)
            case .update(let items, _, let insertions, _):
                self.collectionView.performBatchUpdates({
                    self.items = items
                    self.collectionView.insertSections(IndexSet(insertions))
                }, completion: { (_) -> Void in
                    self.scrollToSnapOffset(animated: true)
                    self.routerDelegate?.cellDidAppear(viewController: self,
                                                       collectionView: self.collectionView,
                                                       destination: self.destination)
                })
            }
        }.dispose(in: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        guard let visionChoice = visionChoice else { return }
        loadNextQuestions(visionChoice)
        self.visionChoice = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.applyDefaultStyle()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionView.contentInset.top = Layout.paddingTop + view.safeMargins.top
        collectionView.contentInset.bottom = view.safeMargins.bottom
        addFadeMaskLocationIfNeeded()
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch items[section].type {
        case .choiceList(let choices):
            return choices.count
        default:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                            for: indexPath) as? ChatViewCell else {
            fatalError("Invalid cell")
        }
        let (text, style) = textAndStyle(indexPath: indexPath)
        cell.configure(text: text, style: style)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let kind = ChatViewSupplementaryViewKind(rawValue: kind) else {
                fatalError("Invalid Kind")
        }

        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                                                   withReuseIdentifier: kind.rawValue,
                                                                   for: indexPath)
        let item = items[indexPath.section]
        let alignment: NSTextAlignment = alignmentForSection(indexPath.section) == .left ? .left : .right
        let text: String?
        switch kind {
        case .header:
            text = item.header
        case .footer:
            text = item.footer
        case .avatar:
            text = nil
        }
        if let text = text {
            let style = ChatViewHeaderFooter.Style.default(alignment: alignment)
            (view as? ChatViewHeaderFooter)?.configure(text: text, style: style)
        }
        return view
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section < items.count else { return }
        routerDelegate = nil
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList(let choices): handleItemSelection(at: indexPath, choices: choices)
        default: break
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return viewModel.canSelectItem(at: indexPath)
    }
}

// MARK: - Private

private extension ChatViewController {

    func handleItemSelection(at indexPath: IndexPath, choices: [T]) {
        if pageName == PageName.visionGenerator {
            viewModel.selectOrDeSelectItem(at: indexPath)
        } else {
            viewModel.didSelectItem(at: indexPath)
        }

        if let cell = collectionView.cellForItem(at: indexPath) as? ChatViewCell {
            let (text, style) = textAndStyle(indexPath: indexPath)
            cell.configure(text: text, style: style)
        }
        let choice = choices[indexPath.row]
        didSelectChoice?(choice, self)
    }

    func addFadeMaskLocationIfNeeded() {
        guard let fadeMask = fadeMaskLocation else { return }
        view.setFadeMask(at: fadeMask)
    }

    func scrollToSnapOffset(animated: Bool) {
        guard let layout = collectionView.collectionViewLayout as? ChatViewLayout else {
            return
        }
        let offset = layout.finalSnapOffset().adding(x: -collectionView.contentInset.left,
                                                     y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: animated)
    }

    func setupView(withBackgroundImage backgroundImage: UIImage?) {
        view.backgroundColor = .clear
        view.addSubview(collectionView)

        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.edgeAnchors == view.edgeAnchors
            collectionView.contentInset.top = Layout.paddingTop + view.safeMargins.top
            collectionView.contentInset.bottom = view.safeMargins.bottom
        } else {
            collectionView.topAnchor == view.topAnchor + Layout.statusBarHeight + Layout.paddingTop
            collectionView.bottomAnchor == view.bottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.paddingTop
        }
        if let backgroundImage = backgroundImage {
            collectionView.backgroundView = UIImageView(image: backgroundImage)
        }
        addFadeMaskLocationIfNeeded()
    }

    func setupVisionGeneratorView(withBackgroundImage backgroundImage: UIImage?) {
        view.backgroundColor = .clear
        let backgroundImage = UIImageView(image: backgroundImage)
        view.addSubview(backgroundImage)
        view.addSubview(collectionView)
        view.addSubview(bottomButton)
        bottomButton.centerXAnchor == view.centerXAnchor
        bottomButton.heightAnchor == 44
        bottomButton.widthAnchor == view.widthAnchor - view.frame.width * 0.25
        bottomButton.isHidden = true

        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            backgroundImage.edgeAnchors == view.edgeAnchors
            bottomButton.bottomAnchor == view.bottomAnchor - 16 - view.safeMargins.bottom
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.topAnchor == view.topAnchor + view.safeMargins.top + Layout.statusBarHeight
            collectionView.bottomAnchor == view.bottomAnchor - view.safeMargins.bottom - Layout.statusBarHeight
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.paddingTop + view.safeMargins.top
            collectionView.contentInset.bottom = view.safeMargins.bottom - bottomButton.frame.height - 16
        } else {
            bottomButton.bottomAnchor == view.bottomAnchor - 16
            collectionView.topAnchor == view.topAnchor + Layout.paddingTop
            collectionView.bottomAnchor == bottomButton.topAnchor + 16
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.paddingTop
        }
    }

    func registerReusableViews() {
        collectionView.register(ChatViewCell.self, forCellWithReuseIdentifier: "cell")
        regisister(ChatViewHeaderFooter.self, forSupplementaryViewOfKind: .header)
        regisister(ChatViewHeaderFooter.self, forSupplementaryViewOfKind: .footer)
        regisister(ChatViewAvatarView.self, forSupplementaryViewOfKind: .avatar)
    }

    func regisister(_ aClass: AnyClass?, forSupplementaryViewOfKind kind: ChatViewSupplementaryViewKind) {
        collectionView.register(aClass, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: kind.rawValue)
    }

    func textAndStyle(indexPath: IndexPath) -> (text: String, style: ChatViewCell.Style) {
        let item = items[indexPath.section]
        switch item.type {
        case .message(let message):
            return (message, .message)
        case .choiceList(let choices):
            let choice = choices[indexPath.item]
            let isSelected = viewModel.isSelectedItem(at: indexPath)
            let selectedStyle: ChatViewCell.Style = item.chatType == .visionGenerator ? .visionChoiceSelected : .choiceSelected
            let style: ChatViewCell.Style = isSelected ? selectedStyle : .choiceUnselected
            return (choice.title, style)
        }
    }
}

// MARK: - ChatViewLayoutDelegate

extension ChatViewController: ChatViewLayoutDelegate {

    func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = chatViewLayout(layout, insetForSectionAt: indexPath.section)
        let maxWidth = collectionView.bounds.size.width - sectionInset.horizontal
        let (text, style) = textAndStyle(indexPath: indexPath)
        let key = GenericCacheKey(SizeCacheKey(text: text, styleID: style.identifier, maxWidth: maxWidth))
        if let size = sizeCache.object(forKey: key)?.cgSizeValue {
            return size
        } else {
            sizingCell.configure(text: text, style: style)
            sizingCell.bounds = CGRect(x: 0, y: 0, width: maxWidth, height: 1000)
            sizingCell.setNeedsLayout()
            sizingCell.layoutIfNeeded()
            let size = sizingCell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            sizeCache.setObject(NSValue(cgSize: size), forKey: key)
            return size
        }
    }

    func chatViewLayout(_ layout: ChatViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let alignment = alignmentForSection(section)
        switch alignment {
        case .left:
            return UIEdgeInsets(top: 0, left: 28, bottom: 15, right: 45)
        case .right:
            return UIEdgeInsets(top: 0, left: 45, bottom: 15, right: 14)
        }
    }

    func chatViewLayout(_ layout: ChatViewLayout, horizontalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chatViewLayout(_ layout: ChatViewLayout, verticalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chatViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment {
        return alignmentForSection(section)
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForHeaderAt section: Int) -> CGSize? {
        let showHeader = items[section].header != nil
        return showHeader ? CGSize(width: collectionView.bounds.width, height: 32) : nil
    }

    func chatViewLayout(_ layout: ChatViewLayout, sizeForFooterAt section: Int) -> CGSize? {
        let showFooter = items[section].footer != nil
        return showFooter ? CGSize(width: collectionView.bounds.width, height: 32) : nil
    }

    func chatViewLayout(_ layout: ChatViewLayout, showAvatarInSection section: Int) -> Bool {
        let item = items[section]
        let previousItem = section > 0 ? items[section - 1] : nil

        return item.isMessage && (previousItem == nil || previousItem?.isMessage == false )
    }

    func chatViewLayout(_ layout: ChatViewLayout,
                         animatorForLayoutAttributes attrs: UICollectionViewLayoutAttributes) -> ChatViewAnimator? {
        let indexPath = attrs.indexPath
        switch attrs.representedElementCategory {
        case .cell:
            let item = items[indexPath.section]
            switch item.type {
            case .message:
                return ChatViewAnimator.messageAnimator()
            case .choiceList:
                let firstDelay = 0.1
                let delay = (Double(indexPath.item) / 10.0) + firstDelay
                let duration = 0.4
                let xOffset = view.bounds.width
                return ChatViewAnimator.slideInAnimator(xOffset: xOffset, duration: duration, delay: delay)
            }
        case .supplementaryView:
            let item = items[indexPath.section]
            guard
                let kindString = attrs.representedElementKind,
                let kind = ChatViewSupplementaryViewKind(rawValue: kindString) else {
                    return nil
            }
            let delay: Double
            switch kind {
            case .header:
                delay = 0
            case .footer:
                if item.isMessage {
                    delay = 1
                } else {
                    delay = (Double(collectionView.numberOfItems(inSection: indexPath.section)) / 10.0)
                }
            case .avatar:
                delay = 0
            }
            return ChatViewAnimator.fadeInAnimator(duration: 0.3, delay: delay)
        default:
            return nil
        }
    }

    func chatViewLayout(_ layout: ChatViewLayout, snapToTopOffsetInSection section: Int) -> CGFloat? {
        let item = items[section]
        return item.isAutoscrollSnapable ? 0 : nil
    }

    private func alignmentForSection(_ section: Int) -> ChatViewAlignment {
        let item = items[section]
        switch item.type {
        case .message:
            return .left
        case .choiceList:
            return .right
        }
    }
}

// MARK: - ChatViewControllerInterface

extension ChatViewController: ChatViewControllerInterface {

    func dismiss() {
        navigationController?.popViewController(animated: true)
    }

    func laodLastQuestion() {
        visionGeneratorInteractor?.laodLastQuestion()
    }

    func resetVisionChoice() {
        self.visionChoice = nil
    }

    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType) {
        visionChoice = choice
        bottomButton.isHidden = questionType.bottomButtonIsHidden
        let itemCount = visionGeneratorInteractor?.visionSelectionCount ?? 0
        let title = visionGeneratorInteractor?.bottomButtonTitle(choice) ?? ""
        let textColor: UIColor = itemCount < 4 ? .white60 : .white
        let backgroundColor: UIColor = itemCount < 4 ? .clear : .lightGray
        let style = Style.headlineSmall(title, textColor).attributedString(lineSpacing: 2)
        bottomButton.setAttributedTitle(style, for: .normal)
        bottomButton.backgroundColor = backgroundColor
        bottomButton.isEnabled = itemCount == 4
    }

    func loadNextQuestions(_ choice: VisionGeneratorChoice) {
        visionGeneratorInteractor?.loadNextQuestions(choice)
    }

    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice) {
        visionChoice = choice
        stream(videoURL: mediaURL)
    }

    func showContent(_ contentID: Int, choice: VisionGeneratorChoice) {
        AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentID) {
            self.loadNextQuestions(choice)
        }
    }
}
