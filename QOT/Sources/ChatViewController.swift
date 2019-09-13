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
import SVProgressHUD

protocol ChatViewControllerDelegate: class {

    func cellDidAppear(viewController: UIViewController,
                       collectionView: UICollectionView)
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(text.hashValue ^ styleID.hashValue ^ maxWidth.hashValue)
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
    private var visionChoice: VisionGeneratorChoice?
    private var eventTracker: EventTracker?
    weak var routerDelegate: ChatViewControllerDelegate?
    let viewModel: ChatViewModel<T>
    let page: PageName
    var didSelectChoice: ((T, ChatViewController) -> Void)?
    var visionGeneratorInteractor: VisionGeneratorInteractorInterface?

    static func deliveredFooter(includeFooter: Bool) -> String? {
        guard includeFooter == true else { return nil }
        let time = DateFormatter.displayTime.string(from: Date())
        return R.string.localized.prepareChatFooterDeliveredTime(time)
    }

    private lazy var backButton: UIBarButtonItem = {
        return UIBarButtonItem(image: R.image.ic_back(),
                               style: .plain,
                               target: self,
                               action: #selector(didTapBackButton))
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = ChatViewLayout()
        layout.delegate = self
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .navy
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        let style = ThemeText.chatButton.attributedString("Pick 4 to continue")
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
         fadeMaskLocation: UIView.FadeMaskLocation,
         eventTracker: EventTracker? = nil) {
        self.page = pageName
        self.viewModel = viewModel
        self.eventTracker = eventTracker
        super.init(nibName: nil, bundle: nil)
        setupView(withBackgroundImage: backgroundImage) // FIXME: putting this in viewDidLoad() crashes
    }

    init(pageName: PageName,
         viewModel: ChatViewModel<T>,
         backgroundImage: UIImage?,
         configure: Configurator<ChatViewController>) {
        self.page = pageName
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
        replaceBackButtonIfNeeded()
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
                                                       collectionView: self.collectionView)
                })
            }
        }.dispose(in: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let visionChoice = visionChoice else { return }
        loadNextQuestions(visionChoice)
        self.visionChoice = nil
    }

    @objc override func didTapBackButton() {
        guard pageName == PageName.visionGenerator else { return }
        if let alertModel = viewModel.visionGeneratorInteractor?.alertModel,
            viewModel.visionGeneratorInteractor?.shouldShowAlertVisionNotSaved == true {
            let alertController = alertModel.showActionSheet(continueAction: {
                // Do nothing
            }, saveAndExit: {
                self.viewModel.visionGeneratorInteractor?.saveVision()
                self.dismiss()
            }, exit: {
                self.dismiss()
            })
            present(alertController, animated: true, completion: nil)
        } else {
            self.dismiss()
        }
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionView.contentInset.top = Layout.padding_24 + view.safeMargins.top
        collectionView.contentInset.bottom = view.safeMargins.bottom
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
            let time = DateFormatter.displayTime.string(from: Date())
            text = R.string.localized.prepareChatFooterDeliveredTime(time)
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

    func replaceBackButtonIfNeeded() {
        guard pageName == PageName.visionGenerator else { return }
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = backButton
    }

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

    func scrollToSnapOffset(animated: Bool) {
        guard let layout = collectionView.collectionViewLayout as? ChatViewLayout else {
            return
        }
        let offset = layout.finalSnapOffset().adding(x: -collectionView.contentInset.left,
                                                     y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: animated)
    }

    func setupView(withBackgroundImage backgroundImage: UIImage?) {
        view.backgroundColor = .navy
        view.addSubview(collectionView)
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.edgeAnchors == view.edgeAnchors
            collectionView.contentInset.top = Layout.padding_24 + view.safeMargins.top
            collectionView.contentInset.bottom = view.safeMargins.bottom
        } else {
            collectionView.topAnchor == view.topAnchor
            collectionView.bottomAnchor == view.bottomAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.padding_24
        }
    }

    func setupVisionGeneratorView(withBackgroundImage backgroundImage: UIImage?) {
        view.backgroundColor = .navy
        view.addSubview(collectionView)
        view.addSubview(bottomButton)
        bottomButton.centerXAnchor == view.centerXAnchor
        bottomButton.heightAnchor == Layout.height_44
        bottomButton.widthAnchor == view.widthAnchor - view.frame.width * Layout.multiplier_025
        bottomButton.isHidden = true
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            bottomButton.bottomAnchor == view.bottomAnchor - Layout.padding_16 - view.safeMargins.bottom
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.topAnchor == view.topAnchor
            collectionView.bottomAnchor == view.bottomAnchor - view.safeMargins.bottom - Layout.statusBarHeight
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.padding_24 + view.safeMargins.top
            collectionView.contentInset.bottom = view.safeMargins.bottom - bottomButton.frame.height - Layout.padding_16
        } else {
            bottomButton.bottomAnchor == view.bottomAnchor
            collectionView.topAnchor == view.topAnchor
            collectionView.bottomAnchor == bottomButton.topAnchor
            collectionView.leadingAnchor == view.leadingAnchor
            collectionView.trailingAnchor == view.trailingAnchor
            collectionView.contentInset.top = Layout.padding_24
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

    func chatViewLayout(_ layout: ChatViewLayout, updateContentSize: CGSize) {}

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

    func restartGenerator() {
        visionGeneratorInteractor?.restartGenerator()
    }

    func showLoadingIndicator() {
        SVProgressHUD.show()
    }

    func hideLoadingIndicator() {
        SVProgressHUD.dismiss()
    }

    func dismiss() {
        if let childViewControllers = navigationController?.childViewControllers,
            childViewControllers.first != self {
            navigationController?.popViewController(animated: true)
            return
        }
        let configurator = MyToBeVisionConfigurator.make(navigationItem: NavigationItem())
        let toBeVisionViewController = MyToBeVisionViewController(configurator: configurator, eventTracker: eventTracker)
        navigationController?.pushViewController(toBeVisionViewController, animated: true)
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
        let itemCount = visionGeneratorInteractor?.visionSelectionCount(for: questionType) ?? 0
        let enableButton = itemCount == VisionGeneratorChoice.expectedChoiceCount
        let title = visionGeneratorInteractor?.bottomButtonTitle(choice) ?? ""
        let theme = enableButton ? ThemeText.chatButtonEnabled : ThemeText.chatButton
        let style = theme.attributedString(title)
        bottomButton.setAttributedTitle(style, for: .normal)
        bottomButton.isEnabled = enableButton
        bottomButton.backgroundColor = enableButton ? UIColor.azure : UIColor.clear
        bottomButton.layer.borderColor = enableButton ? UIColor.azure.cgColor : UIColor.lightGray.cgColor
        bottomButton.pulsate()
    }

    func loadNextQuestions(_ choice: VisionGeneratorChoice) {
        visionGeneratorInteractor?.loadNextQuestions(choice)
    }

    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice, contentItem: ContentItem?) {
        visionChoice = choice
        stream(videoURL: mediaURL, contentItem: nil, pageName)
    }

    func showContent(_ contentID: Int, choice: VisionGeneratorChoice) {
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
    }
}
