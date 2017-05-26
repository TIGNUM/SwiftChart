//
//  LibraryViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LibraryViewControllerDelegate: class {
    func didTapMedia(with mediaItem: LibraryMediaItem, from view: UIView, in viewController: UIViewController)
}

final class LibraryViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

    // MARK: - Init

    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        registerTableCell()
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
    }
}

// MARK: - Private

private extension LibraryViewController {

    func registerTableCell() {
        tableView.registerDequeueable(LatestPostCell.self)
        tableView.registerDequeueable(CategoryPostCell.self)
    }
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
    }
}

// MARK: - UITableViewDataSource

extension LibraryViewController: UITableViewDataSource {

    // table DataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.styleForSection(indexPath.item)
        tableView.rowHeight = UITableViewAutomaticDimension

        switch section {
        case .lastPost:
            let cell: LatestPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", sectionCount: viewModel.numberOfItemsInSection(in: indexPath.section), mediaItem: viewModel.item(at: indexPath))

            return cell
        case .category:
            let cell: CategoryPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", itemCount: viewModel.sectionCount, mediaItem: viewModel.item(at: indexPath))
            
            return cell
        }
    }
}
