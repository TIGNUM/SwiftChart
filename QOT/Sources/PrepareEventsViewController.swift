//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol PrepareEventsViewControllerDelegate: class {

    func didTapClose(viewController: PrepareEventsViewController)
    func didTapAddToPrepList(viewController: PrepareEventsViewController)
    func didTapEvent(event: PrepareEventsViewModel.Event, viewController: PrepareEventsViewController)
    func didTapSavePrepToDevice(viewController: PrepareEventsViewController)
}

final class PrepareEventsViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: PrepareEventsViewModel
    weak var delegate: PrepareEventsViewControllerDelegate?

    // MARK: - Init

    init(viewModel: PrepareEventsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
