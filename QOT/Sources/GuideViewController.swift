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
    private let sectionHeaderHeight: CGFloat = 64
    private let fadeMaskLocation: UIView.FadeMaskLocation

    private lazy var greetingView: GuideGreetingView? = {
        return Bundle.main.loadNibNamed("GuideGreetingView", owner: self, options: [:])?.first as? GuideGreetingView
    }()

    private lazy var tableView: UITableView = {
        return UITableView(contentInsets: UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideTableViewCell.self,
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
        guard let greetingView = self.greetingView else { return }

        greetingView.configure(message: "Hi Jogi\nLorem ipsum texh here here there text copy start",
                               timing: "Plan timing 24 minutes")
        view.addSubview(greetingView)
        view.addSubview(tableView)
        greetingView.topAnchor == view.topAnchor - UIApplication.shared.statusBarFrame.height
        greetingView.leftAnchor == view.leftAnchor
        greetingView.rightAnchor == view.rightAnchor
        tableView.topAnchor == greetingView.bottomAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.leftAnchor == view.leftAnchor
        tableView.rightAnchor == view.rightAnchor
        tableView.backgroundColor = .pineGreen
        view.setFadeMask(at: fadeMaskLocation)
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
        let item = viewModel.guideItem(indexPath: indexPath)

        if
            indexPath.row == 0,
            let dailyPrepItem = viewModel.dailyPrepItem() {
                let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(dailyPrepItem: dailyPrepItem)
                return cell
        }

        let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: item?.title ?? "",
                       content: item?.body ?? "",
                       type: item?.type ?? "",
                       status: item?.status ?? .todo)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        let label = UILabel(frame: view.frame)
        let headline = String(format: ".0000%d PLAN", section + 1)
        view.addSubview(label)
        view.backgroundColor = .pineGreen
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.guideItem(indexPath: indexPath)
        print("---------------------")
        print(item)
        print(item?.link)
        print(item?.greeting)

        launch()
    }
}
