//
//  SidebarItemViewController.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol SidebarItemViewControllerDelegate: class {
    func didTapVideo(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapAudio(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapImage(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController)
    func didTapMore(from view: UIView, in viewController: SidebarItemViewController)
}

final class SidebarItemViewController: UIViewController {

    // MARK: - Properties

    let viewModel: SidebarItemViewModel
    weak var delegate: SidebarItemViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: SidebarItemViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
