//
//  CoachViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(CoachNavigationController.classForCoder())
}

final class CoachViewController: UIViewController {

    // MARK: - Properties

    var interactor: CoachInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var coachModel: CoachModel?
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .sand
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension CoachViewController {

    func setupTableView() {
        tableView.registerDequeueable(CoachTableViewCell.self)
    }
}

// MARK: - Actions

private extension CoachViewController {

    @objc func didTabClose() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeButton(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }
}

// MARK: - CoachViewControllerInterface

extension CoachViewController: CoachViewControllerInterface {

    func setupView() {
        setupTableView()
    }

    func setup(for coachSection: CoachModel) {
        coachModel = coachSection
    }
}

extension CoachViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return coachModel?.coachItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return CoachTableHeaderView.instantiateFromNib(title: coachModel?.headerTitle ?? "", subtitle: coachModel?.headerSubtitle ?? "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoachTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: (coachModel?.coachItems[indexPath.row].title) ?? "", subtitle: (coachModel?.coachItems[indexPath.row].subtitle) ?? "")
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.accent.withAlphaComponent(0.1)
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionTapped = coachModel?.sectionItem(at: indexPath)
        interactor?.handleTap(coachSection: sectionTapped ?? .search)
    }
}
