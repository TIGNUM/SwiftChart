//
//  GuideViewController.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import LoremIpsum

final class GuideViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let viewModel: GuideViewModel
    private let headerRatio: CGFloat = 0.8957219251
    private let fadeMaskLocation: UIView.FadeMaskLocation

    private lazy var headerView: GuideHeaderTableViewCell? = {
        let cell = Bundle.main.loadNibNamed("GuideHeaderTableViewCell", owner: self, options: [:])?.first as? GuideHeaderTableViewCell
        cell?.configure(message: "Hi Jogi\nLorem ipsum texh here here there text copy start",
                       timing: "Plan timing 24 minutes")

        return cell
    }()

    private lazy var tableView: UITableView = {
        return UITableView(contentInsets: UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideTableViewCell.self,
                                       GuideHeaderTableViewCell.self,
                                       GuideDailyPrepTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: GuideViewModel, fadeMaskLocation: UIView.FadeMaskLocation) {
        self.viewModel = viewModel
        self.fadeMaskLocation = fadeMaskLocation

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
}

// MARK: - Private

private extension GuideViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor - UIApplication.shared.statusBarFrame.height
        tableView.bottomAnchor == view.bottomAnchor
        tableView.leftAnchor == view.leftAnchor
        tableView.rightAnchor == view.rightAnchor
        tableView.backgroundColor = .pineGreen
        view.setFadeMask(at: fadeMaskLocation)
        guard let header = headerView else { return }
        tableView.tableHeaderView = header
    }

    func launch() {
        let laucnhHandler = LaunchHandler()
        laucnhHandler.dailyPrep(groupID: "100002")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plan = viewModel.planItem(indexPath: indexPath)

        if
            indexPath.row == 0,
            let dailyPrepItem = viewModel.dailyPrepItem() {
                let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(dailyPrepItem: dailyPrepItem)
                return cell
        }
//
//        if indexPath.row == 0 {
//            let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
//            let dailyPrepResults: [[String: Any?]] = [["value": "5", "color": UIColor.white, "title": "Sleep\nQuality"],
//                                                     ["value": "2", "color": UIColor.white, "title": "Sleep\nQuantity"],
//                                                     ["value": "8", "color": UIColor.cherryRed, "title": "Load\nIndex"],
//                                                     ["value": "2", "color": UIColor.white, "title": "Pressure\nIndex"],
//                                                     ["value": "7", "color": UIColor.cherryRed, "title": "Workday\nLength"]]
//            let dailyPrepToDo: [[String: Any?]] = [["value": nil, "color": nil, "title": "Sleep\nQuality"],
//                                                   ["value": nil, "color": nil, "title": "Sleep\nQuantity"],
//                                                   ["value": nil, "color": nil, "title": "Load\nIndex"],
//                                                   ["value": nil, "color": nil, "title": "Pressure\nIndex"],
//                                                   ["value": nil, "color": nil, "title": "Workday\nLength"]]
//            let dailyPrep = indexPath.section % 2 == 0 ? dailyPrepResults : dailyPrepToDo
//            cell.configure(dailyPrepResults: dailyPrep, status: indexPath.row % 2 == 0 ? .todo : .done)
//
//            return cell
//        }

        let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: plan.title ?? "",
                       content: plan.body,
                       type: plan.type,
                       status: plan.status)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return /*(indexPath.section == 0 && indexPath.row == 0) ? (view.bounds.width * headerRatio) :*/ UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard section != 0 else { return nil }
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: 64))
        let label = UILabel(frame: view.frame)
        let headline = String(format: ".0000%d PLAN", section + 1)
        view.addSubview(label)
        view.backgroundColor = .pineGreen
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64//section == 0 ? 0 : 64
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launch()
    }
}

// MARK: - UIScrollViewDelegate

extension GuideViewController {

    func alpha(_ scrollView: UIScrollView) -> CGFloat {
        print((abs(scrollView.bounds.minY) + scrollView.contentOffset.y))
        let minY = (tableView.tableHeaderView?.bounds.height ?? 0) - (abs(scrollView.bounds.minY) + scrollView.contentOffset.y)
        guard minY > 0 else { return 0 }

        return 1 - (scrollView.contentOffset.y/minY)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        headerView?.updateBackgroundImageView(alpha: alpha(scrollView))
    }
}
