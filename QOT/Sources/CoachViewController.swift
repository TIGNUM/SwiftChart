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

final class CoachViewController: UIViewController, ScreenZLevelCoach {

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.darkNot)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private

private extension CoachViewController {

    func setupTableView() {
        tableView.registerDequeueable(CoachTableViewCell.self)
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItemLight()]
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
            return CoachTableHeaderView.instantiateFromNib(title: coachModel?.headerTitle ?? "",
                                                           subtitle: coachModel?.headerSubtitle ?? "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoachTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = coachModel?.coachItems[indexPath.row]
        cell.configure(title: item?.title ?? "", subtitle: item?.subtitle ?? "")
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionTapped = coachModel?.sectionItem(at: indexPath)
        trackUserEvent(.SELECT, valueType: String(indexPath.row), action: .TAP)
        interactor?.handleTap(coachSection: sectionTapped ?? .search)
    }
}
