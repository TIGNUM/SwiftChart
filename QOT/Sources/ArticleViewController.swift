//
//  ArticleViewController.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol ArticleDelegate: class {
    func didTapMarkAsRead(_ read: Bool)
    func section() -> ContentSection
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

    var audioBackground: UIColor {
        switch self {
        case .dark: return .sand
        case .darkNot: return .carbon
        }
    }

    var audioText: UIColor {
        switch self {
        case .dark: return UIColor.carbon.withAlphaComponent(0.6)
        case .darkNot: return UIColor.sand.withAlphaComponent(0.6)
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

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .lightContent
        case .darkNot: return .default
        }
    }
}

final class ArticleViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: ArticleInteractorInterface?
    weak var delegate: ArticleItemViewControllerDelegate?
    private var header: Article.Header?
    private var audioButton = AudioButton()
    private weak var readButtonCell: MarkAsReadTableViewCell?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topTitleNavigationItem: UINavigationItem!
    @IBOutlet private weak var moreBarButtonItem: UIBarButtonItem!

    private lazy var customMoreButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(R.image.ic_more_unselected(), for: .normal)
        button.backgroundColor = UIColor.accent.withAlphaComponent(0.3)
        button.corner(radius: button.frame.width * 0.5)
        button.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        return button
    }()

    private lazy var bookMarkBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_bookmark(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTapBookmarkItem))
        item.width = view.frame.width * multiplier
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var nightModeBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_night_mode_unselected(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTapDarkModeItem))
        item.width = view.frame.width * multiplier
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var textScaleBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_text_scale(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTapTextScaleItem))
        item.width = view.frame.width * multiplier
        item.tintColor = colorMode.tint
        return item
    }()

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: R.image.ic_share_sand(),
                                   style: .plain,
                                   target: self,
                                   action: #selector(didTapShareItem))
        item.width = view.frame.width * multiplier
        item.tintColor = colorMode.tint
        return item
    }()

    private var multiplier: CGFloat {
        if interactor?.isShareable == true {
            return 0.2
        }
        return 0.25
    }

    private lazy var topBarButtonItems: [UIBarButtonItem] = {
        if interactor?.isShareable == true {
            var items = [bookMarkBarButtonItem, nightModeBarButtonItem, textScaleBarButtonItem, shareBarButtonItem]
            if interactor?.shouldHideBookmarkItem == true {
                items.remove(object: bookMarkBarButtonItem)
            }
            return items
        } else if interactor?.section == .About {
            return [nightModeBarButtonItem, textScaleBarButtonItem]
        } else {
            var items = [bookMarkBarButtonItem, nightModeBarButtonItem, textScaleBarButtonItem]
            if interactor?.shouldHideBookmarkItem == true {
                items.remove(object: bookMarkBarButtonItem)
            }
            return items
        }
    }()

    private var lastScrollViewOffsetY: CGFloat = 0.0
    private var lastScrollViewActionOffsetY: CGFloat = 0.0
    private var didScrollToRead = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
        setColorMode()
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
        pageTrack.associatedValueId = interactor?.remoteID
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }
}

// MARK: - Private

