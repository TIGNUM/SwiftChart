//
//  PrepareCheckListViewController.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareCheckListViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareCheckListViewController)
    func didTapVideo(with ID: String, from view: UIView, in viewController: PrepareCheckListViewController)
    func didTapSelectCheckbox(with ID: String, from view: UIView, at index: Index, in viewController: PrepareCheckListViewController)
    func didTapDeselectCheckbox(with ID: String, from view: UIView, at index: Index, in viewController: PrepareCheckListViewController)
}

class PrepareCheckListViewController: UIViewController {

    let viewModel: PrepareCheckListViewModel
    weak var delegate: PrepareCheckListViewControllerDelegate?

    init(viewModel: PrepareCheckListViewModel) {
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
