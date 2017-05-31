//
//  LibraryViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol LibraryViewControllerDelegate: class {
    func didTapMedia(with mediaItem: LibraryMediaItem, from view: UIView, in viewController: UIViewController)
}

final class LibraryViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView.setup(
            delegate: self,
            dataSource: self,
            dequeables:
            LatestPostCell.self,
            CategoryPostCell.self
        )
    }()

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

        setupView()
    }
}

// MARK: - Private

private extension LibraryViewController {

    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
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
