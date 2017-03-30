//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareEventsViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareEventsViewController)
    func didTapItem(item: PrepareEventsItem, in viewController: PrepareEventsViewController)
}

final class PrepareEventsViewController: UIViewController {

    // MARK: - Properties

    let viewModel: PrepareEventsViewModel
    weak var delegate: PrepareEventsViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: PrepareEventsViewModel) {
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
