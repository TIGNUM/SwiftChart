//
//  WeeklyChoicesViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WeeklyChoicesViewControllerDelegate: class {
    func didTapClose(in viewController: UIViewController, animated: Bool)
    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice)
}

final class WeeklyChoicesViewController: UIViewController {

    // MARK: - Properties

    lazy var tableView = UITableView()
    let viewModel: WeeklyChoicesViewModel
    weak var delegate: WeeklyChoicesViewControllerDelegate?

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

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .green
        setupTableView()
    }

    private func setupTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self        
    }

    func closeView() {
        delegate?.didTapClose(in: self, animated: true)
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
