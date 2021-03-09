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

final class CoachViewController: BaseWithTableViewController, ScreenZLevelCoach {

    // MARK: - Properties

    var interactor: CoachInteractorInterface?
    private var coachModel: CoachModel?
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.qotTools.apply(view)
        ThemeView.qotTools.apply(tableView)
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

// MARK: - Bottom Navigation
extension CoachViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [dismissNavigationItem()]
    }
}

// MARK: - Private

private extension CoachViewController {

    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: BottomNavigationContainer.height, right: .zero)
        tableView.registerDequeueable(CoachTableViewCell.self)
    }
}

// MARK: - CoachViewControllerInterface

extension CoachViewController: CoachViewControllerInterface {

    func setupView() {
        setupTableView()
    }

    func setup(for coachSection: CoachModel) {
        coachModel = coachSection
        tableView.reloadData()
    }
}

extension CoachViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return coachModel?.coachItems.count ?? .zero
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return CoachTableHeaderView.init(title: "/" + (coachModel?.headerTitle?.lowercased().capitalizingFirstLetter() ?? String.empty),
                                             subtitle: coachModel?.headerSubtitle ?? String.empty)
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CoachTableHeaderView.init(title: coachModel?.headerTitle?.lowercased().capitalizingFirstLetter() ?? String.empty,
                                         subtitle: coachModel?.headerSubtitle ?? String.empty).calculateHeight(for: tableView.frame.size.width)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CoachTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = coachModel?.coachItems[indexPath.row]
        cell.configure(title: item?.title ?? String.empty, subtitle: item?.subtitle ?? String.empty)
        cell.setSelectedColor(.tignumPink40, alphaComponent: 0.4)
        addDisclosure(to: cell)
        cell.addTopLine(for: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)

        let sectionTapped = coachModel?.sectionItem(at: indexPath)
        trackUserEvent(.SELECT, valueType: String(indexPath.row), action: .TAP)
        interactor?.handleTap(coachSection: sectionTapped ?? .search)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
    }
}

private extension CoachViewController {

    func addDisclosure(to cell: UITableViewCell) {
        let accessoryView = UIImageView(image: R.image.diagonalArrow())
        accessoryView.tintColor = .actionBlue
        cell.accessoryView = accessoryView
        cell.accessoryView?.frame = CGRect(x: .zero, y: .zero, width: 16, height: 16)
    }
}
