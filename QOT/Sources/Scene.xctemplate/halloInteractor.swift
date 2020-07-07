//
//  halloInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class halloInteractor {

    // MARK: - Properties
    private lazy var worker = halloWorker()
    private let presenter: halloPresenterInterface!

    // MARK: - Init
    init(presenter: halloPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - halloInteractorInterface
extension halloInteractor: halloInteractorInterface {

}
