//
//  PartnersViewController.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PartnersViewControllerDelegate: class {
    func didTapClose(in viewController: UIViewController, animated: Bool)
    func didTapEdit(partner: Partner, in viewController: UIViewController)
}

class PartnersViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: PartnersViewModel
    weak var delegate: PartnersViewControllerDelegate?

    // MARK: - Init

    init(viewModel: PartnersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .brown
    }
}

// MARK: - Actions

extension PartnersViewController {

    func closeView() {
        delegate?.didTapClose(in: self, animated: false)
    }
}

// MARK: - TopTabBarItem

extension PartnersViewController: TopTabBarItem {

    var topTabBarItem: TopTabBarController.Item {
        return TopTabBarController.Item(controller: self, title: R.string.localized.meSectorMyWhyPartnersTitle())
    }
}
