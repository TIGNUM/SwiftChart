//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareTripsViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareTripsViewController)
    func didTapUpcomingTrip(with localID: String, in viewController: PrepareTripsViewController)
    func didTapAddNewTrip(in viewController: PrepareTripsViewController)
    func didTapAddToReminder(in viewController: PrepareTripsViewController)
    func didTapSaveAsPDF(with localID: String, in viewController: PrepareTripsViewController)
}

final class PrepareTripsViewController: UIViewController {

    let viewModel: PrepareTripsViewModel
    weak var delegate: PrepareTripsViewControllerDelegate?

    init(viewModel: PrepareTripsViewModel) {
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
