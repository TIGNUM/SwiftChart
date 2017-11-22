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

final class LibraryViewController: UIViewController, PageViewControllerNotSwipeable {

    private let paddingTop: CGFloat = 24.0
    private let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?

    private lazy var tableView: UITableView = {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = R.string.localized.sidebarTitleLibrary().uppercased()
    }
    
    // MARK: - private
    
    private func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.edgeAnchors == view.edgeAnchors
        tableView.contentInset.top = view.safeMargins.top + paddingTop
        tableView.contentInset.bottom = view.safeMargins.bottom
        tableView.backgroundView = viewModel.tableViewBackground
        
        view.addFade(at: .zero, direction: .down)
        view.setFadeMask(at: .bottom)
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        tableView.contentInset.top = view.safeMargins.top + paddingTop
        tableView.contentInset.bottom = view.safeMargins.bottom
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
        return viewModel.tools == true ? 313 : indexPath.section == 0 ? 316 : 313
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LibraryTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setUp(
            delegate: delegate,
            title: viewModel.titleForSection(indexPath.section),
            contentCollection: viewModel.contentCollection(at: indexPath),
            collectionViewCellType: viewModel.tools == true ? .category : ((indexPath.section == 0) ? .latestPost : .category)
        )
        
        return cell
    }
}
