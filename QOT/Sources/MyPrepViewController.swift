//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Bond
import ReactiveKit

protocol MyPrepViewControllerDelegate: class {
    func didTapMyPrepItem(with myPrepItem: MyPrepViewModel.Item, viewController: MyPrepViewController)
}

final class MyPrepViewController: UIViewController {

    // MARK: - Properties

    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables: MyPrepTableViewCell.self
        )
    }()

    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: MyPrepViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.updates.observeNext { [unowned self] _ in
            self.tableView.reloadData()
        }.dispose(in: disposeBag)
    }
}

// MARK: - Private

private extension MyPrepViewController {

    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        let count: String = String(format: "%02d/%02d", item.finishedPreparationCount, item.totalPreparationCount)
        let footer = ""
        cell.setup(with: item.header, text: item.text, footer: footer, count: count)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        delegate?.didTapMyPrepItem(with: item, viewController: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
}
