//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionViewControllerDelegate: class {
    func didTapClose(in viewController: MyToBeVisionViewController)
}

class MyToBeVisionViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: MyToBeVisionViewModel
    fileprivate var scrollView: UIScrollView = UIScrollView()
    weak var delegate: MyToBeVisionViewControllerDelegate?

    // MARK: - Init

    init(viewModel: MyToBeVisionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupScrollView()
    }

    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeView))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = .red
    }
}

// MARK: - Actions

extension MyToBeVisionViewController {

    func closeView() {
        delegate?.didTapClose(in: self)
    }
}

// MARK: - ScrollView, UIScrollViewDelegate

extension MyToBeVisionViewController: UIScrollViewDelegate {

    func setupScrollView() {
        // TODO
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO
    }
}
