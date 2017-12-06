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

    private lazy var tableView: UITableView = {
        return UITableView(estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: GuideModel) {
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
}

// MARK: - Private

private extension GuideViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor + UIApplication.shared.statusBarFrame.height
        tableView.bottomAnchor == view.bottomAnchor
        tableView.leftAnchor == view.leftAnchor
        tableView.rightAnchor == view.rightAnchor
        tableView.backgroundColor = .pineGreen
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Int(arc4random_uniform(20))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(arc4random_uniform(20))
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: LoremIpsum.title(),
                       content: LoremIpsum.sentence(),
                       type: LoremIpsum.word(),
                       status: .open)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: 20))
        let label = UILabel(frame: view.frame)
        let headline = String(format: ".0000%d PLAN", section + 1)
        view.addSubview(label)
        view.backgroundColor = .pineGreen
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()

        return view
    }
}
