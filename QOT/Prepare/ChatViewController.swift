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
    fileprivate let cellIdentifier = Identifier.chatTableViewCell.rawValue
    weak var delegate: ChatViewDelegate?

    // MARK: - Life Cycle

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
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
        let chatCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let chatMessage = viewModel.chatMessage(at: indexPath.row)

        let text: String
        switch chatMessage {
        case .instruction(let type, _):
            switch type {
            case .message(let message): text = message
            case .typing: text = "..."
            }
        case .header(let title, _): text = title
        case .navigation(let items): text = "\(items.count) Navigation Items"
        case .input(let items): text = "\(items.count) Input Items"
        }

        chatCell.textLabel?.text = text

        return chatCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // This is temporary implementation based just allowing us to hook up the delegate. How you call the delegate
        // methods may be completly different.
        let chatMessage = viewModel.chatMessage(at: indexPath.row)

        switch chatMessage {
        case .navigation(let items):
            let item = items.first!
            delegate?.didSelectChatNavigation(item, in: self)
        case .input(let items):
            let item = items.first!
            delegate?.didSelectChatInput(item, in: self)
        case .header, .instruction: return
        }
    }
}
