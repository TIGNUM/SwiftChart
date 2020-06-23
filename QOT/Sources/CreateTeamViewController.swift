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
    @IBOutlet private weak var keyboardInputView: KeyboardInputView!
    private var bottomConstraintInitialValue: CGFloat = 0
    private lazy var router: CreateTeamRouterInterface = CreateTeamRouter(viewController: self)
    var interactor: CreateTeamInteractorInterface!

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
        teamTextField.becomeFirstResponder()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - Private
private extension CreateTeamViewController {
    func updateTextCounter(_ newValue: String) {
        textCounterLabel.text = newValue
    }

    func updateKeyboardInputView(_ canCreate: Bool) {
        keyboardInputView.updateCreateButton(canCreate)
    }
}

// MARK: - Actions
private extension CreateTeamViewController {

}

// MARK: - CreateTeamViewControllerInterface
extension CreateTeamViewController: CreateTeamViewControllerInterface {
    func showErrorAlert(_ error: Error?) {
        handleError(error)
    }

    func presentInviteView() {
        router.presentInviteView()
    }

    func setupView() {
        teamTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        teamTextField.corner(radius: Layout.CornerRadius.nine.rawValue, borderColor: .sand40)
        teamTextField.inputAccessoryView = keyboardInputView
        keyboardInputView.delegate = self
    }

    func setupLabels(header: String?, description: String?, buttonTitle: String?) {
        keyboardInputView.createButton.setTitle(buttonTitle, for: .normal)
        titleLabel.text = description
        headerLabel.text = header
    }
}

// MARK: - UITextFieldDelegate
extension CreateTeamViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentString = textField.text! as NSString
        return currentString.replacingCharacters(in: range, with: string).count <= 20
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if let numberOfCharacters = textField.text?.count {
            updateKeyboardInputView(numberOfCharacters > 0)
            updateTextCounter(String(numberOfCharacters))
        }
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
            animateOffset(bottomConstraintInitialValue,
                          duration: parameters.duration,
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

// MARK: - KeyboardInputViewProtocol
extension CreateTeamViewController: KeyboardInputViewProtocol {
    func didCancel() {
        teamTextField.resignFirstResponder()
        router.dismiss()
    }

    func didCreateTeam() {
        if let name = teamTextField.text {
            interactor.createTeam(name)
        }
    }
}
