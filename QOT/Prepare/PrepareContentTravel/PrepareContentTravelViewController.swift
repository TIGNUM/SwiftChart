//
//  PrepareContentTravelViewController.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentTravelViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareContentTravelViewController)
    func didTapVideo(with ID: String, from view: UIView, in viewController: PrepareContentTravelViewController)
}

class PrepareContentTravelViewController: UIViewController {

    let viewModel: PrepareContentTravelViewModel
    weak var delegate: PrepareContentTravelViewControllerDelegate?

    init(viewModel: PrepareContentTravelViewModel) {
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
