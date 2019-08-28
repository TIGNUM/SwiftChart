//
//  ArticleItemViewController.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift

protocol ArticleItemViewControllerDelegate: class {
    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: UIViewController)
    func didTapClose(in viewController: UIViewController)
    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL, in viewController: UIViewController)
    func didTapLink(_ url: URL, in viewController: UIViewController)
    func didTapMedia(withURL url: URL, in viewController: UIViewController)
    func didTapShare(header: ArticleCollectionHeader)
}

final class ArticleItemViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var button: UIButton!

    private let contentInsets: UIEdgeInsets
    private let fadeMaskLocation: UIView.FadeMaskLocation
    private let guideItem: Guide.Item?
    private var isNewLayout: Bool = false
    private var avPlayerObserver: AVPlayerObserver?
    static var page: PageName = .whatsHotArticle
    var viewModel: ArticleItemViewModel
    weak var delegate: ArticleItemViewControllerDelegate?

    private var paddingTop: CGFloat {
        switch pageName {
        case .libraryArticle,
             .featureExplainer: return Layout.padding_24
        case .whatsHotArticle: return view.safeMargins.top
        default: return 0
        }
    }

    // MARK: - Init

    init(viewModel: ArticleItemViewModel,
         title: String? = nil,
         guideItem: Guide.Item? = nil,
         contentInsets: UIEdgeInsets,
         fadeMaskLocation: UIView.FadeMaskLocation) {
        self.viewModel = viewModel
        self.contentInsets = contentInsets
        self.fadeMaskLocation = fadeMaskLocation
        self.guideItem = guideItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerDequeueable(TitleTableViewCell.self)
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ArticleRelatedCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        tableView.registerDequeueable(LearnPDFCell.self)
        tableView.registerDequeueable(ErrorCell.self)
        isNewLayout = true
        setupView()
        // change background color in new layout
        view.backgroundColor = isNewLayout ? .carbon : .navy
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        viewModel.markContentAsRead()
        // hide the navigation bar in new layout
        self.navigationController?.setNavigationBarHidden(isNewLayout, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTableViewHeader()
        resizeHeaderView()
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        tableView.contentInset.bottom = view.safeMargins.bottom
    }
}

// MARK: - Private

private extension ArticleItemViewController {

