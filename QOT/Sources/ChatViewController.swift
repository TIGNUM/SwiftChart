//
//  ChatViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Foundation
import ReactiveKit
import Bond
import Anchorage

class ChatViewController<T: ChatChoice>: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let disposeBag = DisposeBag()
    let viewModel: ChatViewModel<T>

    var didSelectChoice: ((T, ChatViewController) -> Void)?

    init(viewModel: ChatViewModel<T>) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: CGFloat(140.0),
            delegate: self,
            dataSource: self,
            dequeables:
                ChatTableViewCell.self,
                StatusTableViewCell.self,
                CollectionTableViewCell.self
        )
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.tableView.reloadData()
            case .update:
                // FIXME: Animate updates
                self.tableView.reloadData()
            }
            }.dispose(in: disposeBag)
    }

    private func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FIXME: Select correct item
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .choiceList(let choices, _):
            if let choice = choices.first {
                didSelectChoice?(choice, self)
            }
        default:
            break
        }

    }
}
