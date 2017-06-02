//
//  LearnContentItemBulletViewController.swift
//  QOT
//
//  Created by karmic on 09.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

final class LearnContentItemBulletViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: LearnContentItemViewModel
    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            backgroundColor: .white,
            estimatedRowHeight: 10,
            delegate: self,
            dataSource: self,
            dequeables:
            ContentItemTextTableViewCell.self,
            ImageSubtitleTableViewCell.self
        )
    }()

    // MARK: Init

    init(viewModel: LearnContentItemViewModel) {
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension LearnContentItemBulletViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contentItem = viewModel.contentItem(at: indexPath) else {
            fatalError("No contentItem available!")
        }

        let cell: ContentItemTextTableViewCell = tableView.dequeueCell(for: indexPath)

        switch contentItem {
        case .text(let text, _):
            let topText = AttributedString.Learn.articleTitle(string: text)
            cell.setup(topText: topText, bottomText: topText)
            return cell
        case .audio(let title, _, _, _, _, _):
            let topText = AttributedString.Learn.articleTitle(string: title)
            cell.setup(topText: topText, bottomText: topText)
            return cell
        case .image(let title, _, _):
            let topText = AttributedString.Learn.articleTitle(string: title)
            cell.setup(topText: topText, bottomText: topText)
            return cell
        case .video(let title, _, _, _, _):
            let topText = AttributedString.Learn.articleTitle(string: title)
            cell.setup(topText: topText, bottomText: topText)
            return cell
        }
    }
}

// MARK: - Private

private extension LearnContentItemBulletViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }
}
