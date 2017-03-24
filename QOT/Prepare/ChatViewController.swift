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
    func didSelectChatSectionNavigate(with chatNavigation: ChatNavigation?, in viewController: ChatViewController)
    func didSelectChatSectionUpdate(with chatInput: ChatInput?, in viewController: ChatViewController)
}

class ChatViewController: UIViewController {
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    fileprivate let viewModel: ChatViewModel
    fileprivate let cellIdentifier = "Cell"
    weak var delegate: ChatViewDelegate?

    private lazy var tableView: UITableView = {
        let frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        self.view.backgroundColor = .black
        self.view.addSubview(tableView)

        return tableView
    }()

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

        updateTableView(with: tableView)
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

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatSectionDataCount(at: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let chatData = viewModel.chatSectionData(at: indexPath)
        
        switch chatData {
        case .chatMessages(let messages): chatCell.textLabel?.text = messages[indexPath.row].text
        case .chatNavigations(let navigations): chatCell.textLabel?.text = navigations[indexPath.row].title
        case .chatInputs(let inputs): chatCell.textLabel?.text = inputs[indexPath.row].title
        }

        return chatCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatSectiondata = viewModel.chatSectionData(at: indexPath)

        switch indexPath.section {
        case 1: delegate?.didSelectChatSectionNavigate(with: chatSectiondata.chatNavigation(at: indexPath.row), in: self)
        case 2: delegate?.didSelectChatSectionUpdate(with: chatSectiondata.chatInput(at: indexPath.row), in: self)
        default: return
        }
    }
}
