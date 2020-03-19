//
//  DTPrepareStartInteractor.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTPrepareStartInteractor {

    // MARK: - Properties
    private lazy var worker = DTPrepareStartWorker()
    private let presenter: DTPrepareStartPresenterInterface!

    // MARK: - Init
    init(presenter: DTPrepareStartPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - DTPrepareStartInteractorInterface
extension DTPrepareStartInteractor: DTPrepareStartInteractorInterface {

}
