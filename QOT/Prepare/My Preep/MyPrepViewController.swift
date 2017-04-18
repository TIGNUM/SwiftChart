//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyPrepViewControllerDelegate: class {
    func didTapClose(in viewController: MyPrepViewController)
    func didTapMyPrepItem(with myPrepItem: MyPrepItem, at index: Index, from view: UIView, in viewController: MyPrepViewController)
}

class MyPrepViewController: UITableViewController {

    // MARK: - Properties

    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: MyPrepViewModel) {
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
        view.backgroundColor = .yellow
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}
