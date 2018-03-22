//
//  ArticleItemViewController.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift
import Anchorage

protocol ArticleItemViewControllerDelegate: class {

    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: ArticleItemViewController)

    func didTapClose(in viewController: ArticleItemViewController)

    func didTapLink(_ url: URL, in viewController: ArticleItemViewController)

    func didTapMedia(withURL url: URL, in viewController: ArticleItemViewController)
}

final class ArticleItemViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let contentInsets: UIEdgeInsets
    private let fadeMaskLocation: UIView.FadeMaskLocation
    private let guideItem: Guide.Item?
    private var avPlayerObserver: AVPlayerObserver?
    let pageName: PageName
    var viewModel: ArticleItemViewModel
    weak var delegate: ArticleItemViewControllerDelegate?

    private lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
                           contentInsets: contentInsets,
                           delegate: self,
                           dataSource: self,
                           dequeables:
                            ContentItemTextTableViewCell.self,
                            ImageSubtitleTableViewCell.self,
                            ArticleRelatedCell.self,
                            ErrorCell.self)
    }()

    // MARK: - Init

    init(pageName: PageName,
         viewModel: ArticleItemViewModel,
         title: String? = nil,
         guideItem: Guide.Item? = nil,
         contentInsets: UIEdgeInsets,
         fadeMaskLocation: UIView.FadeMaskLocation) {
        self.pageName = pageName
        self.viewModel = viewModel
        self.contentInsets = contentInsets
        self.fadeMaskLocation = fadeMaskLocation
        self.guideItem = guideItem

        super.init(nibName: nil, bundle: nil)

        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setTableViewHeader()
        resizeHeaderView()
    }

    func reloadArticles(viewModel: ArticleItemViewModel) {
        self.viewModel = viewModel
        setTableViewHeader()
        resizeHeaderView()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(CGPoint(x: 0.0, y: -(tableView.tableHeaderView?.bounds.height ?? 0.0)), animated: false)
    }

    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()

        tableView.contentInset.top = view.safeMargins.top + Layout.statusBarHeight + Layout.paddingTop
        tableView.contentInset.bottom = view.safeMargins.bottom
        view.setFadeMask(at: fadeMaskLocation)
    }
}

// MARK: - Private

private extension ArticleItemViewController {

