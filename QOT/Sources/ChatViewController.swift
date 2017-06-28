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

    // MARK: - Private methods

    private func heightOfFlowCollectionViewBasedOnNumberOfItems(items: [ChatChoice], tableView: UITableView) -> CGFloat {
        let screenSize: CGRect = tableView.bounds
        var total: CGFloat = 0.0
        for i: Int in stride(from: 1, to: items.count, by: 1) {
            total += items.item(at: i).title.width(withConstrainedHeight: 0, font: UIFont(name: "BentonSans", size: 16)!) + 40
        }
        total /= screenSize.width
        total *= 80
        return total > 100 ? total : 100
    }

    private func heightOfListCollectionViewBasedOnNumberOfItems(items: [ChatChoice], tableView: UITableView) -> CGFloat {
        var total: CGFloat = 0.0
        for i: Int in stride(from: 0, to: items.count, by: 1) {
            total += items.item(at: i).title.height(withConstrainedWidth: tableView.bounds.width, font: UIFont(name: "BentonSans", size: 16)!) + 40
        }

        return total > 100 ? total : 100
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .message(let message):
            let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.chatLabel.text = message
            cell.chatLabel.font = UIFont(name: "BentonSans-Book", size: 16)
            cell.chatLabel.textColor = .blackTwo
//            cell.iconImageView.image = UIImage(named: "####")
            return cell
        case .header(let text, let alignment):
            let cell: StatusTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.statusLabel.text = text
            cell.statusLabel.textAlignment = alignment
            return cell
        case .footer(let text, let alignment):
            let cell: StatusTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.statusLabel.text = text
            cell.statusLabel.textAlignment = alignment
            return cell
        case .choiceList(let choices, let display):
            let cell: CollectionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self

            let prepareChatObjects = choices.enumerated().map { (offset, choice) -> PrepareChatObject in
                let isSelected = viewModel.isSelected(itemIndex: indexPath.row, choiceIndex: offset)
                let style: PrepareCollectionViewCell.Style = isSelected ? .dashedSelected : .dashed

                return PrepareChatObject(title: choice.title, localID: "", selected: isSelected, style: style) //TODO: set localID
            }


            cell.inputWithDataModel(dataModel: prepareChatObjects, display: display)
            cell.collectionView.reloadData()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .message, .header, .footer:
            return UITableViewAutomaticDimension
        case .choiceList(let items, let display):
            switch display {
            case .flow:
                return heightOfFlowCollectionViewBasedOnNumberOfItems(items: items, tableView: tableView)
            case .list:
                return heightOfListCollectionViewBasedOnNumberOfItems(items: items, tableView: tableView)
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FIXME: Select correct item
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .choiceList(let choices, _):
            if let choice = choices.first, viewModel.canSelectItem(index: indexPath.row) == true {
                didSelectChoice?(choice, self)
            }
        default:
            break
        }

    }
}

// MARK: - CollectionViewCellDelegate

extension ChatViewController : CollectionViewCellDelegate {
    func didSelectItemAtIndex(_ index: Index, in cell: CollectionTableViewCell) {
        guard let cellIndex = tableView.indexPath(for: cell)?.row, viewModel.canSelectItem(index: cellIndex) == true else { return }
        let cellItem = viewModel.item(at: cellIndex)

        switch cellItem.type {
        case .choiceList(let items, let display):
            switch display {
            case .flow:
                fallthrough
            case .list:
                viewModel.select(itemIndex: cellIndex, choiceIndex: index)
                let item = items.item(at: index)
                didSelectChoice?(item, self)

            }
        default:
            break
        }
    }
}
