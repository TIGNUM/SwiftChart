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

final class LearnStrategyViewController: UITableViewController {

    // MARK: - Properties

    let viewModel: LearnStrategyViewModel
    weak var delegate: LearnStrategyViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: LearnStrategyViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .black
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LearnStrategyViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        let item = viewModel.item(at: indexPath)

        switch item {
        case .header(_, let title, let subtitle):
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = subtitle

        case .text(_, let text):
            cell.textLabel?.attributedText = text

        case .video(_, _, let description):
            cell.textLabel?.attributedText = description

        case .article(_, let title, let subtitle):
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = subtitle
        }

        return cell
    }
}
