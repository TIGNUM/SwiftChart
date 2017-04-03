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

protocol ChatViewDelegate: class {
    func didSelectChatNavigation(_ navigation: ChatMessageNavigation, in viewController: ChatViewController)
    func didSelectChatInput(_ input: ChatMessageInput, in viewController: ChatViewController)
}

class ChatViewController: UITableViewController {
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    fileprivate let viewModel: ChatViewModel
    weak var delegate: ChatViewDelegate?

    private let estimatedRowHeight = 140

    // MARK: - Life Cycle

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing:ChatViewController.self), bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTableView()
        updateTableView(with: tableView)
    }

    private func setupTableView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        tableView.register(UINib(nibName: String(describing:ChatTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:ChatTableViewCell.self))
        tableView.register(UINib(nibName: String(describing:StatusTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:StatusTableViewCell.self))

        tableView.register(UINib(nibName: String(describing:AnswerCollectionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing:AnswerCollectionTableViewCell.self))

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = CGFloat(estimatedRowHeight)
    }

    private func updateTableView(with tableView: UITableView) {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.tableView.reloadData()
            case .update(let deletions, let insertions, let modifications):
                // Please animate updates as needed
                self.tableView.reloadData()
            }
        }.dispose(in: disposeBag)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatMessageCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = viewModel.chatMessage(at: indexPath.row)

        switch chatMessage {
        case .instruction(let type, _):
            switch type {
            case .message(let message):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatTableViewCell.self), for: indexPath) as! ChatTableViewCell
                cell.chatLabel?.text = message
                return cell

            case .typing:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatTableViewCell.self), for: indexPath) as! ChatTableViewCell
                cell.chatLabel?.text = "..."
                return cell
            }
        case .header(let title, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatusTableViewCell.self), for: indexPath) as! StatusTableViewCell
            cell.statusLabel?.text = title
            return cell

        case .navigation(let items):
            let collectionCell = tableView.dequeueReusableCell(withIdentifier: String(describing:AnswerCollectionTableViewCell.self), for: indexPath) as! AnswerCollectionTableViewCell
            collectionCell.withDataModel(dataModel: items)
            return collectionCell

        case .input(let items):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatTableViewCell.self), for: indexPath) as! ChatTableViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatMessage = viewModel.chatMessage(at: indexPath.row)
        switch chatMessage {
        case .instruction(let type, _):
            switch type {
            case .message:
                return 100
            case .typing:
                return 30
            }
        case .header:
            return 30
        case .navigation:
            return 190
        case .input:
            return 100
        }
    }
}
