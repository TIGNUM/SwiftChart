//
//  ArticleViewController.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import Kingfisher

protocol ArticleDelegate: class {
    func didTapMarkAsRead(_ read: Bool)
    func section() -> ContentSection
}

protocol ArticleItemViewControllerDelegate: class {
    func didTapClose(in viewController: UIViewController)
    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL, in viewController: UIViewController)
    func didTapLink(_ url: URL, in viewController: UIViewController)
}

var colorMode = ColorMode.dark
var textScale = TextScale.scaleNot
var colorModeIsActive = false

enum ColorMode {
    case dark
    case darkNot

    var isLightMode: Bool {
        return colorModeIsActive && self == .darkNot
    }

    var background: UIColor {
        switch self {
        case .dark: return .carbon
        case .darkNot: return .sand
        }
    }

    var fade: UIColor {
        switch self {
        case .dark: return UIColor.carbon.withAlphaComponent(0.1)
        case .darkNot: return UIColor.sand.withAlphaComponent(0.1)
        }
    }

    var tint: UIColor {
        switch self {
        case .dark: return .accent
        case .darkNot: return .accent
        }
    }

    var cellHighlight: UIColor {
        switch self {
        case .dark: return .accent10
        case .darkNot: return .accent10
        }
    }
}

final class ArticleViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: ArticleInteractorInterface!
    weak var delegate: ArticleItemViewControllerDelegate?
    private var header: Article.Header?
    private var audioButton = AudioButton()
    private weak var readButtonCell: MarkAsReadTableViewCell?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var articleTopNavBar: ArticleTopNavBar!
    @IBOutlet private weak var constraintNavBar: NSLayoutConstraint!

    private var lastScrollViewOffsetY: CGFloat = 0.0
    private var lastScrollViewActionOffsetY: CGFloat = 0.0
    private var didScrollToRead = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        setColorMode()
        articleTopNavBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationController?.navigationBar.shadowImage = UIImage()
        ThemeAppearance.setNavigation(bar: navigationController?.navigationBar, theme: .articleBackground(nil))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        colorModeIsActive = false
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = 0
        pageTrack.pageKey = pageKey
        pageTrack.associatedValueType = .CONTENT_COLLECTION
        pageTrack.associatedValueId = interactor.remoteID
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private
private extension ArticleViewController {
    func setupTableView() {
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        tableView.registerDequeueable(ErrorCell.self)
        tableView.registerDequeueable(ArticleTextHeaderTableViewCell.self)
        tableView.registerDequeueable(ArticleImageHeaderTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedWhatsHotTableViewCell.self)
        tableView.registerDequeueable(ArticleBulletPointTableViewCell.self)
        tableView.registerDequeueable(MarkAsReadTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedTableViewCell.self)
        tableView.registerDequeueable(ArticleNextUpTableViewCell.self)
        tableView.registerDequeueable(FoundationTableViewCell.self)
        tableView.registerDequeueable(StrategyContentTableViewCell.self)
        tableView.registerDequeueable(ArticleEmptyTableViewCell.self)
        tableView.registerDequeueable(ArticleContactSupportTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.estimatedSectionHeaderHeight = interactor.sectionHeaderHeight
        tableView.backgroundColor = .clear
    }

    func setupAudioItem() {
        guard let audioItem = interactor.audioItem else { return }
        audioButton = AudioButton.instantiateFromNib()
        audioButton.configure(categoryTitle: interactor.categoryTitle,
                              title: interactor.title,
                              audioURL: interactor.audioURL,
                              remoteID: audioItem.remoteID,
                              duration: audioItem.type.duration)
    }

    func setColorMode() {
        colorModeIsActive = true
        setStatusBar(colorMode: colorMode)
        ThemeView.articleBackground(nil).apply(view)
        setNeedsStatusBarAppearanceUpdate()
        audioButton.setColorMode()
        view.bringSubview(toFront: audioButton)
        refreshBottomNavigationItems()
    }
}

// MARK: - BottomNavigation
extension ArticleViewController {
    @objc override public func didTapDismissButton() {
        trackUserEvent(.CLOSE, action: .TAP)
        dismiss(animated: true, completion: nil)
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if self.interactor.audioItem != nil {
            setupAudioItem()
            return [UIBarButtonItem(customView: audioButton)]
        }
        return nil
    }
}

// MARK: - Actions
extension ArticleViewController: ArticleTopNavBarProtocol {

    func didTapBookmarkItem() {
        trackUserEvent(.BOOKMARK, value: interactor.remoteID, valueType: .CONTENT, action: .TAP)
        interactor.toggleBookmark()
    }

