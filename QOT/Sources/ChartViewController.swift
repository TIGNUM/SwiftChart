//
//  ChartViewController.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ChartViewControllerDelegate: class {

    func didSelectChart(in section: Index, at index: Index, from viewController: ChartViewController)
}

final class ChartViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: ChartViewModel
    weak var delegate: ChartViewControllerDelegate?

    fileprivate lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
                           delegate: self,
                           dataSource: self,
                           dequeables: ChartTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: ChartViewModel) {
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

// MARK: - Private

private extension ChartViewController {

    func setupView() {
        view.addSubview(tableView)
        view.applyFade()
        tableView.verticalAnchors == view.verticalAnchors
        tableView.horizontalAnchors == view.horizontalAnchors
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: 20))
        let label = UILabel(frame: view.frame)
        let headline = viewModel.sectionTitle(in: section).uppercased()
        view.addSubview(label)
        label.attributedText = Style.subTitle(headline, .white).attributedString()

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell: ChartTableViewCell = tableView.dequeueCell(for: indexPath)        
        cell.setup(viewModel: viewModel, currentSection: indexPath.section)

        return cell
    }
}

// MARK: - CustomPresentationAnimatorDelegate {

extension ChartViewController: CustomPresentationAnimatorDelegate {

    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        parent?.view.alpha = animator.isPresenting ? 0.0 : 1.0

        return { [unowned self] in
            self.parent?.view.alpha = animator.isPresenting ? 1.0 : 0.0
        }
    }
}
