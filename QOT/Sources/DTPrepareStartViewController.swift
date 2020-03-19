//
//  DTPrepareStartViewController.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTPrepareStartViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var intentionTitleLabel: UILabel!
    @IBOutlet private weak var intentionsLabel: UILabel!
    @IBOutlet private weak var strategyTitleLabel: UILabel!
    @IBOutlet private weak var strategiesLabel: UILabel!
    @IBOutlet private weak var selectionTitleLabel: UILabel!
    @IBOutlet private weak var criticalButton: UIButton!
    @IBOutlet private weak var dailyButton: UIButton!

    var interactor: DTPrepareStartInteractorInterface!
    private lazy var router: DTPrepareStartRouterInterface = DTPrepareStartRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<DTPrepareStartViewController>) {
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
private extension DTPrepareStartViewController {

}

// MARK: - Actions
private extension DTPrepareStartViewController {
    @IBAction func didTapCriticalEvent() {

    }

    @IBAction func didTapDailyEvent() {

    }
}

// MARK: - DTPrepareStartViewControllerInterface
extension DTPrepareStartViewController: DTPrepareStartViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
