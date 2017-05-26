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
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

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

        setupTableView()
    }

    private func setupTableView() {
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(SideBarShareAction.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        tableView.delegate = self
    }
}

// MARK: - UITableViewDelegate

extension SidebarItemViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
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

    private func attributedString(description: String?) -> NSAttributedString? {
        guard let description = description else {
            return nil
        }

        return AttributedString.Sidebar.Benefits.headerText(string: description)
    }
}
