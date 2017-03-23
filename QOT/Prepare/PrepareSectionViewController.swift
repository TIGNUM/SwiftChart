//
//  PrepareSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Foundation

class PrepareSectionViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: ChatMessageViewModel
    fileprivate let cellIdentifier = Identifier.chatTableViewCell.rawValue
    fileprivate var tableView: UITableView?
    weak var delegate: PrepareChatBotDelegate?
    
    // MARK: - Life Cycle

    init(viewModel: ChatMessageViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        view.backgroundColor = .green
    }
}

extension PrepareSectionViewController {

    fileprivate func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView?.register(ChatTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareSectionViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }

        let chatMessage = viewModel.chatMessage(at: indexPath.row)

        switch chatMessage.type {
        case .instructionTyping: chatCell.setup(message: "...", delivered: Date())
        case .instruction(let message, let delivered): chatCell.setup(message: message, delivered: delivered)
        case .options(let title, let option): chatCell.setup(title: title, option: option)
        }

        return chatCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