    func didTapDarkModeItem() {
        trackUserEvent(.COLOR_MODE, value: interactor.remoteID, valueType: .CONTENT, action: .TAP)
        colorMode = colorMode == .dark ? .darkNot : .dark
        setColorMode()
        tableView.reloadData()
        articleTopNavBar.refreshColor()
    }

    func didTapTextScaleItem() {
        trackUserEvent(.FONT_SIZE, value: interactor.remoteID, valueType: .CONTENT, action: .TAP)
        textScale = textScale == .scaleNot ? .scale : .scaleNot
        tableView.reloadData()
    }

    func didTapShareItem() {
        trackUserEvent(.SHARE, value: interactor.remoteID, valueType: .CONTENT, action: .TAP)
        let share = interactor.whatsHotShareable
        guard let title = share.message else { return }
        guard let shareLink = share.shareableLink, let url = URL(string: shareLink) else { return }
        let dispatchGroup = DispatchGroup()
        var items: [Any] = [title, url]

        dispatchGroup.enter()
        if let imageURL = share.imageURL {
            KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                switch result {
                case .success(let image): // if there is cached image share with image.
                    items.append(image)
                default: break
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self?.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - ArticleViewControllerInterface
extension ArticleViewController: ArticleViewControllerInterface {
    func setTopBarButtonItems(isShareable: Bool, hasBookMarkItem: Bool) {
        articleTopNavBar.configure(self, isShareable: isShareable, isBookMarkable: hasBookMarkItem)
    }

    func reloadData() {
        let navigationBarIsHidden = interactor.alwaysHideTopBar
        reloadData(showNavigationBar: !navigationBarIsHidden)
    }

    func reloadData(showNavigationBar: Bool) {
        navigationBar(show: showNavigationBar)
        tableView.reloadData()
        tableView.scrollToTop(animated: true)
        setupAudioItem()
        refreshBottomNavigationItems()
    }

    func setupArticleHeader(header: Article.Header) {
        self.header = header
    }

    func setupView() {
        setupTableView()
        setColorMode()
    }

    func hasBookmark(_ hasBookmark: Bool) {
        articleTopNavBar.updateBookmark(hasBookmark)
    }
}

// MARK: - Transition
extension ArticleViewController {
    func transitionArticle(remoteID: Int) {
        let image = view.takeSnapshot()
        let shot = UIImageView(image: image)
        shot.tag = 871234
        view.addSubview(shot)

        interactor.showRelatedArticle(remoteID: remoteID)
        reloadData(showNavigationBar: false)
    }

    func dataUpdated() {
        if let imageViewShot = self.view.viewWithTag(871234) {
            UIView.animate(withDuration: 0.5, animations: {
                imageViewShot.alpha = 0.0
            }, completion: { (_) in
                imageViewShot.removeFromSuperview()
            })
        }
    }
}

// MARK: - Cells
extension ArticleViewController {
    func articleItemTextViewCell(tableView: UITableView,
                                 indexPath: IndexPath,
                                 topText: NSAttributedString) -> ContentItemTextTableViewCell {
        let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
        itemTextCell.setup(topText: topText, bottomText: nil, delegate: self)
        itemTextCell.backgroundColor = .clear
        itemTextCell.contentView.backgroundColor = .clear
        return itemTextCell
    }

    func imageTableViewCell(tableView: UITableView,
                            indexPath: IndexPath,
                            attributeString: NSAttributedString,
                            url: URL) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(imageURL: url, description: attributeString, canStream: false)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        imageCell.backgroundColor = .clear
        imageCell.contentView.backgroundColor = .clear
        return imageCell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath, item: Article.Item) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: AppTextService.get(AppTextKey.generic_content_error_title_invalid_content), item: item)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func relatedArticleCell(tableView: UITableView, indexPath: IndexPath) -> ArticleRelatedWhatsHotTableViewCell {
        let relatedArticleCell: ArticleRelatedWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
        let relatedArticle = interactor.relatedArticle(at: indexPath)
        relatedArticleCell.configure(title: relatedArticle?.title,
                                     publishDate: relatedArticle?.publishDate,
                                     author: relatedArticle?.author,
                                     timeToRead: relatedArticle?.timeToRead,
                                     imageURL: relatedArticle?.imageURL,
                                     isNew: relatedArticle?.isNew ?? false,
                                     forcedColorMode: nil)
        return relatedArticleCell
    }

    func emptyCell(tableView: UITableView, indexPath: IndexPath) -> ArticleEmptyTableViewCell {
        let cell: ArticleEmptyTableViewCell = tableView.dequeueCell(for: indexPath)
        return cell
    }

    func sectionHasContent(_ section: Int) -> Bool {
        let numRows = interactor.itemCount(in: section)
        let title = interactor.headerTitle(for: section) ?? ""
        return !title.isEmpty && numRows > 0
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.itemCount(in: section)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText: articleTopNavBar.title = nil
        default: break
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText: articleTopNavBar.title = header?.title
        default: return
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor.articleItem(at: indexPath) else {
            return emptyCell(tableView: tableView, indexPath: indexPath)
        }
        switch item.type {
        case .headerText(let header):
            let cell: ArticleTextHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            cell.configure(articleHeader: header)
            return cell
        case .headerImage(let imageURLString):
            let cell: ArticleImageHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(imageURLString: imageURLString)
            return cell
        case .audio( _, let title, let description, placeholderURL: _, _, duration: _, waveformData: _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title.uppercased(),
                           durationString: description ?? "",
                           icon: R.image.ic_audio_grey_light())
            return cell
        case .image(let title, _, let url):
            return imageTableViewCell(
                tableView: tableView,
                indexPath: indexPath,
                attributeString: ThemeText.articleMediaDescription.attributedString(title),
                url: url)
        case .listItem(let bullet):
            let cell: ArticleBulletPointTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(bullet: bullet)
            return cell
        case .text(let text, let style):
            var attributedTopText = ThemeText.articleBody.attributedString(text)
            if style.headline == true {
                attributedTopText = ThemeText.articleBody.attributedString(text.uppercased())
            } else if style == .paragraph {
                attributedTopText = ThemeText.articleBody.attributedString(text, lineHeight: 8)
            } else if style == .quote {
                attributedTopText = ThemeText.articleQuote.attributedString(text, lineHeight: 1.8)
            }
            return articleItemTextViewCell(tableView: tableView,
                                           indexPath: indexPath,
                                           topText: attributedTopText)
        case .video( _, let title, let description, _, _, _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title.uppercased(),
                           durationString: description ?? "",
                           icon: R.image.my_library_camera())
            return cell
        case .pdf(let title, let description, _, _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           durationString: description ?? "",
                           icon: R.image.ic_seen_of())
            return cell
        case .articleRelatedWhatsHot(let relatedArticle):
            let cell: ArticleRelatedWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: relatedArticle.title,
                           publishDate: relatedArticle.publishDate,
                           author: relatedArticle.author,
                           timeToRead: relatedArticle.timeToRead,
                           imageURL: relatedArticle.imageURL,
                           isNew: relatedArticle.isNew,
                           forcedColorMode: nil)
            return cell
        case .button:
            let cell: MarkAsReadTableViewCell = tableView.dequeueCell(for: indexPath)
            interactor.isRead { (isRead) in
                cell.configure(selected: isRead)
            }
            cell.delegate = self
            readButtonCell = cell
            return cell
        case .articleRelatedStrategy(let title, let description, _):
            let cell: ArticleRelatedTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           durationString: description,
                           icon: R.image.ic_seen_of())
            return cell
        case .articleNextUp(let title, let description, _):
            let cell: ArticleNextUpTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(header: AppTextService.get(AppTextKey.know_strategy_list_strategy_section_next_up_title),
                           title: title,
                           durationString: description,
                           icon: R.image.ic_seen_of())
            return cell
        case .contactSupport:
            let cell: ArticleContactSupportTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(attributtedText: interactor.contactSupportAttributtedString(),
                           textViewDelegate: self)
            return cell
        default:
            return invalidContentCell(tableView: tableView, indexPath: indexPath, item: item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = interactor.articleItem(at: indexPath) else {
            return UITableViewAutomaticDimension
        }
        switch item.type {
        case .articleRelatedWhatsHot: return 215
        case .pdf,
             .articleRelatedStrategy: return 95
        case .articleNextUp: return 144
        case .audio(remoteId: _, title: _, description: _, placeholderURL: _, audioURL: _, duration: _, waveformData:_):
            return 95
        default: return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = interactor.articleItem(at: indexPath) else { return }
        switch item.type {
        case .audio( let remoteId, _, _, _, _, _, _):
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(remoteId)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        case .video(let remoteID, _, _, _, _, _):
            if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(remoteID)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        case .pdf(let title, _, let pdfURL, let itemID):
            showPDFReader(withURL: pdfURL, title: title, itemID: itemID)
            trackUserEvent(.OPEN, value: itemID, valueType: .CONTENT_ITEM, action: .TAP)
        case .articleRelatedWhatsHot(let relatedArticle):
            transitionArticle(remoteID: relatedArticle.remoteID)
            trackUserEvent(.OPEN, value: relatedArticle.remoteID, valueType: .CONTENT, action: .TAP)
        case .articleRelatedStrategy(_, _, let remoteID),
             .articleNextUp(_, _, let remoteID):
            transitionArticle(remoteID: remoteID)
            trackUserEvent(.OPEN, value: remoteID, valueType: .CONTENT, action: .TAP)
        default: return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !sectionHasContent(section) || interactor.isSectionSupport() {
            return nil
        }

        guard let headerTitle = interactor.headerTitle(for: section) else {
            return nil
        }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.estimatedSectionHeaderHeight))
        headerView.backgroundColor = .clear
        if interactor.sectionNeedsLine {
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0))
            ThemeView.articleSeparator(nil).apply(lineView)
            headerView.addSubview(lineView)
        }
        let titleLabel = UILabel(frame: CGRect(x: 28, y: headerView.frame.size.height - 18.0, width: view.frame.width, height: 18))
        ThemeText.articleNextTitle.apply(headerTitle, to: titleLabel)
        headerView.addSubview(titleLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (sectionHasContent(section) && !(interactor.isSectionSupport())) ? tableView.estimatedSectionHeaderHeight : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionCount = interactor.sectionCount
        return section == sectionCount - 1 ? 80.0 : 0.0
    }
}

// MARK: - ClickableLabelDelegate
extension ArticleViewController: ClickableLabelDelegate {
    func openLink(withURL url: URL) {
        interactor.didTapLink(url)
        trackUserEvent(.OPEN, value: nil, stringValue: url.absoluteString, valueType: .LINK, action: .TAP)
    }
}

// MARK: - UIScrollViewDelegate
extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !didScrollToRead {
            checkMarkAsReadButton(true)
            didScrollToRead = true
        }
        navigationBarAutoShowHide(scrollView)
    }
}

