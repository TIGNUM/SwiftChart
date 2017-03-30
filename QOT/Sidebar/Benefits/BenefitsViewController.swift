//
//  BenefitsViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol BenefitsViewControllerDelegate: class {
    func didTapClose(in viewController: BenefitsViewController)
    func didTapMedia(with mediaItem: LibraryItem.MediaItem, from view: UIView, in viewController: BenefitsViewController)
    func didTapMore(from view: UIView, in viewController: BenefitsViewController)
}

final class BenefitsViewController: UIViewController {

    // MARK: - Properties

    let viewModel: BenefitsViewModel
    weak var delegate: BenefitsViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: BenefitsViewModel) {
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
