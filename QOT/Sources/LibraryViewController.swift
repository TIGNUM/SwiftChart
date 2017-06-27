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

    func didTapLibraryItem(item: ContentCollection)
}

final class LibraryViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
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
        return viewModel.sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 317
    }
}

// MARK: - UITableViewDataSource

extension LibraryViewController: UITableViewDataSource {

    // table DataSource

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionStyle = viewModel.styleForSection(indexPath.item)
        let contentCollection = viewModel.contentCollection(at: indexPath)
        tableView.rowHeight = UITableViewAutomaticDimension

        switch sectionStyle {
        case .lastPost:
            let cell: LatestPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: viewModel.titleForSection(indexPath.section), contentCollection: contentCollection)
            cell.delegate = delegate

            return cell
        case .category:
            let cell: CategoryPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: viewModel.titleForSection(indexPath.section), contentCollection: contentCollection)
            cell.delegate = delegate
            
            return cell
        }
    }
}
