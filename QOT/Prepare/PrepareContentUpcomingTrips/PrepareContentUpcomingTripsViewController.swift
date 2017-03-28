//
//  PrepareContentUpcomingTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentUpcomingTripsViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareContentUpcomingTripsViewController)
    func didTapUpcomingTrip(with localID: String, in viewController: PrepareContentUpcomingTripsViewController)
    func didTapAddNewTrip(in viewController: PrepareContentUpcomingTripsViewController)
    func didTapAddToReminder(in viewController: PrepareContentUpcomingTripsViewController)
    func didTapSaveAsPDF(with localID: String, in viewController: PrepareContentUpcomingTripsViewController)
}

final class PrepareContentUpcomingTripsViewController: UIViewController {

    let viewModel: PrepareContentUpcomingTripViewModel
    weak var delegate: PrepareContentUpcomingTripsViewControllerDelegate?

    init(viewModel: PrepareContentUpcomingTripViewModel) {
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
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.9
        view.addSubview(blurEffectView)
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}