    func resizeHeaderView() {
        guard
            let headerView = tableView.tableHeaderView,
            let header = viewModel.articleHeader else { return }
        let sidePadding = CGFloat(56)
        let frameWidth = tableView.frame.size.width - sidePadding
        let titleHeight = calculateLabelHeight(text: header.articleTitle, font: Font.H5SecondaryHeadline, dispayedLineHeight: 18, frameWidth: frameWidth, characterSpacing: 1)
        let subTitleHeight = calculateLabelHeight(text: header.articleSubTitle, font: Font.H1MainTitle, dispayedLineHeight: 46, frameWidth: frameWidth, characterSpacing: 2)
        let dateHeight = CGFloat(14)
        let spacing: CGFloat = 20
        let height = titleHeight + subTitleHeight + dateHeight + spacing
        var headerFrame = headerView.frame

        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            tableView.tableHeaderView = headerView
        }
    }

    func calculateLabelHeight(text: String, font: UIFont, dispayedLineHeight: CGFloat, frameWidth: CGFloat, characterSpacing: CGFloat?) -> CGFloat {
        let lineHeight = "a".height(withConstrainedWidth: frameWidth, font: font)
        let headerHeight = text.height(withConstrainedWidth: frameWidth, font: font, characterSpacing: characterSpacing)

        return headerHeight / lineHeight * dispayedLineHeight
    }

    func setupView() {
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = (viewModel.backgroundImage == nil) ? R.image.backgroundSidebar() : viewModel.backgroundImage
        tableView.backgroundColor = .clear
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)
        view.translatesAutoresizingMaskIntoConstraints = true

        if
            let guideItem = guideItem,
            let featureLink = guideItem.featureLink, URLScheme.isSupportedURL(featureLink) == true {
                let button = featureLinkButton(guideItem: guideItem)
                view.addSubview(button)
                button.bottomAnchor == view.safeBottomAnchor
                button.centerXAnchor == view.centerXAnchor
                button.widthAnchor == 242
                button.heightAnchor == 45
                button.layer.cornerRadius = 45/2
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.azure.cgColor
                button.setTitleColor(.azure, for: .normal)
        }

        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.edgeAnchors == view.edgeAnchors
            tableView.contentInset.top = view.safeMargins.top + Layout.statusBarHeight + Layout.paddingTop
            tableView.contentInset.bottom = view.safeMargins.bottom
        } else {
            tableView.topAnchor == view.safeTopAnchor
            tableView.bottomAnchor == view.safeBottomAnchor
            tableView.leadingAnchor == view.leadingAnchor
            tableView.trailingAnchor == view.trailingAnchor
            tableView.contentInset.top = tableView.contentInset.top + Layout.paddingTop
        }

        tableView.bottomAnchor == view.safeBottomAnchor - 60
        tableView.estimatedSectionHeaderHeight = 100
        view.backgroundColor = .clear
        view.setFadeMask(at: fadeMaskLocation)
        view.layoutIfNeeded()
    }

    func featureLinkButton(guideItem: Guide.Item) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(openFeatureLink), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(guideItem.featureButton?.uppercased() ?? "", for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1, text: guideItem.featureButton ?? "")
        button.titleLabel?.font = Font.DPText
        button.titleLabel?.textAlignment = .center
        return button
    }

    @objc func openFeatureLink() {
        guard let url = guideItem?.featureLink else { return }
        LaunchHandler().process(url: url, guideItem: guideItem)
    }

    func setTableViewHeader() {
        guard let header = viewModel.articleHeader else { return }
        let nib = R.nib.articleItemHeaderView()
        guard let headerView = (nib.instantiate(withOwner: self, options: nil).first as? ArticleItemHeaderView) else {
            return
        }

        headerView.setupView(header: header)
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
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
                         placeholderURL: URL,
                         placeholderImage: UIImage? = R.image.preloading(),
                         attributedString: NSAttributedString,
                         canStream: Bool) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(placeHolder: placeholderURL, placeHolderImage: placeholderImage, description: attributedString, canStream: canStream)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        imageCell.backgroundColor = .clear
        imageCell.contentView.backgroundColor = .clear

        return imageCell
    }

    func imageTableViweCell(tableView: UITableView,
                            indexPath: IndexPath,
                            attributeString: NSAttributedString,
                            url: URL) -> ImageSubtitleTableViewCell {
        let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        imageCell.setupData(placeHolder: url, description: attributeString, canStream: false)
        imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
        imageCell.backgroundColor = .clear
        imageCell.contentView.backgroundColor = .clear

        return imageCell
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
            let item = viewModel.articleItem(at: indexPath)

            switch item.contentItemValue {
            case .audio(let title, _, let placeholderURL, _, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    placeholderURL: placeholderURL,
                    placeholderImage: R.image.audioPlaceholder(),
                    attributedString: Style.mediaDescription(title, .white60).attributedString(lineHeight: 2),
                    canStream: true
                )
            case .image(let title, _, let url):
                return imageTableViweCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    attributeString: Style.mediaDescription(title, .white60).attributedString(lineHeight: 2),
                    url: url
                )
            case .listItem(let text):
                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: item.contentItemValue.style(textStyle: .paragraph, text: text, textColor: .white),
                    bottomText: nil
                )
            case .text(let text, let style):
                var attributedTopText = item.contentItemValue.style(textStyle: style, text: text, textColor: .white)
                if style.headline == true {
                    attributedTopText = item.contentItemValue.style(textStyle: style, text: text.uppercased(), textColor: .white)
                } else if style == .paragraph {
                    attributedTopText = Style.article(text, .white).attributedString(lineHeight: 1.8)
                } else if style == .quote {
                    attributedTopText = Style.qoute(text, .white60).attributedString(lineHeight: 1.8)
                }

                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: attributedTopText,
                    bottomText: nil
                )
            case .video(let title, _, let placeholderURL, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    placeholderURL: placeholderURL,
                    placeholderImage: R.image.preloading(),
                    attributedString: Style.mediaDescription(title, .white60).attributedString(lineHeight: 2),
                    canStream: true
                )
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
            titleLabel.attributedText = Style.headlineSmall(R.string.localized.learnContentItemTitleRelatedArticles(), .white).attributedString(lineSpacing: 1.5)
            headerView.addSubview(titleLabel)

            return headerView
        }

        return nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            let item = viewModel.articleItem(at: indexPath)

            switch item.contentItemValue {
            case .audio(_, _, _, let remoteURL, _, _):
                let url = item.bundledAudioURL ?? remoteURL
                delegate?.didTapMedia(withURL: url, in: self)
            case .video(_, _, _, let videoURL, _):
                let playerViewController = stream(videoURL: videoURL)
                if let playerItem = playerViewController.player?.currentItem {
                    avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
                    avPlayerObserver?.onStatusUpdate { (player) in
                        if playerItem.status == .failed {
                            playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                        }
                    }
                }
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
