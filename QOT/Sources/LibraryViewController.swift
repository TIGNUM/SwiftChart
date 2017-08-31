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
    func didTapClose(in viewController: LibraryViewController)
}

final class LibraryViewController: UIViewController {

    fileprivate let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables: LibraryTableViewCell.self
        )
    }()

    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - private
    
    private func setupView() {
        view.addSubview(tableView)
        view.applyFade()
        
        view.backgroundColor = .clear
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.backgroundView = UIImageView(image: R.image.backgroundSidebar())
        tableView.contentInset = UIEdgeInsets(top: 33.0, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 316.0
        }
        return 313.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LibraryTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setUp(
            delegate: delegate,
            title: viewModel.titleForSection(indexPath.section),
            contentCollection: viewModel.contentCollection(at: indexPath),
            collectionViewCellType: (indexPath.section == 0) ? .latestPost : .category
        )
        return cell
    }
}
