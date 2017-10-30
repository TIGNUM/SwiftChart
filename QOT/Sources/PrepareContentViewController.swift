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

    func didTapSavePreparation(in viewController: PrepareContentViewController)

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController)
}

final class PrepareContentViewController: UIViewController {

    // MARK: - Properties

    let viewModel: PrepareContentViewModel
    fileprivate let disposeBag = DisposeBag()
    weak var delegate: PrepareContentViewControllerDelegate?
    let pageName: PageName
    
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

    fileprivate lazy var topBarView: PrepareContentTopTabBarView = {
        guard let view = Bundle.main.loadNibNamed("PrepareContentTopTabBarView", owner: self, options: [:])?[0] as? PrepareContentTopTabBarView else {
            preconditionFailure("Failed to PrepareContentTopTabBarView from xib")
        }
        view.setup(title: R.string.localized.topTabBarItemTitlePerparePreparation(),
                   leftButtonIcon: R.image.ic_minimize(),
                   rightButtonIcon: self.viewModel.displayMode == .normal ? R.image.ic_save_prep() : nil,
                   delegate: self)
        return view
    }()

    // MARK: - Life Cycle

    init(pageName: PageName, viewModel: PrepareContentViewModel) {
        self.pageName = pageName
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .default
    }

    func fixTableViewInsets() {
        let zContentInsets = UIEdgeInsets.zero
        tableView.contentInset = zContentInsets
        tableView.scrollIndicatorInsets = zContentInsets
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fixTableViewInsets()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Private

private extension PrepareContentViewController {

    func setupView() {
        view.backgroundColor = .white
        view.addSubview(topBarView)
        view.addSubview(tableView)
        topBarView.topAnchor == view.topAnchor
        topBarView.horizontalAnchors == view.horizontalAnchors
        topBarView.heightAnchor == Layout.TabBarView.height
        tableView.topAnchor == topBarView.bottomAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }

    @discardableResult func configure(cell: UITableViewCell, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let contentItem = viewModel.item(at: indexPath.row)

        switch contentItem {
        case .titleItem(let title, let subTitle, let contentText, let placeholderURL, let videoURL):
            guard let castedCell = cell as? PrepareContentMainHeaderTableViewCell else {
                return cell
            }

            let isExpanded = viewModel.isCellExpanded(at: indexPath.row)
            castedCell.delegate = self
            castedCell.setCell(title: title,
                               subTitle: subTitle,
                               contentText: contentText,
                               videoPlaceholder: placeholderURL,
                               videoURL: videoURL,
                               isExpanded: isExpanded)
            castedCell.contentView.layoutIfNeeded()

            return castedCell
        case .item(let id, let title, let subTitle, let readMoreID):
            guard let castedCell = cell as? PrepareContentHeaderTableViewCell else {
                return cell
            }

            let isExpanded = viewModel.isCellExpanded(at: indexPath.row)
            castedCell.delegate = self
            castedCell.setCell(title: title,
                               contentText: subTitle,
                               readMoreID: readMoreID,
                               position: indexPath.row,
                               isExpanded: isExpanded,
                               displayMode: viewModel.displayMode,
                               isChecked: viewModel.isChecked(id: id))
            castedCell.contentView.layoutIfNeeded()

            return castedCell
        case .tableFooter(let preparationID):
            guard let castedCell = cell as? PrepareContentFooterTableViewCell else {
                return cell
            }

            castedCell.delegate = self
            castedCell.preparationID = preparationID

            return castedCell
        }
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
        case .titleItem:
            let cell: PrepareContentMainHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        case .item:
            let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        case .tableFooter:
            let cell: PrepareContentFooterTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let contentItem = viewModel.item(at: indexPath.row)

        switch contentItem {
        case .titleItem:
            fallthrough
        case .item:
            viewModel.didTapHeader(index: indexPath.row)

            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            tableView.beginUpdates()
            configure(cell: cell, forIndexPath: indexPath)
            tableView.endUpdates()
        case .tableFooter:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let contentItem = viewModel.item(at: indexPath.row)

        // @note any magic numbers here represent bottom padding
        // we're setting the cell's frame size, then using autolayout to dynamically calculate top-bottom height
        switch contentItem {
        case .titleItem:
            guard let cell = Bundle.main.loadNibNamed("\(PrepareContentMainHeaderTableViewCell.self)", owner: self, options: [:])?.first as? PrepareContentMainHeaderTableViewCell else {
                return UITableViewAutomaticDimension
            }
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)
            configure(cell: cell, forIndexPath: indexPath)
            cell.layoutIfNeeded()
            
            if viewModel.isCellExpanded(at: indexPath.row) {
                // return content label y position + height + bottom padding
                return cell.contentLabel.frame.origin.y + cell.contentLabel.frame.height + 20.0
            }
            // return header label y position + height + bottom padding
            return cell.headerLabel.frame.origin.y + cell.headerLabel.frame.height + 8.0
        case .item(_, _, _, let readMoreID):
            guard let cell = Bundle.main.loadNibNamed("\(PrepareContentHeaderTableViewCell.self)", owner: self, options: [:])?.first as? PrepareContentHeaderTableViewCell else {
                return UITableViewAutomaticDimension
            }
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)
            configure(cell: cell, forIndexPath: indexPath)
            cell.layoutIfNeeded()
            
            if viewModel.isCellExpanded(at: indexPath.row) {
                if readMoreID == nil {
                    // return content label y position + height + bottom padding
                    return cell.contentLabel.frame.origin.y + cell.contentLabel.frame.height + 20.0
                }
                // return read more button y position + height + bottom padding
                return cell.readMoreButton.frame.origin.y + cell.readMoreButton.bounds.height + 20.0
            }
            // return header label y position + height + bottom padding
            return cell.headerLabel.frame.origin.y + cell.headerLabel.frame.height + 20.0
        default:
            return UITableViewAutomaticDimension
        }
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
            tableView.beginUpdates()
            let headerIndexPath = IndexPath(row: 0, section: 0)
            if let headerCell = tableView.cellForRow(at: headerIndexPath) {
                configure(cell: headerCell, forIndexPath: headerIndexPath)

            }
            configure(cell: cell, forIndexPath: indexPath)
            tableView.endUpdates()
        default:
            break
        }
    }
}

// MARK: - PrepareContentMainHeaderTableViewCellDelegate

extension PrepareContentViewController: PrepareContentMainHeaderTableViewCellDelegate {

    func didTapVideo(videoURL: URL?, cell: UITableViewCell) {
        if let videoURL = videoURL {
            streamVideo(videoURL: videoURL)
        } else {
            log("didTapVideo: videoURL is nil")
        }
    }
}

// MARK: - PrepareContentTopTabBarViewDelegate

extension PrepareContentViewController: PrepareContentTopTabBarViewDelegate {
    
    func didTapLeftButton() {
        delegate?.didTapClose(in: self)
    }
    
    func didTapRightButton() {
        delegate?.didTapSavePreparation(in: self)
    }
}
