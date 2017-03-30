//
//  WhatsHotNewTemplateViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WhatsHotNewTemplateViewControllerDelegate: class {
    func didTapClose(in viewController: WhatsHotNewTemplateViewController)
    func didTapBookmark(with item: WhatsHotNewTemplateItem,in viewController: WhatsHotNewTemplateViewController)
    func didTapMedia(with mediaItem: WhatsHotNewTemplateItem,from view: UIView, in viewController: WhatsHotNewTemplateViewController)
    func didTapArticle(with articleItem: WhatsHotNewTemplateItem, from view: UIView, in viewController: WhatsHotNewTemplateViewController)
    func didTapLoadMore(from view: UIView, in viewController: WhatsHotNewTemplateViewController)
    func didTapLoadMoreItem(with loadMoreItem: WhatsHotNewTemplateItem, from view: UIView, in viewController: WhatsHotNewTemplateViewController)
}

class WhatsHotNewTemplateViewController: UITableViewController {

    // MARK: - Properties

    let viewModel: WhatsHotNewTemplateViewModel
    weak var delegate: WhatsHotNewTemplateViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: WhatsHotNewTemplateViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WhatsHotNewTemplateViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        let item = viewModel.item(at: indexPath)

        switch item {
        case .header(_, let title, let subtitle, let duration):
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = subtitle

        case .title(_, let text):
            cell.textLabel?.attributedText = text

        case .subtitle(_, let text):
            cell.textLabel?.attributedText = text

        case .text(_, let text):
            cell.textLabel?.attributedText = text

        case .media(_, _, let description):
            cell.textLabel?.attributedText = description

        case .article(_, let placeholderURL, let title, let subtitle):
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = subtitle

        case .loadMore(_, _, _, let title, let subtitle):
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = subtitle
        }
        
        return cell
    }
}

