//
//  WeeklyChoicesViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class WeeklyChoicesViewController: UIViewController {

    // MARK: - Properties

    lazy var tableView = UITableView()
    let viewModel: WeeklyChoicesViewModel

    // MARK: - Init

    init(viewModel: WeeklyChoicesViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension WeeklyChoicesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        let weeklyChoice = viewModel.item(at: indexPath.row)
        cell.textLabel?.text = weeklyChoice.title
        cell.detailTextLabel?.text = weeklyChoice.text

        return cell
    }
}
