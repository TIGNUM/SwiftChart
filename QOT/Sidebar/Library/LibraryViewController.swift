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
        view.backgroundColor = .black
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
        let style = viewModel.styleForSection(indexPath.item)
        switch style {
        case .lastPost: return 200
        case .category: return 300
        }
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
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", sectionCount: viewModel.numberOfItemsInSection(in: indexPath.section))

            return cell
        case .category:
            let cell: CategoryPostCell = tableView.dequeueCell(for: indexPath)
            cell.setUp(title: "\(viewModel.titleForSection(indexPath.item))", itemCount: viewModel.sectionCount)
            
            return cell
        }
    }
}
