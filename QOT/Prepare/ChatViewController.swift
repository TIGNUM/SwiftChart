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

class ChatViewController: UIViewController {
    
    // MARK: - Properties

    private let disposeBag = DisposeBag()
    fileprivate let viewModel: ChatViewModel
    fileprivate let cellIdentifier = Identifier.chatTableViewCell.rawValue
    weak var delegate: ChatViewDelegate?

    private lazy var tableView: UITableView = {
        let chatCellNib = UINib(nibName: R.nib.chatTableViewCell.name, bundle: nil)
        let frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height)
        let tableView = UITableView(frame: frame, style: .plain)
        tableView.register(chatCellNib, forCellReuseIdentifier: self.cellIdentifier)
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
        guard let chatCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }

        let chatData = viewModel.chatSectionData(at: indexPath)
        switch chatData {
        case .messages(let messages): chatCell.setup(title: messages[indexPath.row].text)
        case .navigations(let navigations): chatCell.setup(title: navigations[indexPath.row].title)
        case .inputs(let inputs): chatCell.setup(title: inputs[indexPath.row].title)
        }

        return chatCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case 1: delegate?.didSelectChatSectionNavigate(in: self, chatSectionData: viewModel.chatSection(at: indexPath.section).data)
        case 2: delegate?.didSelectChatSectionUpdate(in: self, chatSectionData: viewModel.chatSection(at: indexPath.section).data)
        default: return
        }
    }
}
