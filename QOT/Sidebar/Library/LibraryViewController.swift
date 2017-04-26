//
//  LibraryViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LibraryViewControllerDelegate: class {
    func didTapMedia(with mediaItem: LibraryMediaItem, from view: UIView, in viewController: UIViewController)
}

final class LibraryViewController: UIViewController {

    // MARK: - Properties

    let viewModel: LibraryViewModel
    weak var delegate: LibraryViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: LibraryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
