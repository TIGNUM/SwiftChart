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

class ChatViewController: UITableViewController, Dequeueable {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        //Dequeue TableCells
        tableView.registerDequeueable(ChatTableViewCell.self)
        tableView.registerDequeueable(StatusTableViewCell.self)
        tableView.registerDequeueable(AnswerCollectionTableViewCell.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTableView()
        updateTableView(with: tableView)
    }

    private func setupTableView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .black

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
        return self.viewModel.itemCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = viewModel.item(at: indexPath.row)
        
        switch chatMessage {
        case .instruction(let type, _):
            switch type {
            case .message(let message):
                let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.chatLabel?.text = message
                return cell

            case .typing:
                let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.chatLabel.text = "..."
                return cell
            }
        case .header(let title, _):
            let cell: StatusTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.statusLabel.text = title
            return cell

        case .navigation(let items):
            let collectionCell: AnswerCollectionTableViewCell = tableView.dequeueCell(for: indexPath)
            collectionCell.withDataModel(dataModel: items)
            return collectionCell

        case .input(let items):
            let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatMessage = viewModel.item(at: indexPath.row)
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
