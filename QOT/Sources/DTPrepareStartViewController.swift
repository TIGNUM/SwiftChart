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

    var triggeredByLaunchHandler = false
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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        trackPage()
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation([backNavigationItemLight()], [])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !animated && triggeredByLaunchHandler == true,
            let mainNavigationController = baseRootViewController?.navigationController,
            self.navigationController?.presentingViewController == mainNavigationController {
            router.dismiss()
        }
    }
}

// MARK: - Private
private extension DTPrepareStartViewController {
    func setupButtons(viewModel: DTPrepareStartViewModel) {
        criticalButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: .accent)
        criticalButton.setTitle(viewModel.buttonCritical, for: .normal)
        dailyButton.corner(radius: Layout.CornerRadius.cornerRadius20.rawValue, borderColor: .accent)
        dailyButton.setTitle(viewModel.buttonDaily, for: .normal)
    }
}

// MARK: - Actions
private extension DTPrepareStartViewController {
    @IBAction func didTapCriticalEvent() {
        router.presentChatBotCritical()
    }

    @IBAction func didTapDailyEvent() {
        router.presentChatBotDaily()
    }
}

// MARK: - DTPrepareStartViewControllerInterface
extension DTPrepareStartViewController: DTPrepareStartViewControllerInterface {
    func setupView(viewModel: DTPrepareStartViewModel) {
        setupButtons(viewModel: viewModel)
        ThemeText.H02Light.apply(viewModel.header, to: headerLabel)
        ThemeText.Text02Light.apply(viewModel.intentionTitle, to: intentionTitleLabel)
        ThemeText.Text01Light.apply(viewModel.intentions, to: intentionsLabel)
        ThemeText.Text02Light.apply(viewModel.strategyTitle, to: strategyTitleLabel)
        ThemeText.Text01Light.apply(viewModel.strategies, to: strategiesLabel)
        ThemeText.H02Light.apply(viewModel.selectionTitle, to: selectionTitleLabel)
    }
}
