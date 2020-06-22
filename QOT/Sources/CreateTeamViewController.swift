//
//  CreateTeamViewController.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CreateTeamViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var textContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var teamTextField: UITextField!
    @IBOutlet private weak var textCounterLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    var interactor: CreateTeamInteractorInterface!
    private lazy var router: CreateTeamRouterInterface = CreateTeamRouter(viewController: self)
    private var bottomConstraintInitialValue: CGFloat = 0

    // MARK: - Init
    init(configure: Configurator<CreateTeamViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = CreateTeamConfigurator.make()
        configurator(self)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        startObservingKeyboard()
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - Private
private extension CreateTeamViewController {

}

// MARK: - Actions
private extension CreateTeamViewController {

}

// MARK: - CreateTeamViewControllerInterface
extension CreateTeamViewController: CreateTeamViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}

// MARK: - Keyboard
extension CreateTeamViewController {
    override func keyboardWillAppear(notification: NSNotification) {
        animateKeyboardNotification(notification)
    }

    override func keyboardWillDisappear(notification: NSNotification) {
        animateKeyboardNotification(notification)
        refreshBottomNavigationItems()
    }

    private func animateKeyboardNotification(_ notification: NSNotification) {
        // Get animation curve and duration
        guard let parameters = keyboardParameters(from: notification) else { return }

        if parameters.endFrameY >= UIScreen.main.bounds.size.height {
            // Keyboard is hiding
            animateOffset(bottomConstraintInitialValue, duration: parameters.duration,
                          animationCurve: parameters.animationCurve)
        } else {
            // Keyboard is showing
            let offset = parameters.height - bottomConstraintInitialValue
            animateOffset(offset, duration: parameters.duration, animationCurve: parameters.animationCurve)
        }
    }

    private func animateOffset(_ offset: CGFloat, duration: TimeInterval, animationCurve: UIView.AnimationOptions) {
        bottomConstraint.constant = offset
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}
