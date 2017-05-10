//
//  LearnContentItemBulletViewController.swift
//  QOT
//
//  Created by karmic on 09.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class LearnContentItemBulletViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: LearnContentItemViewModel
    fileprivate var tableView = UITableView()

    // MARK: Init

    init(viewModel: LearnContentItemViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // MARK: Private methods

    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        tableView.registerDequeueable(ContentItemTextTableViewCell.self)
        tableView.registerDequeueable(ImageSubtitleTableViewCell.self)
        view.addSubview(tableView)
    }
}
