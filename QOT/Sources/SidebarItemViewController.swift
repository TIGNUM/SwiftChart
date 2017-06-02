//
//  SidebarItemViewController.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol SidebarItemViewControllerDelegate: class {
    func didTapVideo(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapAudio(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapImage(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapShare(from view: UIView, in viewController: SidebarItemViewController)
}

final class SidebarItemViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: SidebarItemViewModel
    weak var delegate: SidebarItemViewControllerDelegate?
    
    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: 10,
            delegate: self,
            dataSource: self,
            dequeables:
            ContentItemTextTableViewCell.self,
            SideBarShareAction.self,
            ImageSubtitleTableViewCell.self
        )
    }()

    // MARK: - Init

    init(viewModel: SidebarItemViewModel) {
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
}

// MARK: - Private

private extension SidebarItemViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }

    func attributedString(description: String?) -> NSAttributedString? {
        guard let description = description else {
            return nil
        }

        return AttributedString.Sidebar.Benefits.headerText(string: description)
    }
}

// MARK: - UITableViewDelegate

extension SidebarItemViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
}

// MARK: - UITableViewDataSource

extension SidebarItemViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sidebarItem = viewModel.sidebarContentItems(at: indexPath)

        switch sidebarItem.sidebarContentItemValue {
        case .audio(_, let description, let placeholderURL, _, _, _):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupData(placeHolder: placeholderURL, description: attributedString(description: description))
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 40))
            return cell
        case .image(_, let description, let url):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupData(placeHolder: url, description: attributedString(description: description))
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 40))
            return cell
        case .text(let text, _):
            let cell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)
            let attributedText = AttributedString.Sidebar.Benefits.text(string: text)
            cell.setup(topText: attributedText, bottomText: nil, backgroundColor: .clear)
            return cell
        case .video(_, let description, let placeholderURL, _, _):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupData(placeHolder: placeholderURL, description: attributedString(description: description))
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 40))
            return cell
        }
    }
}
