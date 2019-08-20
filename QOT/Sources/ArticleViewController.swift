//
//  ArticleViewController.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import AMScrollingNavbar

protocol ArticleDelegate: class {
    func didTapMarkAsRead(_ read: Bool)
}

var colorMode = ColorMode.dark
var textScale = TextScale.scaleNot

enum ColorMode {
    case dark
    case darkNot

    var background: UIColor {
        switch self {
        case .dark: return .carbon
        case .darkNot: return .sand
        }
    }

    var audioBackground: UIColor {
        switch self {
        case .dark: return .sand
        case .darkNot: return .carbonDark
        }
    }

    var audioVissualEffect: UIBlurEffect.Style {
        switch self {
        case .dark: return .dark
        case .darkNot: return .light
        }
    }

    var audioText: UIColor {
        switch self {
        case .darkNot: return UIColor.carbon.withAlphaComponent(0.6)
        case .dark: return UIColor.sand.withAlphaComponent(0.6)
        }
    }

    var fade: UIColor {
        switch self {
        case .dark: return UIColor.carbon.withAlphaComponent(0.1)
        case .darkNot: return UIColor.sand.withAlphaComponent(0.1)
        }
    }

    var seperator: UIColor {
        switch self {
        case .dark: return UIColor.sand.withAlphaComponent(0.1)
        case .darkNot: return UIColor.carbon.withAlphaComponent(0.1)
        }
    }

    var tint: UIColor {
        switch self {
        case .dark: return .accent
        case .darkNot: return .accent
        }
    }

    var text: UIColor {
        switch self {
        case .dark: return .sand
        case .darkNot: return .carbonDark
        }
    }

    var statusBarStyle: UIStatusBarStyle {
        switch self {
        case .dark: return .lightContent
        case .darkNot: return .default
        }
    }
}

enum TextScale {
    case scale
    case scaleNot

    var categoryHeadline: UIFont {
        switch self {
        case .scale: return .sfProtextMedium(ofSize: 14)
        case .scaleNot: return .sfProtextMedium(ofSize: 12)
        }
    }

    var contentHeadline: UIFont {
        switch self {
        case .scale: return .sfProDisplayLight(ofSize: 40)
        case .scaleNot: return .sfProDisplayLight(ofSize: 34)
        }
    }

    var details: UIFont {
        switch self {
        case .scale: return .sfProtextMedium(ofSize: 14)
        case .scaleNot: return .sfProtextMedium(ofSize: 12)
        }
    }

    var bullet: UIFont {
        switch self {
        case .scale: return .sfProtextLight(ofSize: 24)
        case .scaleNot: return .sfProtextLight(ofSize: 16)
        }
    }

    var content: UIFont {
        switch self {
        case .scale: return .sfProtextRegular(ofSize: 24)
        case .scaleNot: return .sfProtextRegular(ofSize: 16)
        }
    }
}

final class ArticleNavigationController: ScrollingNavigationController {}

final class ArticleViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: ArticleInteractorInterface?
    weak var delegate: ArticleItemViewControllerDelegate?
    private var header: Article.Header?
    private var audioButton = AudioButton()
    private var currentFadeView = GradientView(colors: [], locations: [])
    private var readButtonIndexPath: IndexPath?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topTitleNavigationItem: UINavigationItem!
    @IBOutlet private weak var moreBarButtonItem: UIBarButtonItem!
//    @IBOutlet private weak var closeButton: UIButton!

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
            return [bookMarkBarButtonItem,
                    nightModeBarButtonItem,
                    textScaleBarButtonItem,
                    shareBarButtonItem]
        }
        return [bookMarkBarButtonItem,
                nightModeBarButtonItem,
                textScaleBarButtonItem]
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return colorMode.statusBarStyle
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50)
        }
        setColorMode()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setStatusBar(colorMode: ColorMode.darkNot)
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
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.apercuMedium(ofSize: 20),
                                                            .foregroundColor: colorMode.text]
        setStatusBar(colorMode: colorMode)
        navigationController?.navigationBar.barTintColor = colorMode.background
        view.backgroundColor = colorMode.background
        tableView.backgroundColor = colorMode.background
        currentFadeView.removeFromSuperview()
        currentFadeView = view.addFadeView(at: .bottom,
                                           height: 120,
                                           primaryColor: colorMode.background,
                                           fadeColor: colorMode.fade)
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
        (navigationController as? ScrollingNavigationController)?.showNavbar(animated: true, duration: 0.3)
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
        (navigationController as? ScrollingNavigationController)?.scrollingNavbarDelegate = self
    }

    func hasBookmark(_ hasBookmark: Bool) {
        bookMarkBarButtonItem.image = hasBookmark ? R.image.ic_bookmark_fill() : R.image.ic_bookmark()
    }
}

// MARK: - Cells

extension ArticleViewController {
    func articleItemTextViewCell(tableView: UITableView,
                                 indexPath: IndexPath,
                                 topText: NSAttributedString,
                                 bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
        let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
        itemTextCell.setup(topText: topText, bottomText: bottomText, delegate: self)
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

    func imageTableViweCell(tableView: UITableView,
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
                                     colorMode: colorMode)
        return relatedArticleCell
    }

