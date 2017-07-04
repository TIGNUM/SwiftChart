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

    fileprivate lazy var topBarView: PrepareContentTopTabBarView? = {
        let view = Bundle.main.loadNibNamed("PrepareContentTopTabBarView", owner: self, options: [:])?[0] as? PrepareContentTopTabBarView

        view?.setup(title: R.string.localized.topTabBarItemTitlePerpareCoach(),
                    leftButtonIcon: R.image.ic_minimize(),
                    rightButtonIcon: self.viewModel.displayMode == .normal ? R.image.ic_save() : nil,
                    delegate: self)
        return view
    }()
    
    // MARK: - Life Cycle
    
    init(viewModel: PrepareContentViewModel) {
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

        if let topBarView = topBarView {

            view.addSubview(topBarView)
            view.addSubview(tableView)

            topBarView.topAnchor == view.topAnchor
            topBarView.horizontalAnchors == view.horizontalAnchors
            topBarView.heightAnchor == Layout.TabBarView.height
            tableView.topAnchor == topBarView.bottomAnchor
            tableView.bottomAnchor == view.bottomAnchor
            tableView.horizontalAnchors == view.horizontalAnchors
        } else {
            tableView.topAnchor == view.topAnchor
            tableView.bottomAnchor == view.bottomAnchor
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
                               isExpanded: isExpanded)

            castedCell.contentView.layoutIfNeeded()

            return castedCell

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

        case .tableFooter(let preparationID):
            guard let castedCell = cell as? PrepareContentFooterTableViewCell else { return cell }
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

        switch contentItem {
        case .titleItem:
            guard let cell = Bundle.main.loadNibNamed("PrepareContentMainHeaderTableViewCell", owner: self, options: [:])?[0] as? PrepareContentMainHeaderTableViewCell else { return UITableViewAutomaticDimension }

            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)

            configure(cell: cell, forIndexPath: indexPath)

            var contentHeight: CGFloat = 0
            if viewModel.isCellExpanded(at: indexPath.row) {
                let padding: CGFloat = 15
                guard let contentText = cell.contentLabel.text else { return UITableViewAutomaticDimension }
                contentHeight = calculateLabelHeight(text: contentText, font: Font.DPText, dispayedLineHeight: 29, frameWidth: cell.frame.width - 60)
                contentHeight += cell.previewImageView.frame.height + padding
            }

            guard let headerText = cell.headerLabel.text else { return UITableViewAutomaticDimension }
            let headerHeight = calculateLabelHeight(text: headerText, font: Font.H1MainTitle, dispayedLineHeight: 43, frameWidth: cell.frame.width - 99)

            guard let subHeaderText = cell.subHeaderLabel.text else { return UITableViewAutomaticDimension }
            let subHeaderHeight = calculateLabelHeight(text: subHeaderText, font: Font.H7Title, dispayedLineHeight: 9, frameWidth: cell.frame.width - 99)

            let padding: CGFloat = 36
            let cellHeight = headerHeight + subHeaderHeight + contentHeight + padding

            return cellHeight
        case .item:
            guard let cell = Bundle.main.loadNibNamed("PrepareContentHeaderTableViewCell", owner: self, options: [:])?[0] as? PrepareContentHeaderTableViewCell else { return UITableViewAutomaticDimension }

            cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: tableView.frame.width, height: cell.frame.height)

            configure(cell: cell, forIndexPath: indexPath)

            var contentHeight: CGFloat = 0
            if viewModel.isCellExpanded(at: indexPath.row) {
                let padding: CGFloat = 15

                guard let contentText = cell.contentLabel.text else { return UITableViewAutomaticDimension }
                contentHeight = calculateLabelHeight(text: contentText, font: Font.DPText, dispayedLineHeight: 29, frameWidth: cell.frame.width - 60)

                contentHeight += cell.readMoreButton.frame.height + padding
            }
            guard let headerText = cell.headerLabel.text else { return UITableViewAutomaticDimension }
            let headerHeight = calculateLabelHeight(text: headerText, font: Font.H4Headline, dispayedLineHeight: 24, frameWidth: cell.frame.width - 132)
            let padding: CGFloat = 31
            let cellHeight = headerHeight + contentHeight + padding

            return cellHeight
        default:
            return UITableViewAutomaticDimension
        }
    }

    private func calculateLabelHeight(text: String, font: UIFont, dispayedLineHeight: CGFloat, frameWidth: CGFloat) -> CGFloat {
        let lineHeight = "a".height(withConstrainedWidth: frameWidth, font: font)

        var headerHeight = text.height(withConstrainedWidth: frameWidth, font: font)

        headerHeight = headerHeight / lineHeight * dispayedLineHeight

        return headerHeight
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
        let indexPathHeader = IndexPath(row: 0, section: 0)
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let cellHeader = tableView.cellForRow(at: indexPathHeader) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }

        let contentItem = viewModel.item(at: indexPath.row)

        switch contentItem {
        case .item(let id, _, _, _):
            viewModel.didTapCheckbox(id: id)
            tableView.beginUpdates()
            configure(cell: cellHeader, forIndexPath: indexPathHeader)
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
            delegate?.didTapVideo(with: videoURL, from: cell, in: self)
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
