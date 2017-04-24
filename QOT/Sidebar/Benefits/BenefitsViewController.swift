//
//  BenefitsViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol BenefitsViewControllerDelegate: class {
    func didTapMedia(with item: BenefitItem, from view: UIView, in viewController: BenefitsViewController)
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
}

// MARK: - TopTabBarItem

extension BenefitsViewController: TopTabBarItem {

    var topTabBarItem: TopTabBarController.Item {
        return TopTabBarController.Item(controller: self, title: R.string.localized.sidebarTitleBenefits())
    }
}
