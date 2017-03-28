//
//  UpcomingTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol UpcomingTripsViewControllerDelegate: class {
    func didTapClose(in viewController: UpcomingTripsViewController)
    func didTapUpcomingTrip(with localID: String, in viewController: UpcomingTripsViewController)
    func didTapAddNewTrip(in viewController: UpcomingTripsViewController)
    func didTapAddToReminder(in viewController: UpcomingTripsViewController)
    func didTapSaveAsPDF(with localID: String, in viewController: UpcomingTripsViewController)
}

final class UpcomingTripsViewController: UIViewController {

    let viewModel: UpcomingTripViewModel
    weak var delegate: UpcomingTripsViewControllerDelegate?

    init(viewModel: UpcomingTripViewModel) {
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
