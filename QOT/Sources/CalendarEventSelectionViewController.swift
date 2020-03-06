//
//  CalendarEventSelectionViewController.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionViewController: UIViewController {

    // MARK: - Properties
    var interactor: CalendarEventSelectionInteractorInterface!
    private weak var router: CalendarEventSelectionRouterInterface = CalendarEventSelectionRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<CalendarEventSelectionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension CalendarEventSelectionViewController {

}

// MARK: - Actions
private extension CalendarEventSelectionViewController {

}

// MARK: - CalendarEventSelectionViewControllerInterface
extension CalendarEventSelectionViewController: CalendarEventSelectionViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
