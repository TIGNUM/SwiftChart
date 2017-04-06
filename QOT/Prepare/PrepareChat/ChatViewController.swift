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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dequeueable {
    
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
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
        self.tableView.registerDequeueable(ChatTableViewCell.self)
        self.tableView.registerDequeueable(StatusTableViewCell.self)
        self.tableView.registerDequeueable(CollectionTableViewCell.self)

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

    public func heightOfCollectionViewBasedOnNumberOfItems(items: ([Any])) -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        var totalWidth: CGFloat = 0.0

        if let obj = items as? [ChatMessageNavigation] {
            for i: Int  in stride(from: 1, to: items.count, by: 1) {
                totalWidth += obj.item(at: i).title.width(withConstrainedHeight: 0, font: UIFont(name: "BentonSans", size: 16)!) + 70
            }
        } else if let obj = items as? [ChatMessageInput] {
            for i: Int  in stride(from: 1, to: items.count, by: 1) {
                totalWidth += obj.item(at: i).title.width(withConstrainedHeight: 0, font: UIFont(name: "BentonSans", size: 16)!) + 70
            }
        }

        totalWidth /= screenSize.width
        return totalWidth * 70
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatViewController {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessage = viewModel.item(at: indexPath.row)
        
        switch chatMessage {
        case .instruction(let type, _):
            switch type {
            case .message(let message):
                let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.chatLabel.text = message 
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
            let collectionCell: CollectionTableViewCell = tableView.dequeueCell(for: indexPath)
            collectionCell.cellTitleLabel.text = "Preparations".uppercased()
            collectionCell.inputWithDataModel(dataModel: items as [Any])
            return collectionCell

        case .input(let items):
            let collectionCell: CollectionTableViewCell = tableView.dequeueCell(for: indexPath)
            collectionCell.cellTitleLabel.text = "Day Protocol".uppercased()
            collectionCell.inputWithDataModel(dataModel: items as [Any])
            return collectionCell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let chatMessage = viewModel.item(at: indexPath.row)
        switch chatMessage {
        case .instruction, .header:
            return UITableViewAutomaticDimension
        case .navigation(let items):
            return heightOfCollectionViewBasedOnNumberOfItems(items: items)
        case .input(let items):
            return heightOfCollectionViewBasedOnNumberOfItems(items: items)
        }
    }
}
