//
//  LearnStrategyViewController.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnStrategyViewControllerDelegate: class {
    func didTapClose(in viewController: LearnStrategyViewController)
    func didTapShare(in viewController: LearnStrategyViewController)
    func didTapVideo(with video: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController)
    func didTapArticle(with article: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController)
}

final class LearnStrategyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifier = "Cell"
    let viewModel: LearnStrategyViewModel
    weak var delegate: LearnStrategyViewControllerDelegate?
    
    init(viewModel: LearnStrategyViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.registerDequeueable(LearnStrategyHeaderCell.self)
        tableView.registerDequeueable(LearnStrategyArticleCell.self)
        tableView.registerDequeueable(LearnStrategyTextCell.self)
        tableView.registerDequeueable(LearnStrategyVideoCell.self)
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension LearnStrategyViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension LearnStrategyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)
        switch item {
        case .header( _, let title, let subtitle):
            let cell: LearnStrategyHeaderCell = tableView.dequeueCell(for: indexPath)
            cell.setup(with:  title, subTitle: subtitle)
            return cell
        case .article( _, let title, let subtitle):
            let cell: LearnStrategyArticleCell = tableView.dequeueCell(for: indexPath)
            cell.setup(with: title, subtitle: subtitle)
            return cell
        case .text( _, let text):
            let cell: LearnStrategyTextCell = tableView.dequeueCell(for: indexPath)
            cell.setup(with: text)
            return cell
        case .video( _, let placeholderURL, let description):
            let cell: LearnStrategyVideoCell = tableView.dequeueCell(for: indexPath)
            cell.setup(with: placeholderURL, description: description)
            return cell
        }
    }
}


