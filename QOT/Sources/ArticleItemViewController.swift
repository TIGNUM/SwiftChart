//
//  ArticleItemViewController.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ArticleItemViewControllerDelegate: class {

    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: ArticleItemViewController)
}

final class ArticleItemViewController: UIViewController {

    // MARK: - Properties

    fileprivate var viewModel: ArticleItemViewModel
    weak var delegate: ArticleItemViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables:
                ContentItemTextTableViewCell.self,
                ImageSubtitleTableViewCell.self,
                ArticleRelatedCell.self,
                ErrorCell.self
            )
    }()

    // MARK: - Init

    init(viewModel: ArticleItemViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
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

        resizeHeaderView()
    }

    func reloadArticles(viewModel: ArticleItemViewModel) {
        self.viewModel = viewModel
        tableView.tableHeaderView = nil
        setTableViewHeader()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - Private

private extension ArticleItemViewController {

    func resizeHeaderView() {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame                
                tableView.tableHeaderView = headerView
            }
        }
    }

    func setupView() {
        setTableViewHeader()
        view.addSubview(tableView)
        view.backgroundColor = .clear
        tableView.topAnchor == view.topAnchor + 64
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.layoutIfNeeded()
        view.layoutIfNeeded()
    }

    func setTableViewHeader() {
        let nib = R.nib.articleItemHeaderView()
        guard let headerView = (nib.instantiate(withOwner: self, options: nil).first as? ArticleItemHeaderView) else {
            return
        }

        headerView.setupView(header: viewModel.articleHeader)
        headerView.backgroundColor = .clear
        tableView.tableHeaderView = headerView
    }

    func contentItemTextTableViewCell(
        tableView: UITableView,
        indexPath: IndexPath,
        topText: NSAttributedString,
        bottomText: NSAttributedString?) -> ContentItemTextTableViewCell {
            let itemTextCell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
            itemTextCell.setup(topText: topText, bottomText: bottomText)
            itemTextCell.backgroundColor = .clear
            itemTextCell.contentView.backgroundColor = .clear

            return itemTextCell
    }

    func mediaStreamCell(
        tableView: UITableView,
        indexPath: IndexPath,
        title: String,
        placeholderURL: URL,
        attributedString: NSAttributedString) -> ImageSubtitleTableViewCell {
            let imageCell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            imageCell.setupData(placeHolder: placeholderURL, description: attributedString)
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
            imageCell.setupData(placeHolder: url, description: attributeString)
            imageCell.setInsets(insets: UIEdgeInsets(top: 14, left: 28, bottom: 14, right: 28))
            imageCell.backgroundColor = .clear
            imageCell.contentView.backgroundColor = .clear

            return imageCell
    }

    func invalidContentCell(tableView: UITableView, indexPath: IndexPath) -> ErrorCell {
        let cell: ErrorCell = tableView.dequeueCell(for: indexPath)
        cell.configure(text: R.string.localized.commonInvalidContent())
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear

        return cell
    }

    func relatedArticleCell(tableView: UITableView, indexPath: IndexPath) -> ArticleRelatedCell {
        let relatedArticleCell: ArticleRelatedCell = tableView.dequeueCell(for: indexPath)
        let relatedArticle = viewModel.relatedArticle(at: indexPath)
        relatedArticleCell.setupView(title: relatedArticle.title, subTitle: "TODO MIN TO CONSUME", previewImageURL: relatedArticle.thumbnailURL)
        
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
        let item = viewModel.articleItem(at: indexPath)

        switch indexPath.section {
        case 0:
            switch item.contentItemValue {
            case .audio(let title, _, let placeholderURL, _, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    placeholderURL: placeholderURL,
                    attributedString: item.contentItemValue.style(textStyle: .paragraph, text: title, textColor: .white).attributedString()
                )
            case .image(let title, _, let url):
                return imageTableViweCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    attributeString: item.contentItemValue.style(textStyle: .paragraph, text: title, textColor: .white).attributedString(),
                    url: url
                )
            case .invalid:
                return invalidContentCell(tableView: tableView, indexPath: indexPath)
            case .listItem(let text):
                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: item.contentItemValue.style(textStyle: .paragraph, text: text, textColor: .white),
                    bottomText: nil
                )
            case .text(let text, let style):
                return contentItemTextTableViewCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    topText: item.contentItemValue.style(textStyle: style, text: text, textColor: .white),
                    bottomText: nil
                )
            case .video(let title, _, let placeholderURL, _, _):
                return mediaStreamCell(
                    tableView: tableView,
                    indexPath: indexPath,
                    title: title,
                    placeholderURL: placeholderURL,
                    attributedString: item.contentItemValue.style(textStyle: .paragraph, text: title, textColor: .white).attributedString()
                )
            }
        case 1:
            return relatedArticleCell(tableView: tableView, indexPath: indexPath)
        default: fatalError("Wrong Section!")
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard indexPath.section == 1 else {
            return
        }

        delegate?.didSelectRelatedArticle(selectedArticle: viewModel.relatedArticle(at: indexPath), form: self)
    }
}
