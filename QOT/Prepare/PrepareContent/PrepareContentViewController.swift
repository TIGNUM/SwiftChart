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

    private let estimatedRowHeight: CGFloat = 140.0

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
        self.tableView.registerDequeueable(PrepareContentStepTableViewCell.self)
        self.tableView.registerDequeueable(PrepareContentTitleTableViewCell.self)
        self.tableView.registerDequeueable(PrepareContentActionButtonsTableViewCell.self)

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = estimatedRowHeight
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)        
    }

}

 // MARK: - UITableViewDelegate, UITableViewDataSource, PrepareContentActionButtonsTableViewCellDelegate

extension PrepareContentViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contentItem = self.viewModel.item(at: indexPath.row)

        switch contentItem {
        case .header(let item):
            let cell: PrepareContentHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.headerLabel.text = item.title
            return cell

        case .text(let item):
            let cell: PrepareContentTextTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.contentTextView.text = item.text
            return cell

        case.video(let item):
            let cell: PrepareContentVideoPreviewTableViewCell = tableView.dequeueCell(for: indexPath)
            getDataFromUrlAndSetImageView(url: item.placeholderURL, imageView: cell.imageView!)
            return cell

        case .step(let item):
            let cell: PrepareContentStepTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.stepNumberLabel.text = "\(item.index)"
            cell.stepContentLabel.text = item.text
            return cell

        case .sectionFooter:
            let cell = UITableViewCell()
            return cell

        case .tableFooter:
            let cell: PrepareContentActionButtonsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            return cell

        case .title(let item):
            let cell: PrepareContentTitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.text = item.text.uppercased()
            return cell

        }
    }

    // NOT Fully implemented because not sure how You want this to be done - i'll ask on standup
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentItem = self.viewModel.item(at: indexPath.row)

        switch contentItem {
        case .header(let item):
            break

        case .text(let item):
           break

        case.video(let item):
            break

        case .step(let item):
           break

        case .sectionFooter:
           break

        case .tableFooter:
           break

        case .title(let item):
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

    func getDataFromUrlAndSetImageView(url: URL, imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            imageView.image = UIImage(data: data!)
        }
        task.resume()
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
