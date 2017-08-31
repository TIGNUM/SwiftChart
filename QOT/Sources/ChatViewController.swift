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
import QuartzCore

class ChatViewController<T: ChatChoice>: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let disposeBag = DisposeBag()
    private var isUpdating = false
    fileprivate var dontAnimateCellAtIndexPath: IndexPath?
    let viewModel: ChatViewModel<T>
    let pageName: PageName
    
    var didSelectChoice: ((T, ChatViewController) -> Void)?
    
    init(pageName: PageName, viewModel: ChatViewModel<T>, backgroundImage: UIImage? = nil) {
        self.pageName = pageName
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        setupView(withBackgroundImage: backgroundImage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: CGFloat(10.0),
            delegate: self,
            dataSource: self,
            dequeables:
                ChatTableViewCell.self,
                StatusTableViewCell.self,
                CollectionTableViewCell.self
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .willBegin:
                self.isUpdating = true
                self.tableView.isUserInteractionEnabled = false
            case .didFinish:
                self.isUpdating = false
                self.tableView.isUserInteractionEnabled = true
            case .reload:
                self.tableView.reloadData()
            case .update(let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions, with: .fade)
                self.tableView.insertRows(at: insertions, with: .fade)
                self.tableView.reloadRows(at: modifications, with: .fade)
                self.tableView.endUpdates()
                self.tableView.scrollToBottom(animated: true)
            }
        }.dispose(in: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stop()
    }
    
    private func setupView(withBackgroundImage backgroundImage: UIImage?) {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor + 22
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: 0.0, bottom: 86.0, right: 0.0)
        if let backgroundImage = backgroundImage {
            tableView.backgroundView = UIImageView(image: backgroundImage)
        }
        view.layoutIfNeeded()
        view.applyFade()
    }
    
    private func animateCellFromLeft(_ cell: UITableViewCell, completion: ((Bool) -> Void)?) {
        let toCenter = cell.contentView.center
        let fromCenter = CGPoint(x: toCenter.x - (cell.bounds.size.width * 0.5), y: toCenter.y)
        animateCell(cell, fromCenter: fromCenter, toCenter: toCenter, completion: completion)
    }
    
    private func animateCellFromRight(_ cell: UITableViewCell, completion: ((Bool) -> Void)?) {
        let toCenter = cell.contentView.center
        let fromCenter = CGPoint(x: toCenter.x + (cell.bounds.size.width * 0.5), y: toCenter.y)
        animateCell(cell, fromCenter: fromCenter, toCenter: toCenter, completion: completion)
    }
    
    private func animateCell(_ cell: UITableViewCell, fromCenter: CGPoint, toCenter: CGPoint, completion: ((Bool) -> Void)?) {
        cell.contentView.center = fromCenter
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseOut, animations: {
            cell.contentView.center = toCenter
        }, completion: completion)
    }

    // MARK: - UITableViewDataSource

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
            cell.isTyping = false
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
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isUpdating else {
            return
        }

        if dontAnimateCellAtIndexPath?.section == indexPath.section
        && dontAnimateCellAtIndexPath?.row == indexPath.row {
            dontAnimateCellAtIndexPath = nil
            return
        }
        
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .message:
            guard let cell = cell as? ChatTableViewCell else {
                return
            }
            if item.state == .typing {
                cell.isTyping = true
                animateCellFromLeft(cell, completion: nil)
            } else {
                cell.isTyping = false
            }
        case .header(_, let alignment), .footer(_, let alignment):
            switch alignment {
            case .left:
                animateCellFromLeft(cell, completion: nil)
            case .right:
                animateCellFromRight(cell, completion: nil)
            default:
                break
            }
        case .choiceList:
            animateCellFromRight(cell, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.item(at: indexPath.row)
        switch item.type {
        case .message:
            return UITableViewAutomaticDimension
        case .header, .footer:
            return UITableViewAutomaticDimension
        case .choiceList(let choices, let display):
            guard let cell = Bundle.main.loadNibNamed("CollectionTableViewCell", owner: self, options: [:])?.first as? CollectionTableViewCell else { return UITableViewAutomaticDimension
            }

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
        guard let cellIndex = tableView.indexPath(for: cell)?.row, viewModel.canSelectItem(index: cellIndex) == true else {
            return
        }
        
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

                guard let indexPath = tableView.indexPath(for: cell) else { return }
                dontAnimateCellAtIndexPath = indexPath
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}

// MARK: - ChatViewModelDelegate

extension ChatViewController: ChatViewModelDelegate {
    func canChatStart() -> Bool {
        return isViewLoaded
    }
}
