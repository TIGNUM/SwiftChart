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

    private let viewModel: GuideModel
    private let headerRatio: CGFloat = 0.8957219251
    private let fadeMaskLocation: UIView.FadeMaskLocation

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

    init(viewModel: GuideModel, fadeMaskLocation: UIView.FadeMaskLocation) {
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
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(arc4random_uniform(20))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : Int(arc4random_uniform(20)) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell: GuideHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(message: "Hi Jogi\nLorem ipsum texh here here there text copy start",
                           timing: "Plan timing 24 minutes")

            return cell
        }

        if indexPath.row == 0 {
            let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
            let dailyPrepResults: [[String: Any?]] = [["value": "5", "color": UIColor.white, "title": "Sleep\nQuality"],
                                                     ["value": "2", "color": UIColor.white, "title": "Sleep\nQuantity"],
                                                     ["value": "8", "color": UIColor.cherryRed, "title": "Load\nIndex"],
                                                     ["value": "2", "color": UIColor.white, "title": "Pressure\nIndex"],
                                                     ["value": "7", "color": UIColor.cherryRed, "title": "Workday\nLength"]]
            let dailyPrepToDo: [[String: Any?]] = [["value": nil, "color": nil, "title": "Sleep\nQuality"],
                                                   ["value": nil, "color": nil, "title": "Sleep\nQuantity"],
                                                   ["value": nil, "color": nil, "title": "Load\nIndex"],
                                                   ["value": nil, "color": nil, "title": "Pressure\nIndex"],
                                                   ["value": nil, "color": nil, "title": "Workday\nLength"]]
            let dailyPrep = indexPath.section % 2 == 0 ? dailyPrepResults : dailyPrepToDo
            cell.configure(dailyPrepResults: dailyPrep, status: indexPath.row % 2 == 0 ? .todo : .done)

            return cell
        }

        let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: LoremIpsum.title(),
                       content: LoremIpsum.sentence(),
                       type: LoremIpsum.word(),
                       status: indexPath.row % 2 == 0 ? .todo : .done)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0 && indexPath.row == 0) ? (view.bounds.width * headerRatio) : UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else { return nil }
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: 64))
        let label = UILabel(frame: view.frame)
        let headline = String(format: ".0000%d PLAN", section)
        view.addSubview(label)
        view.backgroundColor = .pineGreen
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 64
    }
}
