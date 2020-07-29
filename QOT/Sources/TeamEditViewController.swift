//
//  TeamEditViewController.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var subHeaderLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textCounterLabel: UILabel!
    @IBOutlet private weak var textMaxCharsLabel: UILabel!
    @IBOutlet private weak var textContainerView: UIView!
    @IBOutlet private weak var teamTextField: UITextField!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var keyboardInputView: KeyboardInputView!
    @IBOutlet private weak var memberCounterLabel: UILabel!
    @IBOutlet private weak var memberMaxLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private var bottomConstraintInitialValue: CGFloat = 0
    private var maxChars: Int?
    private lazy var router: TeamEditRouterInterface = TeamEditRouter(viewController: self)
    var interactor: TeamEditInteractorInterface!

    // MARK: - Init
    init(configure: Configurator<TeamEditViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        startObservingKeyboard()
        teamTextField.becomeFirstResponder()
        trackPage()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}

// MARK: - Private
private extension TeamEditViewController {
    var isMemberInvite: Bool {
        return TeamEdit.View.memberInvite == interactor.getType
    }

    func updateTextCounter(_ newValue: String) {
        textCounterLabel.text = newValue
    }

    func updateKeyboardInputView(_ isEnabled: Bool) {
        keyboardInputView.updateRightButton(isEnabled)
    }

    func hideOutlets(_ viewType: TeamEdit.View) {
        tableView.isHidden = viewType != .memberInvite
        memberMaxLabel.isHidden = viewType != .memberInvite
        memberCounterLabel.isHidden = viewType != .memberInvite
    }

    func updateMemberCounter() {
        memberCounterLabel.text = String(interactor.rowCount)
    }
}

// MARK: - TeamEditViewControllerInterface
extension TeamEditViewController: TeamEditViewControllerInterface {
    func setupView() {
        teamTextField.text = isMemberInvite ? "" : interactor.teamName
        teamTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        teamTextField.corner(radius: Layout.CornerRadius.nine.rawValue, borderColor: .sand40)
        teamTextField.inputAccessoryView = keyboardInputView
        teamTextField.keyboardType = interactor.getType == TeamEdit.View.memberInvite ? .emailAddress : .default
        keyboardInputView.delegate = self
        hideOutlets(interactor.getType)
        textCounterLabel.isHidden = isMemberInvite
        textMaxCharsLabel.isHidden = isMemberInvite
    }

    func updateTextCounter(maxChars: Int?) {
        self.maxChars = maxChars
        if let maxChars = maxChars {
            self.memberMaxLabel.text = "/\(maxChars)"
            self.textMaxCharsLabel.text = "/\(maxChars)"
        } else {
            textCounterLabel.isHidden = true
            textMaxCharsLabel.isHidden = true
        }
        textCounterLabel.isHidden = isMemberInvite
        textMaxCharsLabel.isHidden = isMemberInvite
    }

    func setupLabels(header: String, subHeader: String, description: String, cta: String, animated: Bool) {
        UIView.animate(withDuration: animated ? Animation.duration_06 : 0) { [weak self] in
            self?.keyboardInputView.rightButton.setTitle(cta, for: .normal)
            self?.headerLabel.text = header
            self?.subHeaderLabel.text = String(format: subHeader, self?.interactor.teamName ?? "")
            self?.titleLabel.text = description
        }
    }

    func refreshView() {
        teamTextField.text = nil
        teamTextField.keyboardType = interactor.getType == TeamEdit.View.memberInvite ? .emailAddress : .default
        hideOutlets(interactor.getType)
        updateKeyboardInputView(false)
    }

    func refreshMemberList(at indexPath: [IndexPath]) {
        teamTextField.text = nil
        updateKeyboardInputView(false)
        subHeaderLabel.isHidden = interactor.rowCount > 0
        updateMemberCounter()

        tableView.beginUpdates()
        tableView.insertRows(at: indexPath, with: .automatic)
        tableView.endUpdates()

        if let at = indexPath.first {
            tableView.scrollToRow(at: at, at: .bottom, animated: true)
        }

        if interactor.canSendInvite == false {
            view.endEditing(true)
        }
    }

    func presentErrorAlert(_ title: String, _ message: String) {
        let OK = QOTAlertAction(title: AppTextService.get(.generic_view_button_done))
        QOTAlert.show(title: title, message: message, bottomItems: [OK])
    }

    func dismiss() {
        router.dismiss()
    }
}

// MARK: - UITextFieldDelegate
extension TeamEditViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if isMemberInvite {
            return true
        } else {
            if let maxChars = maxChars {
                let currentString = textField.text! as NSString
                return currentString.replacingCharacters(in: range, with: string).count <= maxChars
            } else {
                return true
            }
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        switch interactor.getType {
        case .create:
            updateKeyboardInputView(textField.text?.isEmpty == false)
            updateTextCounter(String(textField.text?.count ?? 0))
        case .memberInvite:
            updateKeyboardInputView(textField.text?.isEmail == true)
        case .edit:
            updateKeyboardInputView(textField.text?.isEmpty == false)
            updateTextCounter(String(textField.text?.count ?? 0))
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let email = interactor.item(at: indexPath)
        let identifier = R.reuseIdentifier.teamMemberEmailTableViewCell_ID.identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = email ?? ""
        return cell
    }
}

// MARK: - KeyboardInputViewProtocol
extension TeamEditViewController: KeyboardInputViewProtocol {
    func didTapLeftButton() {
        teamTextField.resignFirstResponder()
        router.dismiss()
    }

    func didTapRightButton() {
        switch interactor.getType {
        case .create:
            interactor.createTeam(teamTextField.text)
        case .memberInvite:
            interactor.sendInvite(teamTextField.text)
        case .edit:
            interactor.updateTeamName(teamTextField.text)
            dismiss()
        }
    }
}

// MARK: - Keyboard
extension TeamEditViewController {
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
