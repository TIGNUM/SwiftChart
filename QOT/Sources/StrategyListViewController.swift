//
//  StrategyListViewController.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class StrategyListViewController: AbstractLevelTwoViewController {

    // MARK: - Properties

    var interactor: StrategyListInteractorInterface?
    private lazy var tableView: UITableView = {
        return UITableView(backgroundColor: .clear,
                           estimatedRowHeight: 100,
                           seperatorStyle: .singleLine,
                           delegate: self,
                           dataSource: self,
                           dequeables: StrategyTableViewCell.self)
    }()

    // MARK: - Init

    init(configure: Configurator<StrategyListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension StrategyListViewController {
}

// MARK: - Actions

private extension StrategyListViewController {

}

// MARK: - StrategyListViewControllerInterface

extension StrategyListViewController: StrategyListViewControllerInterface {
    func setupView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.edgeAnchors == view.edgeAnchors
        setupNavigationButtons()
    }
}

extension StrategyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.contentList().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = interactor?.contentList()[indexPath.row]
        let cell: StrategyTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: content?.title ?? "",
                       remoteID: content?.remoteID.value ?? 0,
                       percentageLearned: 0,
                       viewedCount: 0,
                       itemCount: 0)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let content = interactor?.contentList()[indexPath.row] else { return }
        interactor?.presentArticle(for: content)
    }
}
