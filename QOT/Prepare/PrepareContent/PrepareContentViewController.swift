//
//  PrepareContentViewController.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Bond

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

final class PrepareContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PrepareContentActionButtonsTableViewCellDelegate {

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    let viewModel: PrepareContentViewModel
    weak var delegate: PrepareContentViewControllerDelegate?

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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black

        self.tableView.registerDequeueable(PrepareContentTextTableViewCell.self)
        self.tableView.registerDequeueable(PrepareContentHeaderTableViewCell.self)
        self.tableView.registerDequeueable(PrepareContentVideoPreviewTableViewCell.self)
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)        
    }

}

 // MARK: - UITableViewDelegate, UITableViewDataSource, PrepareContentActionButtonsTableViewCellDelegate

extension PrepareContentViewController
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }

    func didAddPreparationToCalendar() {
        //implement
    }

    func didAddToNotes() {
        //implement
    }

    func didSaveAss() {
        //implement
    }


}
