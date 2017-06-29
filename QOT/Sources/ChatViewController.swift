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

    // MARK: - UITableViewDelegate, UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)

        switch item.type {
        case .message(let message):
            let cell: ChatTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.chatLabel.prepareAndSetTextAttributes(text: message, font: UIFont(name: "BentonSans-Book", size: 16)!, lineSpacing: 7)
            cell.chatLabel.textColor = .blackTwo
            cell.iconImageView.image = UIImage(named: "Q-Black")
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
            cell.collectionView.collectionViewLayout.invalidateLayout()
            cell.collectionView.reloadData()

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .message, .header, .footer:
            return UITableViewAutomaticDimension
        case .choiceList(let choices, let display):
            guard let cell = Bundle.main.loadNibNamed("CollectionTableViewCell", owner: self, options: [:])?[0] as? CollectionTableViewCell else { return UITableViewAutomaticDimension }

            let prepareChatObjects = choices.enumerated().map { (_, choice) -> PrepareChatObject in
                return PrepareChatObject(title: choice.title, localID: "", selected: false, style: .dashed)
            }

            cell.setup()
            cell.inputWithDataModel(dataModel: prepareChatObjects, display: display)
            cell.collectionView.reloadData()
            cell.layoutIfNeeded()

            let topPadding: CGFloat = 17

            let cellHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + topPadding

            return cellHeight
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
