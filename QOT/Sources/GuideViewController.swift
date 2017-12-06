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
        tableView.horizontalAnchors == view.horizontalAnchors
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
}
