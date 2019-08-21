//
//  PrepareContentViewController.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import SVProgressHUD

protocol PrepareContentViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareContentViewController)
    func didTapSavePreparation(in viewController: PrepareContentViewController)
    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController)
    func saveNotes(notes: String, preparationID: String)
    func didTapAddRemove(headerID: Int)
}

final class PrepareContentViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    var viewModel: PrepareContentViewModel
    private var avPlayerObserver: AVPlayerObserver?
    private var sectionHeaderView: PrepareSectionHeaderView?
    private weak var chatDecisionManager: PrepareChatDecisionManager?
    weak var delegate: PrepareContentViewControllerDelegate?
    static var pageName: PageName = .prepareCheckList
    private lazy var tableView: UITableView = {
        return UITableView(estimatedRowHeight: 140,
                           delegate: self,
                           dataSource: self,
                           dequeables:
            PrepareContentHeaderTableViewCell.self,
            PrepareContentMainHeaderTableViewCell.self,
            PrepareContentSubHeaderTableViewCell.self)
    }()

    private lazy var topBarView: PrepareContentTopTabBarView = {
        guard let view = Bundle.main.loadNibNamed("PrepareContentTopTabBarView",
                                                  owner: self,
                                                  options: [:])?[0] as? PrepareContentTopTabBarView else {
            preconditionFailure("Failed to PrepareContentTopTabBarView from xib")
        }
        view.setup(title: self.title ?? R.string.localized.topTabBarItemTitlePerparePreparation(),
                   leftButtonIcon: R.image.ic_close(),
                   rightButtonIcon: nil/*self.viewModel.displayMode == .normal ? R.image.ic_save_prep() : nil*/,
                   delegate: self)
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Date().isNight ? .lightContent : .default
    }

    // MARK: - Life Cycle

    init(viewModel: PrepareContentViewModel,
         chatDecisionManager: PrepareChatDecisionManager? = nil) {
        self.viewModel = viewModel
        self.chatDecisionManager = chatDecisionManager
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
        SVProgressHUD.dismiss()
        tableView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fixTableViewInsets()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.updatePreparation()
        chatDecisionManager?.preparationSaved()
    }

    func fixTableViewInsets() {
        let zContentInsets = UIEdgeInsets.zero
        tableView.contentInset = zContentInsets
        tableView.scrollIndicatorInsets = zContentInsets
    }

    func updateViewModel(viewModel: PrepareContentViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

    @objc func didTapSavePreparation() {
        viewModel.updatePreparation()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension PrepareContentViewController {

    func setupView() {
        view.backgroundColor = .nightModeBackground
        if PrepareContentViewController.pageName == .prepareContent {
            view.addSubview(topBarView)
            view.addSubview(tableView)
            topBarView.topAnchor == view.topAnchor + UIApplication.shared.statusBarFrame.height
            topBarView.horizontalAnchors == view.horizontalAnchors
            topBarView.heightAnchor == Layout.TabBarView.height
            tableView.topAnchor == topBarView.bottomAnchor
            tableView.bottomAnchor == view.safeBottomAnchor - Layout.padding_24
            tableView.horizontalAnchors == view.horizontalAnchors
        } else if PrepareContentViewController.pageName == .prepareCheckList {
            view.addSubview(tableView)
			if #available(iOS 11.0, *) {
				tableView.topAnchor == view.safeTopAnchor + Layout.padding_16
				tableView.bottomAnchor == view.safeBottomAnchor - Layout.padding_24
				tableView.horizontalAnchors == view.horizontalAnchors
			} else {
				tableView.topAnchor == view.topAnchor + Layout.statusBarHeight
				tableView.bottomAnchor == view.bottomAnchor - Layout.padding_24
				tableView.leftAnchor == view.leftAnchor
				tableView.rightAnchor == view.rightAnchor
			}
        }
    }

    @discardableResult func configure(cell: UITableViewCell, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        guard let contentItem = viewModel.item(at: indexPath) else { return UITableViewCell() }
        switch contentItem {
        case .titleItem(let title, let subTitle, let contentText, let placeholderURL, let videoURL):
            guard let castedCell = cell as? PrepareContentMainHeaderTableViewCell else { return cell }
            let isExpanded = viewModel.isCellExpanded(at: indexPath)
            castedCell.delegate = self
            castedCell.setCell(title: title,
                               subTitle: subTitle,
                               contentText: contentText,
                               videoPlaceholder: placeholderURL,
                               videoURL: videoURL,
                               isExpanded: isExpanded,
                               displayMode: PrepareContentViewController.pageName == .prepareCheckList ? .checkbox : .normal)
            castedCell.contentView.layoutIfNeeded()
            castedCell.iconImageView.isHidden = (viewModel.preparationType == .prepContentProblem) && (indexPath.row == 0)
            return castedCell
        case .checkItemsHeader(let title):
            guard let subHeaderCell = cell as? PrepareContentSubHeaderTableViewCell else { return cell }
            subHeaderCell.configure(title: title)
            return subHeaderCell
        case .item(let id, let title, let subTitle, let readMoreID):
            guard let castedCell = cell as? PrepareContentHeaderTableViewCell else { return cell }
            let isExpanded = viewModel.isCellExpanded(at: indexPath)
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
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource, PrepareContentActionButtonsTableViewCellDelegate

extension PrepareContentViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentItem = viewModel.item(at: indexPath) else { return UITableViewCell() }
        switch contentItem {
        case .titleItem:
            let cell: PrepareContentMainHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        case .checkItemsHeader:
            let cell: PrepareContentSubHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        case .item:
            let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let contentItem = viewModel.item(at: indexPath) else { return }
        switch contentItem {
        case .titleItem, .item:
            viewModel.didTapHeader(indexPath: indexPath)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            tableView.beginUpdates()
            configure(cell: cell, forIndexPath: indexPath)
            tableView.endUpdates()
        case .checkItemsHeader: delegate?.didTapAddRemove(headerID: viewModel.headerID)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         guard let contentItem = viewModel.item(at: indexPath) else { return 0 }

        // @note any magic numbers here represent bottom padding
        // we're setting the cell's frame size, then using autolayout to dynamically calculate top-bottom height
        switch contentItem {
        case .titleItem:
            guard let cell = Bundle.main.loadNibNamed("\(PrepareContentMainHeaderTableViewCell.self)", owner: self)?.first as? PrepareContentMainHeaderTableViewCell else {
                return UITableViewAutomaticDimension
            }
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)
            configure(cell: cell, forIndexPath: indexPath)
            cell.layoutIfNeeded()

            if viewModel.isCellExpanded(at: indexPath) {
                return cell.contentLabel.frame.origin.y + cell.contentLabel.frame.height + Layout.padding_20
            }
            return cell.previewImageButton.frame.origin.y - Layout.padding_10
        case .checkItemsHeader: return UITableViewAutomaticDimension
        case .item(_, _, _, let readMoreID):
            guard let cell = Bundle.main.loadNibNamed("\(PrepareContentHeaderTableViewCell.self)", owner: self)?.first as? PrepareContentHeaderTableViewCell else {
                return UITableViewAutomaticDimension
            }
            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)
            configure(cell: cell, forIndexPath: indexPath)
            cell.layoutIfNeeded()

            if viewModel.isCellExpanded(at: indexPath) {
                if readMoreID == nil {
                    return cell.contentLabel.frame.origin.y + cell.contentLabel.frame.height + Layout.padding_20
                }
                return cell.readMoreButton.frame.origin.y + cell.readMoreButton.bounds.height + Layout.padding_20
            }
            return cell.headerLabel.frame.origin.y + cell.headerLabel.frame.height + Layout.padding_20
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.displayMode {
        case .checkbox: return section == 1 ? 152 : 0
        case .normal: return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.displayMode {
        case .checkbox:
            if section == 1 {
                sectionHeaderView = UINib(resource: R.nib.prepareSectionHeaderView)
                    .instantiate(withOwner: nil).first as? PrepareSectionHeaderView
                sectionHeaderView?.configure(eventName: viewModel.eventName,
                                             eventDate: viewModel.eventDate,
                                             completedTasks: viewModel.completedTasksValue,
                                             headerID: viewModel.headerID)
                sectionHeaderView?.delegate = delegate
                return sectionHeaderView
            }
            return nil
        case .normal: return nil
        }
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
        guard
            let indexPath = tableView.indexPath(for: cell),
            let contentItem = viewModel.item(at: indexPath) else { return }
        switch contentItem {
        case .item(let id, _, _, _):
            viewModel.didTapCheckbox(id: id)
            tableView.beginUpdates()
            let headerIndexPath = IndexPath(row: 0, section: 0)
            if let headerCell = tableView.cellForRow(at: headerIndexPath) {
                configure(cell: headerCell, forIndexPath: headerIndexPath)
            }
            sectionHeaderView?.upddateCompletedTasks(viewModel.completedTasksValue)
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
            let playerViewController = stream(videoURL: videoURL,
                                              contentItem: nil,
                                              PrepareContentViewController.pageName)
            if let playerItem = playerViewController.player?.currentItem {
                avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
                avPlayerObserver?.onStatusUpdate { (player) in
                    if playerItem.error != nil {
                        playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                    }
                }
            }
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
