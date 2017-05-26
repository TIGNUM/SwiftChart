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

protocol PrepareContentViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareContentViewController)
    func didTapShare(in viewController: PrepareContentViewController)
    func didTapVideo(with localID: String, from view: UIView, in viewController: PrepareContentViewController)
    func didTapAddPreparation(sectionID: String, in viewController: PrepareContentViewController)
    func didTapAddToNotes(sectionID: String, in viewController: PrepareContentViewController)
    func didTapSaveAs(sectionID: String, in viewController: PrepareContentViewController)
    func didTapAddPreparation(in viewController: PrepareContentViewController)
    func didTapAddToNotes(in viewController: PrepareContentViewController)
    func didTapSaveAs(in viewController: PrepareContentViewController)
}

final class PrepareContentViewController: UIViewController, PrepareContentActionButtonsTableViewCellDelegate {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    let viewModel: PrepareContentViewModel
    private let disposeBag = DisposeBag()
    private let estimatedRowHeight: CGFloat = 140.0
    weak var delegate: PrepareContentViewControllerDelegate?
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

    // MARK: - Life Cycle

    init(viewModel: PrepareContentViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.registerDequeueable(PrepareContentTextTableViewCell.self)
        tableView.registerDequeueable(PrepareContentHeaderTableViewCell.self)
        tableView.registerDequeueable(PrepareContentVideoPreviewTableViewCell.self)
        tableView.registerDequeueable(PrepareContentStepTableViewCell.self)
        tableView.registerDequeueable(PrepareContentTitleTableViewCell.self)
        tableView.registerDequeueable(PrepareContentActionButtonsTableViewCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 64, right: 0)
        updateTableView(with: tableView)
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapAddPreparation(in: self)
    }

   private func updateTableView(with tableView: UITableView) {
        viewModel.updates.observeNext { [unowned self] (update) in
            switch update {
            case .reload:
                self.tableView.reloadData()
            case .update(_, _, _):
                self.tableView.reloadData()
            }
            }.dispose(in: disposeBag)
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
        case .header(_, let title, let open):
            let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setTitle(title: title, open: open)
            return cell

        case .text(let item):
            let cell: PrepareContentTextTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.prepareAndSetTextAttributes(string: item.text)
            return cell

        case .video(let item):
            let cell: PrepareContentVideoPreviewTableViewCell = tableView.dequeueCell(for: indexPath)
            let url = URL(string: "\(item.placeholderURL)")!
            cell.previewImage.kf.setImage(with: url)
            cell.previewImage.kf.indicatorType = .activity
            return cell

        case .step(let item):
            let cell: PrepareContentStepTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setStepNumber(stepIndex: item.index)
            cell.prepareAndSetTextAttributes(string: item.text)
            return cell

        case .sectionFooter(let sectionID):
            let cell: PrepareContentActionButtonsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.sectionID = sectionID
            cell.delegate = self
            return cell

        case .tableFooter:
            let cell: PrepareContentActionButtonsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            cell.sectionID = nil
            return cell

        case .title(let item):
            let cell: PrepareContentTitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.text = item.text.uppercased()
            return cell
        }
    }

    // NOT Fully implemented because not sure how You want this to be done - i'll ask on standup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentItem = viewModel.item(at: indexPath.row)

        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)

        switch contentItem {

        case .header:
            viewModel.didTapHeader(item: contentItem)
            break

        case.video(let item):
            let cell: PrepareContentVideoPreviewTableViewCell = tableView.dequeueCell(for: indexPath)
            delegate?.didTapVideo(with: item.localID, from: cell.contentView, in: self)
            break

        case .sectionFooter, .tableFooter, .text, .title, .step:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let contentItem = self.viewModel.item(at: indexPath.row)

        switch contentItem {
        case .header, .text, .step, .sectionFooter, .tableFooter, .title:
            return UITableViewAutomaticDimension

        case.video:
            return 200.0
        }
    }

    func didAddPreparationToCalendar(sectionID: String?, cell: UITableViewCell) {
        if let sectionID = sectionID {
            delegate?.didTapAddPreparation(sectionID: sectionID, in: self)
        } else {
            delegate?.didTapAddPreparation(in: self)
        }
    }

    func didAddToNotes(sectionID: String?, cell: UITableViewCell) {
        if let sectionID = sectionID {
            delegate?.didTapAddToNotes(sectionID: sectionID, in: self)
        } else {
            delegate?.didTapAddToNotes(in: self)
        }
    }

    func didSaveAss(sectionID: String?, cell: UITableViewCell) {
        if let sectionID = sectionID {
            delegate?.didTapSaveAs(sectionID: sectionID, in: self)
        } else {
            delegate?.didTapSaveAs(in: self)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
    }
}
