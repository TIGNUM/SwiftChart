//
//  PrepareContentViewController.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit
import Anchorage

protocol PrepareContentViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareContentViewController)
    func didTapShare(in viewController: PrepareContentViewController)
    func didTapVideo(with videoURL: URL, from view: UIView, in viewController: PrepareContentViewController)
    func didTapSavePreparation(in viewController: PrepareContentViewController)
    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController)
}

final class PrepareContentViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let viewModel: PrepareContentViewModel
    fileprivate let disposeBag = DisposeBag()
    weak var delegate: PrepareContentViewControllerDelegate?
    
    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            estimatedRowHeight: 140,
            delegate: self,
            dataSource: self,
            dequeables:
            PrepareContentHeaderTableViewCell.self,
            PrepareContentFooterTableViewCell.self,
            PrepareContentMainHeaderTableViewCell.self
        )
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: PrepareContentViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - Private

private extension PrepareContentViewController {
    
    func updateTableView(with tableView: UITableView) {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.tableView.reloadData()
            case .update(_, _, let modifications):
                self.tableView.reloadRows(at: modifications, with: .none)
            }
            }.dispose(in: disposeBag)
    }
    
    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        updateTableView(with: tableView)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource, PrepareContentActionButtonsTableViewCellDelegate

extension PrepareContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentItem = viewModel.item(at: indexPath.row)
        
        switch contentItem {
        case .titleItem(let title, let subTitle, let contentText, let placeholderURL, let videoURL):
            let cell: PrepareContentMainHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            let isExpanded = viewModel.isCellExpanded(at: indexPath.row)

            cell.setCell(title: title, subTitle: subTitle, contentText: contentText, videoPlaceholder: placeholderURL, videoURL: videoURL, isExpanded: isExpanded)
            cell.delegate = self
            return cell
            
        case .item(let id, let title, let subTitle, let readMoreID):
            let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            let isExpanded = viewModel.isCellExpanded(at: indexPath.row)

            cell.delegate = self
            cell.setCell(title: title,
                         contentText: subTitle,
                         readMoreID: readMoreID,
                         position: indexPath.row,
                         isExpanded: isExpanded,
                         displayMode: viewModel.displayMode,
                         isChecked: viewModel.isChecked(id: id))
            return cell
            
        case .tableFooter(let preparationID):
            let cell: PrepareContentFooterTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            cell.preparationID = preparationID
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        viewModel.didTapHeader(index: indexPath.row)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
}

// MARK: - PrepareContentFooterTableViewCellDelegate

extension PrepareContentViewController: PrepareContentFooterTableViewCellDelegate {
    
    func didSavePreparation(preparationID: Int, cell: UITableViewCell) {
        delegate?.didTapSavePreparation(in: self)
    }
}

// MARK: - PrepareContentHeaderTableViewCellDelegate

extension PrepareContentViewController: PrepareContentHeaderTableViewCellDelegate {
    
    func didPressReadMore(readMoreID: Int?, cell: UITableViewCell) {
        if let readMoreID = readMoreID {
            delegate?.didTapReadMore(readMoreID: readMoreID, in: self)
        } else {
            log("didPressReadMore: readMoreID is nil")
        }
    }

    func didTapCheckbox(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let contentItem = viewModel.item(at: indexPath.row)

        switch contentItem {
        case .item(let id, _, _, _):
            viewModel.didTapCheckbox(id: id)
        default:
            break
        }
    }
}

// MARK: - PrepareContentMainHeaderTableViewCellDelegate

extension PrepareContentViewController: PrepareContentMainHeaderTableViewCellDelegate {
    
    func didTapVideo(videoURL: URL?, cell: UITableViewCell) {
        if let videoURL = videoURL {
            delegate?.didTapVideo(with: videoURL, from: cell, in: self)
        } else {
            log("didTapVideo: videoURL is nil")
        }
    }
}
