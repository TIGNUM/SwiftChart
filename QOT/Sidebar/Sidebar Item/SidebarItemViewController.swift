//
//  SidebarItemViewController.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol SidebarItemViewControllerDelegate: class {
    func didTapVideo(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapAudio(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapImage(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapShare(from view: UIView, in viewController: SidebarItemViewController)
}

final class SidebarItemViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    let viewModel: SidebarItemViewModel
    weak var delegate: SidebarItemViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: SidebarItemViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }

    private func registerCells() {

        tableView.registerDequeueable(SideBarTextCell.self)
        tableView.registerDequeueable(SideBarShareAction.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)

        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
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

        let item = viewModel.item(at: indexPath)

        switch item {
        case .video(_, let placeholderURL, let description):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setUpData(placeHolder: placeholderURL, description: description)
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 40))
            return cell
        case .audio(_, let placeholderURL, let description):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setUpData(placeHolder: placeholderURL, description: description)
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 32, right: 40))
            return cell
        case .image(_, let placeholderURL, let description):
            let cell: ImageSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setUpData(placeHolder: placeholderURL, description: description)
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 46, right: 40))
            return cell
        case .text(_, let title, let text):
            let cell: SideBarTextCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: title, text: text)
            cell.setInsets(insets: UIEdgeInsets(top: 0, left: 32, bottom: 40, right: 40))
            return cell
        case .shareAction(let title):
            let cell: SideBarShareAction = tableView.dequeueCell(for: indexPath)
            cell.setUp(text: title)
            return cell
        }
    }
}