private extension ArticleViewController {
    func setupTableView() {
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedCell.self)
        tableView.registerDequeueable(LearnPDFCell.self)
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
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.estimatedSectionHeaderHeight = interactor?.sectionHeaderHeight ?? 0
        tableView.backgroundColor = .clear
    }

    func setupAudioItem() {
        guard let audioItem = interactor?.audioItem else { return }
        audioButton = AudioButton.instantiateFromNib()
        audioButton.configure(categoryTitle: interactor?.categoryTitle ?? "",
                              title: interactor?.title ?? "",
                              audioURL: interactor?.audioURL,
                              remoteID: audioItem.remoteID,
                              duration: audioItem.type.duration)
    }

    func setColorMode() {
        colorModeIsActive = true
        ThemeAppearance.setNavigationBar()
        setStatusBar(colorMode: colorMode)
        ThemeView.articleBackground(nil).apply(view)
        ThemeAppearance.setNavigation(bar: navigationController?.navigationBar, theme: .articleBackground(nil))

        audioButton.setColorMode()
        view.bringSubview(toFront: audioButton)
        refreshBottomNavigationItems()
    }

    func updateMoreButton(customView: UIView?) {
        moreBarButtonItem.customView = customView
    }

    func moreTopNavAdd() {
        updateMoreButton(customView: customMoreButton)
        topTitleNavigationItem.setLeftBarButtonItems(topBarButtonItems, animated: true)
        topTitleNavigationItem.title = nil
    }

    func moreTopNavRemove() {
        updateMoreButton(customView: nil)
        topTitleNavigationItem.setLeftBarButtonItems([], animated: true)
        if topTitleNavigationItem.title == nil {
            if (tableView.visibleCells.filter { $0.tag == 111 }).isEmpty == true {
                topTitleNavigationItem.title = header?.title
            }
        }
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - BottomNavigation
extension ArticleViewController {
    @objc override public func didTapDismissButton() {
        dismiss(animated: true, completion: nil)
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if self.interactor?.audioItem != nil {
            setupAudioItem()
            return [UIBarButtonItem(customView: audioButton)]
        }
        return nil
    }
}

// MARK: - Actions

private extension ArticleViewController {

    @IBAction func didTapMoreButton() {
        if topTitleNavigationItem.leftBarButtonItems == nil || topTitleNavigationItem.leftBarButtonItems?.isEmpty == true {
            moreTopNavAdd()
        } else {
            moreTopNavRemove()
        }
    }

    @objc func didTapBookmarkItem() {
        trackUserEvent(.BOOKMARK, value: interactor?.remoteID, valueType: .CONTENT, action: .TAP)
        interactor?.toggleBookmark()
    }

    @objc func didTapDarkModeItem() {
        trackUserEvent(.COLOR_MODE, value: interactor?.remoteID, valueType: .CONTENT, action: .TAP)
        colorMode = colorMode == .dark ? .darkNot : .dark
        setColorMode()
        tableView.reloadData()
        moreTopNavRemove()
    }

    @objc func didTapTextScaleItem() {
        trackUserEvent(.FONT_SIZE, value: interactor?.remoteID, valueType: .CONTENT, action: .TAP)
        textScale = textScale == .scaleNot ? .scale : .scaleNot
        tableView.reloadData()
        moreTopNavRemove()
    }

    @objc func didTapShareItem() {
        trackUserEvent(.SHARE, value: interactor?.remoteID, valueType: .CONTENT, action: .TAP)
        guard let whatsHotShareable = interactor?.whatsHotShareable else { return }
        let activityVC = UIActivityViewController(activityItems: [whatsHotShareable], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

// MARK: - ArticleViewControllerInterface

extension ArticleViewController: ArticleViewControllerInterface {
    func reloadData() {
        self.view.removeLoadingSkeleton()
        navigationBar(show: true)
        tableView.reloadData()
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 10, height: 1), animated: true)
        setupAudioItem()
        refreshBottomNavigationItems()
    }

    func setupArticleHeader(header: Article.Header) {
        self.header = header
    }

    func setupView() {
        setupTableView()
        setColorMode()
        self.view.showLoadingSkeleton(with: [.fiveLinesWithTopBroad, .oneLineBlock, .oneLineBlock, .oneLineBlock])
    }

    func hasBookmark(_ hasBookmark: Bool) {
        bookMarkBarButtonItem.image = hasBookmark ? R.image.ic_bookmark_fill() : R.image.ic_bookmark()
    }
}

// MARK: - Transition

extension ArticleViewController {
    func transitionArticle(remoteID: Int) {
        if let image = view.screenshot() {
            let shot = UIImageView(image: image)
            shot.tag = 871234
            view.addSubview(shot)
        }

        interactor?.showRelatedArticle(remoteID: remoteID)
        reloadData()
    }

    func dataUpdated() {
        navigationController?.setNavigationBarHidden(interactor?.shouldHideTopBar ?? false, animated: true)
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

    func mediaStreamCell(tableView: UITableView,
                         indexPath: IndexPath,
                         title: String,
                         imageURL: URL?,
                         placeholderImage: UIImage? = R.image.preloading(),
                         attributedString: NSAttributedString,
                         canStream: Bool) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(imageURL: imageURL,
                            placeholderImage: placeholderImage,
                            description: attributedString,
                            canStream: canStream)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        return imageCell
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

    func PDFTableViewCell(tableView: UITableView,
                          indexPath: IndexPath,
                          attributedString: NSAttributedString,
                          timeToReadSeconds: Int) -> LearnPDFCell {
        let cell: LearnPDFCell = tableView.dequeueCell(for: indexPath)
        cell.backgroundColor = .clear
        cell.configure(titleText: attributedString,
                       timeToReadSeconds: timeToReadSeconds,
                       titleColor: .white,
                       timeColor: .gray)
        return cell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath, item: Article.Item) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent(), item: item)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func relatedArticleCell(tableView: UITableView, indexPath: IndexPath) -> ArticleRelatedWhatsHotTableViewCell {
        let relatedArticleCell: ArticleRelatedWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
        let relatedArticle = interactor?.relatedArticle(at: indexPath)
        relatedArticleCell.configure(title: relatedArticle?.title,
                                     publishDate: relatedArticle?.publishDate,
                                     author: relatedArticle?.author,
                                     timeToRead: relatedArticle?.timeToRead,
                                     imageURL: relatedArticle?.imageURL,
                                     isNew: relatedArticle?.isNew ?? false,
                                     forcedColorMode: nil)
        return relatedArticleCell
    }

    func emptyCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func sectionHasContent(_ section: Int) -> Bool {
        let numRows = interactor?.itemCount(in: section) ?? 0
        let title = interactor?.headerTitle(for: section) ?? ""
        return !title.isEmpty && numRows > 0
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.sectionCount ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText: topTitleNavigationItem.title = nil
        default: break
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .headerText:
            topTitleNavigationItem.setLeftBarButtonItems([], animated: true)
            topTitleNavigationItem.title = header?.title
        default: return
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.articleItem(at: indexPath) else {
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
        case .audio(remoteId: _, title: _, description: _, placeholderURL: _, audioURL: _, duration: _, waveformData:_):
            return UITableViewCell()    //audio is only shown in the audio bar
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
                attributedTopText = ThemeText.articleBody.attributedString(text, lineHeight: 1.8)
            } else if style == .quote {
                attributedTopText = ThemeText.articleQuote.attributedString(text, lineHeight: 1.8)
            }
            return articleItemTextViewCell(tableView: tableView,
                                           indexPath: indexPath,
                                           topText: attributedTopText)
        case .video(_, let title, _, let placeholderURL, _, let duration):
            let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
            let cell: FoundationTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, timeToWatch: mediaDescription, imageURL: placeholderURL, forcedColorMode: nil)
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
            cell.configure(selected: true)
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
            cell.configure(header: R.string.localized.learnArticleItemNextUp(),
                           title: title,
                           durationString: description,
                           icon: R.image.ic_seen_of())
            return cell
        default:
            return invalidContentCell(tableView: tableView, indexPath: indexPath, item: item)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = interactor?.articleItem(at: indexPath) else {
            return UITableViewAutomaticDimension
        }
        switch item.type {
        case .articleRelatedWhatsHot: return 215
        case .pdf,
             .articleRelatedStrategy: return 95
        case .articleNextUp: return 144
        case .audio(remoteId: _, title: _, description: _, placeholderURL: _, audioURL: _, duration: _, waveformData:_):
            return 0
        default: return UITableViewAutomaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = interactor?.articleItem(at: indexPath) else { return }
        switch item.type {
        case .audio(_, _, _, _, let remoteURL, _, _):
            let url = item.bundledAudioURL ?? remoteURL
            delegate?.didTapMedia(withURL: url, in: self)
        case .video(let remoteID, _, _, _, let videoURL, _):
            qot_dal.ContentService.main.getContentItemById(remoteID) { [weak self] (contentItem) in
                guard let item = contentItem else { return }
                self?.stream(videoURL: videoURL, contentItem: item)
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
        if !sectionHasContent(section) {
            return nil
        }

        guard let headerTitle = interactor?.headerTitle(for: section) else {
            return nil
        }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.estimatedSectionHeaderHeight))
        headerView.backgroundColor = .clear
        if interactor?.sectionNeedsLine ?? false {
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
        return sectionHasContent(section) ? tableView.estimatedSectionHeaderHeight : 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionCount = interactor?.sectionCount ?? 1
        return section == sectionCount - 1 ? 80.0 : 0.0
    }
}

// MARK: - ClickableLabelDelegate

extension ArticleViewController: ClickableLabelDelegate {
    func openLink(withURL url: URL) {
        interactor?.didTapLink(url)
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
        guard let navBar = navigationController?.navigationBar,
            let shouldHideNavBar = interactor?.shouldHideTopBar,
            shouldHideNavBar == false else {
            return
        }

        let pixelBuffer: CGFloat = 50
        let scrollViewOffsetY = scrollView.contentOffset.y
        let movingUp = lastScrollViewOffsetY < scrollViewOffsetY
        navBar.isTranslucent = false
        if movingUp {
            if !navBar.isHidden && scrollViewOffsetY > 0 {
                let offset = scrollViewOffsetY - lastScrollViewActionOffsetY
                if offset > pixelBuffer {
                    navigationBar(show: false)
                    lastScrollViewActionOffsetY = scrollViewOffsetY
                }
            } else {
                lastScrollViewActionOffsetY = scrollViewOffsetY
            }
        } else {
            if navBar.isHidden {
                let atBottom = scrollViewOffsetY >= scrollView.contentSize.height - scrollView.bounds.height
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

    func navigationBar(show: Bool) {
        guard let nav = navigationController else {
            return
        }
        nav.setNavigationBarHidden(!show, animated: true)
        let height = show ? nav.navigationBar.frame.size.height : 0
        UIView.animate(withDuration: Double(UINavigationControllerHideShowBarDuration)) {
            self.tableView.contentInset = UIEdgeInsets(top: -height, left: 0.0, bottom: 0.0, right: 0.0)
        }
        if !show {
            moreTopNavRemove()
        }
    }
}

// MARK: - Mark as Read
extension ArticleViewController {
    func checkMarkAsReadButton(_ read: Bool) {
        guard let interactor = interactor else { return }

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
        interactor?.markArticleAsRead(read) { [weak self] in
            self?.checkMarkAsReadButton(read)
        }
        didScrollToRead = read
    }

    func section() -> ContentSection {
        return interactor?.section ?? .Unkown
    }
}

// MARK: - Audio Player Related
extension ArticleViewController {
    @objc func didEndAudio(_ notification: Notification) {
        tableView.reloadData()
    }
}