    func emptyCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL) {
        trackUserEvent(.OPEN, value: itemID, valueType: .CONTENT_ITEM, action: .TAP)
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title ?? "", url: url)
        pdfReaderConfigurator(readerViewController)
        present(navigationController, animated: true, completion: nil)
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
        case .button:
            if let markAsReadCell = cell as? MarkAsReadTableViewCell {
                markAsReadCell.setMarkAsReadStatus(read: true)
            }
        default: return
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
            cell.configure(articleHeader: header)
            return cell
        case .headerImage(let imageURLString):
            let cell: ArticleImageHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(imageURLString: imageURLString)
            return cell
        case .audio(_, let title, _, let imageURL, _, _, _):
            return mediaStreamCell(
                tableView: tableView,
                indexPath: indexPath,
                title: title,
                imageURL: imageURL,
                placeholderImage: R.image.audioPlaceholder(),
                attributedString: Style.mediaDescription(title,
                                                         colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                canStream: true)
        case .image(let title, _, let url):
            return imageTableViweCell(
                tableView: tableView,
                indexPath: indexPath,
                attributeString: Style.mediaDescription(title,
                                                        colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 2),
                url: url)
        case .listItem(let bullet):
            let cell: ArticleBulletPointTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(bullet: bullet)
            return cell
        case .text(let text, let style):
            var attributedTopText = item.type.style(textStyle: style,
                                                    text: text,
                                                    textColor: colorMode.text)
            if style.headline == true {
                attributedTopText = item.type.style(textStyle: style,
                                                    text: text.uppercased(),
                                                    textColor: colorMode.text)
            } else if style == .paragraph {
                attributedTopText = Style.article(text, colorMode.text).attributedString(lineHeight: 1.8)
            } else if style == .quote {
                attributedTopText = Style.qoute(text,
                                                colorMode.text.withAlphaComponent(0.6)).attributedString(lineHeight: 1.8)
            }
            return articleItemTextViewCell(tableView: tableView,
                                           indexPath: indexPath,
                                           topText: attributedTopText,
                                           bottomText: nil)
        case .video(_, let title, _, let placeholderURL, _, let duration):
            let mediaDescription = String(format: "%@ (%02i:%02i)", title, Int(duration) / 60 % 60, Int(duration) % 60)
            let cell: FoundationTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, timeToWatch: mediaDescription, imageURL: placeholderURL)
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
                           colorMode: colorMode)
            return cell
        case .button(let selected):
            let cell: MarkAsReadTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(selected: selected)
            cell.delegate = self
            readButtonIndexPath = indexPath
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
        case .video(_, _, _, _, let videoURL, _):
            let playerViewController = stream(videoURL: videoURL, contentItem: nil, pageName: PageName.search)
            if let playerItem = playerViewController.player?.currentItem {
                let avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
                avPlayerObserver.onStatusUpdate { (player) in
                    if playerItem.status == .failed {
                        playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                    }
                }
            }
        case .pdf(let title, _, let pdfURL, let itemID):
            didTapPDFLink(title, itemID, pdfURL)
            trackUserEvent(.OPEN, value: itemID, valueType: .CONTENT_ITEM, action: .TAP)
        case .articleRelatedWhatsHot(let relatedArticle):
            interactor?.showRelatedArticle(remoteID: relatedArticle.remoteID)
            trackUserEvent(.OPEN, value: relatedArticle.remoteID, valueType: .CONTENT, action: .TAP)
        case .articleRelatedStrategy(_, _, let remoteID),
             .articleNextUp(_, _, let remoteID):
            interactor?.showRelatedArticle(remoteID: remoteID)
            trackUserEvent(.OPEN, value: remoteID, valueType: .CONTENT, action: .TAP)
        default: return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerTitle = interactor?.headerTitle(for: section) else {
            return nil
        }

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.estimatedSectionHeaderHeight))
        headerView.backgroundColor = .clear
        if interactor?.sectionNeedsLine ?? false {
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1.0))
            lineView.backgroundColor = colorMode.text.withAlphaComponent(0.1)
            headerView.addSubview(lineView)
        }
        let titleLabel = UILabel(frame: CGRect(x: 28, y: headerView.frame.size.height - 18.0, width: view.frame.width, height: 18))
        titleLabel.attributedText = NSAttributedString(string: headerTitle,
                                                       letterSpacing: 1.5,
                                                       font: .sfProtextMedium(ofSize: 14),
                                                       textColor: colorMode.text.withAlphaComponent(0.4),
                                                       alignment: .left)
        headerView.addSubview(titleLabel)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (interactor?.headerTitle(for: section) ?? "").isEmpty ? 0 : tableView.estimatedSectionHeaderHeight
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
        guard let interactor = interactor else {
            return
        }
        if !interactor.isRead {
            interactor.markArticleAsRead(true)
            if let indexPath = readButtonIndexPath {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}

// MARK: - ArticleDelegate
extension ArticleViewController: ArticleDelegate {
    func didTapMarkAsRead(_ read: Bool) {
        interactor?.markArticleAsRead(read)
    }
}

// MARK: - Audio Player Related
extension ArticleViewController {
    @objc func didEndAudio(_ notification: Notification) {
        tableView.reloadData()
    }
}

extension ArticleViewController: ScrollingNavigationControllerDelegate {
    @objc func scrollingNavigationController(_ controller: ScrollingNavigationController, willChangeState state: NavigationBarState) {
        if state != .expanded {
            moreTopNavRemove()
        }
    }
}
