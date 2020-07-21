//
//  BookMarkSelectionViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class BookMarkSelectionViewController: UIViewController {

    // MARK: - Properties

    var interactor: BookMarkSelectionInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<BookMarkSelectionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension BookMarkSelectionViewController {

    func setupView() {

    }
}

// MARK: - Actions

private extension BookMarkSelectionViewController {

}

// MARK: - BookMarkSelectionViewControllerInterface

extension BookMarkSelectionViewController: BookMarkSelectionViewControllerInterface {

}
