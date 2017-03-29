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
    func didTapVideo(with localID: String, from view: UIView, in viewController: LearnStrategyViewController)
    func didTapReadMore(with localID: String, from view: UIView, in viewController: LearnStrategyViewController)
    func didScrollToFinish(in viewController: LearnStrategyViewController)
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
        NSAttributedString
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension LearnStrategyViewController {

}