    func resizeHeaderView() {
        guard let headerView = tableView.tableHeaderView, let header = viewModel.articleHeader else { return }
        let sidePadding = CGFloat(48)
        let frameWidth = tableView.frame.size.width - sidePadding
        let titleHeight = viewModel.isWhatsHot ? 0 : calculateLabelHeight(text: header.articleTitle,
                                                                          font: .H5SecondaryHeadline,
                                                                          dispayedLineHeight: 18,
                                                                          frameWidth: frameWidth,
                                                                          characterSpacing: 1)
        let subTitleHeight = calculateLabelHeight(text: header.articleSubTitle,
                                                  font: (headerView as? ArticleItemHeaderView)?.resizedFont() ?? .H1MainTitle,
                                                  dispayedLineHeight: 46,
                                                  frameWidth: frameWidth,
                                                  characterSpacing: 2)
        let dateHeight: CGFloat = viewModel.isWhatsHot ? 66 : 14
        let spacing: CGFloat = 16
        let minimumHeight: CGFloat = viewModel.isWhatsHot ? 390 : 150
        let imageHeight: CGFloat = viewModel.isWhatsHot ? 200 : 0
        let height = max(titleHeight + subTitleHeight + dateHeight + spacing + imageHeight, minimumHeight)
        var headerFrame = headerView.frame
        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
        }
    }

    func calculateLabelHeight(text: String,
                              font: UIFont,
                              dispayedLineHeight: CGFloat,
                              frameWidth: CGFloat,
                              characterSpacing: CGFloat?) -> CGFloat {
        let lineHeight = "a".height(withConstrainedWidth: frameWidth, font: font)
        let headerHeight = text.height(withConstrainedWidth: frameWidth, font: font, characterSpacing: characterSpacing)
        return headerHeight / lineHeight * dispayedLineHeight
    }

    func setupView() {
        if
            let guideItem = guideItem,
            let featureLink = guideItem.link,
            guideItem.featureButton != nil,
            guideItem.identifier != "learn#119928",
            guideItem.featureLink?.absoluteString != "qot://morning-interview?groupID=",
            URLScheme.isSupportedURL(featureLink) == true {
            featureLinkButton(guideItem: guideItem)
            button.layer.borderColor = UIColor.azure.cgColor
            button.setTitleColor(.azure, for: .normal)
            button.titleLabel?.font = .ApercuBold16
            button.contentHorizontalAlignment = .right
        }
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.contentInset.top = paddingTop
            tableView.contentInset.bottom = view.safeMargins.bottom
        } else {
            tableView.contentInset.top = paddingTop
        }
        tableView.estimatedSectionHeaderHeight = 100
        view.backgroundColor = .carbon
    }

    func featureLinkButton(guideItem: Guide.Item) {
        button.addTarget(self, action: #selector(openFeatureLink), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(guideItem.featureButton?.uppercased() ?? "", for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1, text: guideItem.featureButton ?? "")
        button.titleLabel?.font = .DPText
        button.titleLabel?.textAlignment = .center
    }

    @objc func openFeatureLink() {
        guard let url = guideItem?.featureLink else { return }
        LaunchHandler().process(url: url, guideItem: guideItem, articleItemController: self)
    }

    func setTableViewHeader() {
        guard let header = viewModel.articleHeader else { return }
        let nib = viewModel.isWhatsHot ? UINib(resource: R.nib.whatsHotArticleHeaderView) : UINib(resource: R.nib.articleItemHeaderView)
        guard let headerView = (nib.instantiate(withOwner: self, options: nil).first as? ArticleItemHeaderView) else {
            return
        }
        headerView.setupView(header: header, pageName: pageName, delegate: delegate)
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
    }

    func topBarTextTableViewCell(tableView: UITableView,
                                      indexPath: IndexPath,
                                      title: String) -> TitleTableViewCell {
        let itemTextCell: TitleTableViewCell = tableView.dequeueCell(for: indexPath)
        let config = TitleTableViewCell.Config(backgroundColor: .carbon, titlefont: .sfProtextMedium(ofSize: 12), titleTextColor: .sand30, isArrowHidden: true, isSeparatorHidden: true, bottomMargin: 16, topMargin: 20)
        itemTextCell.config = config
        itemTextCell.title = title
        return itemTextCell
    }

    func contentItemTextTableViewCell(tableView: UITableView,
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

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath, item: ContentItem) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent(), item: item)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }

    func relatedArticleCell(tableView: UITableView, indexPath: IndexPath) -> ArticleRelatedCell {
        let relatedArticleCell: ArticleRelatedCell = tableView.dequeueCell(for: indexPath)
        let relatedArticle = viewModel.relatedArticle(at: indexPath)
        let date = Date().addingTimeInterval(TimeInterval(relatedArticle.minutesToRead * 60))
        let subtitle = DateComponentsFormatter.timeIntervalToString(date.timeIntervalSinceNow, isShort: true) ?? ""
        relatedArticleCell.setupView(title: relatedArticle.title, subTitle: subtitle, previewImageURL: relatedArticle.thumbnailURL)
        log("time: \(subtitle)")
        return relatedArticleCell
    }

    func emptyCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ArticleItemViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 && viewModel.topSmallTitle != nil {
                return topBarTextTableViewCell(tableView: tableView, indexPath: indexPath, title: viewModel.topSmallTitle ?? "Faq")
            }
            let item = viewModel.articleItem(at: indexPath)
            switch item.contentItemValue {
            case .audio(_, let title, _, let imageURL, _, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    imageURL: imageURL,
                    placeholderImage: R.image.audioPlaceholder(),
                    attributedString: Style.mediaDescription(title).attributedString(lineHeight: 2),
                    canStream: true)
            case .image(let title, _, let url):
                return imageTableViweCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    attributeString: Style.mediaDescription(title).attributedString(lineHeight: 2),
                    url: url)
            case .listItem(let text):
                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: item.contentItemValue.theme(textStyle: .paragraph).attributedString(text),
                    bottomText: nil)
            case .text(let text, let style):
                var attributedTopText = item.contentItemValue.theme(textStyle: style).attributedString(text)
                if style.headline == true {
                    attributedTopText = item.contentItemValue.theme(textStyle: style).attributedString(text.uppercased())
                } else if style == .paragraph {
                    attributedTopText = Style.article(text).attributedString(lineHeight: 1.8)
                } else if style == .quote {
                    attributedTopText = Style.quote(text).attributedString(lineHeight: 1.8)
                }

                return contentItemTextTableViewCell(tableView: tableView,
                                                    indexPath: indexPath,
                                                    topText: attributedTopText,
                                                    bottomText: nil)
            case .video(_, let title, _, let placeholderURL, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    imageURL: placeholderURL,
                    attributedString: Style.mediaDescription(title).attributedString(lineHeight: 2),
                    canStream: true)
            case .pdf(let title, _, _, _):
                return PDFTableViewCell(tableView: tableView,
                                        indexPath: indexPath,
                                        attributedString: item.contentItemValue.theme(textStyle: .h4).attributedString(title),
                                        timeToReadSeconds: item.secondsRequired)
            case .guide,
                 .guideButton:
                return emptyCell(tableView: tableView, indexPath: indexPath)
            default:
                return invalidContentCell(tableView: tableView, indexPath: indexPath, item: item)
            }
        case 1:
            return relatedArticleCell(tableView: tableView, indexPath: indexPath)
        default: fatalError("Wrong Section!")
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: tableView.estimatedSectionHeaderHeight))
            headerView.backgroundColor = .clear
            let titleLabel = UILabel(frame: CGRect(x: 28, y: 60, width: view.frame.width, height: 18))
            titleLabel.attributedText = Style.headlineSmall(R.string.localized.learnContentItemTitleRelatedArticles()).attributedString(lineSpacing: 1.5)
            headerView.addSubview(titleLabel)
            return headerView
        }

        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 && viewModel.topSmallTitle != nil { return }
            let item = viewModel.articleItem(at: indexPath)

            switch item.contentItemValue {
            case .audio(_, _, _, _, let remoteURL, _, _):
                let url = item.bundledAudioURL ?? remoteURL
                delegate?.didTapMedia(withURL: url, in: self)
            case .video(_, _, _, _, let videoURL, _):
                let playerViewController = stream(videoURL: videoURL,
                                                  contentItem: nil,
                                                  pageName)
                if let playerItem = playerViewController.player?.currentItem {
                    avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
                    avPlayerObserver?.onStatusUpdate { (player) in
                        if playerItem.status == .failed {
                            playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                        }
                    }
                }
            case .pdf(let title, _, let pdfURL, let itemID):
                delegate?.didTapPDFLink(title, itemID, pdfURL, in: self)
            default: return
            }
        case 1:
            delegate?.didSelectRelatedArticle(selectedArticle: viewModel.relatedArticle(at: indexPath), form: self)
        default: return
        }
    }
}

// MARK: - ClickableLabelDelegate

extension ArticleItemViewController: ClickableLabelDelegate {

    func openLink(withURL url: URL) {
        self.delegate?.didTapLink(url, in: self)
    }
}

extension ArticleItemViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -(view.frame.height * 0.25) {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Bottom Navigation
extension ArticleItemViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }
}