// MARK: - NavigationBar Show Hide
extension ArticleViewController {
    func navigationBarAutoShowHide(_ scrollView: UIScrollView) {
        guard !interactor.shouldHideTopBar else { return }

        let pixelBuffer: CGFloat = 50
        let scrollViewOffsetY = scrollView.contentOffset.y
        let movingUp = lastScrollViewOffsetY < scrollViewOffsetY
        if movingUp {
            if !navBarIsHidden && scrollViewOffsetY > 0 {
                let offset = scrollViewOffsetY - lastScrollViewActionOffsetY
                if offset > pixelBuffer {
                    navigationBar(show: false)
                    lastScrollViewActionOffsetY = scrollViewOffsetY
                }
            } else {
                lastScrollViewActionOffsetY = scrollViewOffsetY
            }
        } else {
            if navBarIsHidden {
                let atBottom = Int(scrollViewOffsetY) >= Int(scrollView.contentSize.height - scrollView.bounds.height)
                if !atBottom {
                    let offset = lastScrollViewActionOffsetY - scrollViewOffsetY
                    if offset > pixelBuffer || scrollViewOffsetY <= 0 {
                        navigationBar(show: true)
                        lastScrollViewActionOffsetY = scrollViewOffsetY <= 0.0 ? 0.0 : scrollViewOffsetY
                    }
                }
            } else {
                lastScrollViewActionOffsetY = scrollViewOffsetY
            }
        }
        lastScrollViewOffsetY = scrollViewOffsetY
    }

