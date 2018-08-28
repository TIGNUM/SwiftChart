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
    func saveNotes(notes: String, preparationID: String)
    func didTapReviewNotesButton(sender: UIButton,
                                 reviewNotesType: PrepareContentReviewNotesTableViewCell.ReviewNotesType,
                                 viewModel: PrepareContentViewModel?)
}

final class PrepareContentViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    var viewModel: PrepareContentViewModel
    private let disposeBag = DisposeBag()
    private var avPlayerObserver: AVPlayerObserver?
    weak var delegate: PrepareContentViewControllerDelegate?
    let pageName: PageName

    private lazy var tableView: UITableView = {
        return UITableView(estimatedRowHeight: 140,
                           delegate: self,
                           dataSource: self,
                           dequeables:
            PrepareContentHeaderTableViewCell.self,
            PrepareContentReviewNotesTableViewCell.self,
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

    private let savePreparationButton: UIButton = {
        let button = UIButton()
        let image = R.image.ic_save_prep()?.withRenderingMode(.alwaysTemplate)
        let title = NSMutableAttributedString(string: R.string.localized.preparePrepareEventsSaveThisPreparation(),
                                             letterSpacing: 1,
                                             font: Font.DPText,
                                             textColor: .white)
        button.corner(radius: Layout.CornerRadius.eight.rawValue)
        button.tintColor = .white
        button.backgroundColor = .azure
        button.setImage(image, for: .normal)
        button.setAttributedTitle(title, for: .normal)
        button.addTarget(self, action: #selector(didTapSavePreparation), for: .touchUpInside)
        return button
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
        UIApplication.shared.statusBarStyle = Date().isNight ? .lightContent : .default
        tableView.reloadData()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fixTableViewInsets()
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
        delegate?.didTapSavePreparation(in: self)
    }
}

// MARK: - Private

private extension PrepareContentViewController {
    func setupView() {
        view.backgroundColor = .nightModeBackground
        if pageName == .prepareContent {
            view.addSubview(topBarView)
            view.addSubview(tableView)
            if viewModel.preparationType == .prepContentEvent {
                view.addSubview(savePreparationButton)
                savePreparationButton.topAnchor == tableView.bottomAnchor + 5
                savePreparationButton.centerXAnchor == view.centerXAnchor
                savePreparationButton.horizontalAnchors == view.horizontalAnchors + 40
                savePreparationButton.bottomAnchor == view.safeBottomAnchor - 24
                savePreparationButton.heightAnchor == 40
            }
            topBarView.topAnchor == view.topAnchor + UIApplication.shared.statusBarFrame.height
            topBarView.horizontalAnchors == view.horizontalAnchors
            topBarView.heightAnchor == Layout.TabBarView.height
            tableView.topAnchor == topBarView.bottomAnchor
            tableView.bottomAnchor == view.safeBottomAnchor - 64
            tableView.horizontalAnchors == view.horizontalAnchors
        } else if pageName == .prepareCheckList {
            view.addSubview(tableView)
            tableView.topAnchor == view.safeTopAnchor + 16
            tableView.bottomAnchor == view.safeBottomAnchor - 16
            tableView.horizontalAnchors == view.horizontalAnchors
        }
    }

    @discardableResult func configure(cell: UITableViewCell, forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let contentItem = viewModel.item(at: indexPath.row)

        switch contentItem {
        case .titleItem(let title, let subTitle, let contentText, let placeholderURL, let videoURL):
            guard let castedCell = cell as? PrepareContentMainHeaderTableViewCell else { return cell }
            let isExpanded = viewModel.isCellExpanded(at: indexPath.row)
            castedCell.delegate = self
            castedCell.setCell(title: title,
                               subTitle: subTitle,
                               contentText: contentText,
                               videoPlaceholder: placeholderURL,
                               videoURL: videoURL,
                               isExpanded: isExpanded,
                               displayMode: pageName == .prepareCheckList ? .checkbox : .normal)
            castedCell.contentView.layoutIfNeeded()
            castedCell.iconImageView.isHidden = (viewModel.preparationType == .prepContentProblem) && (indexPath.row == 0)
            return castedCell
        case .reviewNotesHeader(let title):
            guard let subHeaderCell = cell as? PrepareContentSubHeaderTableViewCell else { return cell }
            subHeaderCell.configure(title: title)
            return subHeaderCell
        case .reviewNotesItem(let title, let reviewNotesType):
            guard let reviewNotesCell = cell as? PrepareContentReviewNotesTableViewCell else { return cell }
            reviewNotesCell.configure(title: title,
                                      reviewNotesType: reviewNotesType,
                                      delegate: delegate,
                                      viewModel: viewModel)
            return reviewNotesCell
        case .checkItemsHeader(let title):
            guard let subHeaderCell = cell as? PrepareContentSubHeaderTableViewCell else { return cell }
            subHeaderCell.configure(title: title)
            return subHeaderCell
        case .item(let id, let title, let subTitle, let readMoreID):
            guard let castedCell = cell as? PrepareContentHeaderTableViewCell else { return cell }
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
        case .reviewNotesHeader:
            let cell: PrepareContentSubHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            return configure(cell: cell, forIndexPath: indexPath)
        case .reviewNotesItem:
            let cell: PrepareContentReviewNotesTableViewCell = tableView.dequeueCell(for: indexPath)
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
        let contentItem = viewModel.item(at: indexPath.row)
        switch contentItem {
        case .titleItem, .item:
            viewModel.didTapHeader(index: indexPath.row)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            tableView.beginUpdates()
            configure(cell: cell, forIndexPath: indexPath)
            tableView.endUpdates()
        case .reviewNotesItem,
             .reviewNotesHeader,
             .checkItemsHeader:
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
            // return image button yPos, - an offset
            return cell.previewImageButton.frame.origin.y - 10
        case .reviewNotesItem:
            return 60
        case .reviewNotesHeader,
             .checkItemsHeader:
            return 56
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
            let playerViewController = stream(videoURL: videoURL)
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
