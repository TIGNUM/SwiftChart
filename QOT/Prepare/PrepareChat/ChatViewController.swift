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

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Dequeueable, CollectionViewCellDelegate {
    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    fileprivate let viewModel: ChatViewModel
    weak var delegate: ChatViewDelegate?

    private let estimatedRowHeight: CGFloat = 140.0

    // MARK: - Life Cycle

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        tableView.estimatedRowHeight = estimatedRowHeight
    }

    private func updateTableView(with tableView: UITableView) {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.tableView.reloadData()
            case .update(_, _, _):
                // Please animate updates as needed
                self.tableView.reloadData()
            }
        }.dispose(in: disposeBag)
    }

    public func heightOfCollectionViewBasedOnNumberOfItems(items: ([String])) -> CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        var total: CGFloat = 0.0
        for i: Int  in stride(from: 1, to: items.count, by: 1) {
            total += items.item(at: i).width(withConstrainedHeight: 0, font: UIFont(name: "BentonSans", size: 16)!) + 70
        }
        total /= screenSize.width
        total *= 80
        return total > 100 ? total : 100
    }

    func didSelectItemAtIndex(_ index: Index, in cell: CollectionTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let chatMessage = viewModel.item(at: indexPath.row)
        switch chatMessage {
        case .instruction, .header:
            break
        case .navigation(let items):
            delegate?.didSelectChatNavigation(items.item(at: index), in: self)
        case .input(let items):
            delegate?.didSelectChatInput(items.item(at: index), in: self)
        }
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
        case .instruction(let type, let showIcon):
            switch type {
            case .message(let message):
                let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.chatLabel.text = message
                cell.setup(showIcon: showIcon)
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
            collectionCell.delegate = self
            var prepareChatObjects: [PrepareChatObject] = []
            for item in items {
                let obj = PrepareChatObject(title: item.title, localID: item.localID, selected: item.selected, style: .dashed)
                prepareChatObjects.append(obj)
            }
            collectionCell.inputWithDataModel(dataModel: prepareChatObjects)
            return collectionCell

        case .input(let items):
            let collectionCell: CollectionTableViewCell = tableView.dequeueCell(for: indexPath)
            collectionCell.cellTitleLabel.text = "Day Protocol".uppercased()
            collectionCell.delegate = self
            var prepareChatObjects: [PrepareChatObject] = []
            for item in items {
                let obj = PrepareChatObject(title: item.title, localID: item.localID, selected: item.selected, style: .plain)
                prepareChatObjects.append(obj)
            }
            collectionCell.inputWithDataModel(dataModel: prepareChatObjects)
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
            let titles = items.map {$0.title}
            return heightOfCollectionViewBasedOnNumberOfItems(items: titles)
        case .input(let items):
            let titles = items.map {$0.title}
            return heightOfCollectionViewBasedOnNumberOfItems(items: titles)
        }
    }
}