    var navBarIsHidden: Bool {
        return constraintNavBar.constant != 0
    }

    func navigationBar(show: Bool) {
        constraintNavBar.constant = show ? 0 : -80
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            self.articleTopNavBar.isHidden = !show
        }

        if !show {
            articleTopNavBar.allOff()
        }
    }
}

// MARK: - Mark as Read
extension ArticleViewController {
    func checkMarkAsReadButton(_ read: Bool) {
        interactor.markArticleAsRead(read) { [weak self] in
            if let cell = self?.readButtonCell {
                cell.configure(selected: read)
            }
        }
    }
}

// MARK: - ArticleDelegate
extension ArticleViewController: ArticleDelegate {
    func didTapMarkAsRead(_ read: Bool) {
        let state: QDMUserEventTracking.Name = read ? .MARK_AS_READ : .MARK_AS_UNREAD
        trackUserEvent(state, value: interactor.remoteID, stringValue: .CONTENT, action: .TAP)
        interactor.markArticleAsRead(read) { [weak self] in
            self?.checkMarkAsReadButton(read)
        }
        didScrollToRead = true
    }

    func section() -> ContentSection {
        return interactor.section
    }
}

// MARK: - Audio Player Related
extension ArticleViewController {
    @objc func didEndAudio(_ notification: Notification) {
        tableView.reloadData()
    }
}

// MARK: - Contact support Related
extension ArticleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString.isEmail {
            interactor.openEmailComposer()
            return false
        }
        return true
    }
}
