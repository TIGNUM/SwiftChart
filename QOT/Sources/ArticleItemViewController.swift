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

final class ArticleItemViewController: UIViewController {

    // MARK: - Properties

    fileprivate let contentInsets: UIEdgeInsets
    let pageName: PageName
    var viewModel: ArticleItemViewModel
    weak var delegate: ArticleItemViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(
            style: .grouped,
            contentInsets: self.contentInsets,
            delegate: self,
            dataSource: self,
            dequeables:
                ContentItemTextTableViewCell.self,
                ImageSubtitleTableViewCell.self,
                ArticleRelatedCell.self,
                ErrorCell.self
            )

        return tableView
    }()

    // MARK: - Init

    init(pageName: PageName, viewModel: ArticleItemViewModel, title: String? = nil, contentInsets: UIEdgeInsets) {
        self.pageName = pageName
        self.viewModel = viewModel
        self.contentInsets = contentInsets

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
        tableView.tableHeaderView = nil
        setTableViewHeader()
        tableView.reloadData()
        let sections = tableView.numberOfSections
        let rowsInSection = tableView.numberOfRows(inSection: 0)

        if 0 < sections && 0 < rowsInSection {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Private

private extension ArticleItemViewController {

    func resizeHeaderView() {
        guard
            let headerView = tableView.tableHeaderView,
            let header = viewModel.articleHeader else {
                return
        }

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
        let backgroundImage = (viewModel.backgroundImage != nil) ? viewModel.backgroundImage : R.image.backgroundWhatsHot()
        tableView.backgroundView = UIImageView(image: backgroundImage)
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.estimatedSectionHeaderHeight = 100
        view.backgroundColor = .clear
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.layoutIfNeeded()
        view.layoutIfNeeded()
        view.applyFade()
    }

    func setTableViewHeader() {
        guard let header = viewModel.articleHeader else {
            return
        }

        let nib = R.nib.articleItemHeaderView()
        guard let headerView = (nib.instantiate(withOwner: self, options: nil).first as? ArticleItemHeaderView) else {
            return
        }

        headerView.setupView(header: header)
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
    }

    func contentItemTextTableViewCell(
        tableView: UITableView,
        indexPath: IndexPath,
        topText: NSAttributedString,
        bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
            let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
            itemTextCell.setup(topText: topText, bottomText: bottomText, delegate: self)
            itemTextCell.backgroundColor = .clear
            itemTextCell.contentView.backgroundColor = .clear

            return itemTextCell
    }

    func mediaStreamCell(
        tableView: UITableView,
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

    func imageTableViweCell(
        tableView: UITableView,
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
        relatedArticleCell.setupView(title: relatedArticle.title, subTitle: Date().timeToDateAsString(date), previewImageURL: relatedArticle.thumbnailURL)

        print("time: \(Date().timeToDateAsString(date))")

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
                if style == .paragraph {
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
            case .audio(_, _, _, let audioURL, _, _): delegate?.didTapMedia(withURL: audioURL, in: self)   
            case .video(_, _, _, let videoURL, _): streamVideo(videoURL: videoURL)
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
