//
//  MyStatisticsViewController.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol MyStatisticsViewControllerDelegate: class {
    func didSelectStatitcsCard(in section: Index, at index: Index, from viewController: MyStatisticsViewController)
}

final class MyStatisticsViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: MyStatisticsViewModel
    weak var delegate: MyStatisticsViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            style: .grouped,
            delegate: self,
            dataSource: self,
            dequeables: MyStatisticsTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: MyStatisticsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

// MARK: - Private

private extension MyStatisticsViewController {

    func setupView() {
        view.addSubview(tableView)
        tableView.topAnchor == view.topAnchor + 64
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyStatisticsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(400)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 20, y: 0, width: tableView.bounds.width, height: 20))
        let label = UILabel(frame: view.frame)
        let headline = viewModel.title(in: section).uppercased()
        view.addSubview(label)
        label.attributedText = Style.subTitle(headline, .white).attributedString()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(20)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell: MyStatisticsTableViewCell = tableView.dequeueCell(for: indexPath)        
        cell.setup(viewModel: viewModel, currentSection: indexPath.section)

        return cell
    }
}

// MARK: - CustomPresentationAnimatorDelegate {

extension MyStatisticsViewController: CustomPresentationAnimatorDelegate {
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {

        parent?.view.alpha = animator.isPresenting ? 0.0 : 1.0
        return { [unowned self] in
            self.parent?.view.alpha = animator.isPresenting ? 1.0 : 0.0
        }
    }
}
