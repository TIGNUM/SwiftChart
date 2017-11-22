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

    private let paddingTop: CGFloat = 30.0
    private let disposeBag = DisposeBag()
    private var sizingCell = ChatViewCell()
    private var sizeCache: NSCache<GenericCacheKey<SizeCacheKey>, NSValue> = NSCache()
    private var items: [ChatItem<T>] = []
    private let fadeMaskLocation: UIView.FadeMaskLocation
    let viewModel: ChatViewModel<T>
    let pageName: PageName
    var didSelectChoice: ((T, ChatViewController) -> Void)?

    init(pageName: PageName, viewModel: ChatViewModel<T>, backgroundImage: UIImage? = nil, fadeMaskLocation: UIView.FadeMaskLocation) {
        self.pageName = pageName
        self.viewModel = viewModel
        self.fadeMaskLocation = fadeMaskLocation
        super.init(nibName: nil, bundle: nil)
        setupView(withBackgroundImage: backgroundImage) // FIXME: putting this in viewDidLoad() crashes
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let layout = ChatViewLayout()
        layout.delegate = self
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.dataSource = self
        view.delegate = self
        return view
    }()

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
                })
            }
        }.dispose(in: disposeBag)
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        collectionView.contentInset.top = paddingTop + view.safeMargins.top
        collectionView.contentInset.bottom = view.safeMargins.bottom
        view.setFadeMask(at: fadeMaskLocation)
    }

    private func scrollToSnapOffset(animated: Bool) {
        guard let layout = collectionView.collectionViewLayout as? ChatViewLayout else {
            return
        }
        let offset = layout.finalSnapOffset().adding(x: -collectionView.contentInset.left,
                                                     y: -collectionView.contentInset.top)
        collectionView.setContentOffset(offset, animated: animated)
    }

    private func setupView(withBackgroundImage backgroundImage: UIImage?) {
        view.backgroundColor = .clear
        view.addSubview(collectionView)
        
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        collectionView.edgeAnchors == view.edgeAnchors
        collectionView.contentInset.top = paddingTop + view.safeMargins.top
        collectionView.contentInset.bottom = view.safeMargins.bottom
      
        if let backgroundImage = backgroundImage {
            collectionView.backgroundView = UIImageView(image: backgroundImage)
        }

        view.setFadeMask(at: fadeMaskLocation)
    }

    private func registerReusableViews() {
        collectionView.register(ChatViewCell.self, forCellWithReuseIdentifier: "cell")
        regisister(ChatViewHeaderFooter.self, forSupplementaryViewOfKind: .header)
        regisister(ChatViewHeaderFooter.self, forSupplementaryViewOfKind: .footer)
        regisister(ChatViewAvatarView.self, forSupplementaryViewOfKind: .avatar)
    }

    private func regisister(_ aClass: AnyClass?, forSupplementaryViewOfKind kind: ChatViewSupplementaryViewKind) {
        collectionView.register(aClass, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: kind.rawValue)
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChatViewCell else {
            fatalError("Invalid cell")
        }
        let (text, style) = textAndStyle(indexPath: indexPath)
        cell.configure(text: text, style: style)
        return cell
    }

    private func textAndStyle(indexPath: IndexPath) -> (text: String, style: ChatViewCell.Style) {
        let item = items[indexPath.section]
        switch item.type {
        case .message(let message):
            return (message, .message)
        case .choiceList(let choices):
            let choice = choices[indexPath.item]
            let isSelected = viewModel.isSelectedItem(at: indexPath)
            let style: ChatViewCell.Style = isSelected ? .choiceSelected : .choiceUnselected
            return (choice.title, style)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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
        let item = items[indexPath.section]
        switch item.type {
        case .choiceList(let choices):
            viewModel.didSelectItem(at: indexPath)
            if let cell = collectionView.cellForItem(at: indexPath) as? ChatViewCell {
                let (text, style) = textAndStyle(indexPath: indexPath)
                cell.configure(text: text, style: style)
            }
            let choice = choices[indexPath.row]
            didSelectChoice?(choice, self)
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return viewModel.canSelectItem(at: indexPath)
    }
}

extension ChatViewController: ChatViewLayoutDelegate {

    func chartViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = chartViewLayout(layout, insetForSectionAt: indexPath.section)
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

    func chartViewLayout(_ layout: ChatViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let alignment = alignmentForSection(section)
        switch alignment {
        case .left:
            return UIEdgeInsets(top: 0, left: 28, bottom: 15, right: 45)
        case .right:
            return UIEdgeInsets(top: 0, left: 45, bottom: 15, right: 14)
        }
    }

    func chartViewLayout(_ layout: ChatViewLayout, horizontalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chartViewLayout(_ layout: ChatViewLayout, verticalInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func chartViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment {
        return alignmentForSection(section)
    }

    func chartViewLayout(_ layout: ChatViewLayout, sizeForHeaderAt section: Int) -> CGSize? {
        let showHeader = items[section].header != nil
        return showHeader ? CGSize(width: collectionView.bounds.width, height: 32) : nil
    }

    func chartViewLayout(_ layout: ChatViewLayout, sizeForFooterAt section: Int) -> CGSize? {
        let showFooter = items[section].footer != nil
        return showFooter ? CGSize(width: collectionView.bounds.width, height: 32) : nil
    }

    func chartViewLayout(_ layout: ChatViewLayout, showAvatarInSection section: Int) -> Bool {
        let item = items[section]
        let previousItem = section > 0 ? items[section - 1] : nil

        return item.isMessage && (previousItem == nil || previousItem?.isMessage == false )
    }

    func chartViewLayout(_ layout: ChatViewLayout,
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

    func chartViewLayout(_ layout: ChatViewLayout, snapToTopOffsetInSection section: Int) -> CGFloat? {
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
