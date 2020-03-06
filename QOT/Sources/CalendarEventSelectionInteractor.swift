//
//  CalendarEventSelectionInteractor.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionInteractor {

    // MARK: - Properties
    private lazy var worker = CalendarEventSelectionWorker()
    private let presenter: CalendarEventSelectionPresenterInterface!

    // MARK: - Init
    init(presenter: CalendarEventSelectionPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - CalendarEventSelectionInteractorInterface
extension CalendarEventSelectionInteractor: CalendarEventSelectionInteractorInterface {

}
