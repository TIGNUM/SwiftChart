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
    private var max = 0
    private var subHeader = ""
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
    func updateTextCounter(_ newValue: String) {
        textCounterLabel.text = newValue
    }

    func updateKeyboardInputView(_ isEnabled: Bool) {
        keyboardInputView.updateRightButton(isEnabled)
    }

    func hideOutlets(_ type: TeamEdit.View) {
        tableView.isHidden = type != .memberInvite
        memberMaxLabel.isHidden = type != .memberInvite
        memberCounterLabel.isHidden = type != .memberInvite
        teamTextField.autocapitalizationType = type == .create ? .sentences : .none
    }

    func setCellBackgroundTheme(cell: UITableViewCell) {
        NewThemeView.dark.apply(cell.contentView)
        NewThemeView.dark.apply(cell)
    }
}

// MARK: - TeamEditViewControllerInterface
extension TeamEditViewController: TeamEditViewControllerInterface {
    func setupView(_ type: TeamEdit.View, _ teamName: String?) {
        NewThemeView.dark.apply(view)
        NewThemeView.dark.apply(teamTextField)
        teamTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        teamTextField.corner(radius: Layout.CornerRadius.nine.rawValue, borderColor: .sand40)
        teamTextField.inputAccessoryView = keyboardInputView
        teamTextField.keyboardType = type == .memberInvite ? .emailAddress : .default
        keyboardInputView.delegate = self
        keyboardInputView.leftButton.setImage(type == .memberInvite ? nil : R.image.close(), for: .normal)
        hideOutlets(type)
        textCounterLabel.isHidden = type == .memberInvite
        textMaxCharsLabel.isHidden = type == .memberInvite
    }

    func updateTextCounter(type: TeamEdit.View, max: Int, teamName: String?) {
        self.max = max
        memberMaxLabel.text = "/\(max)"
        textMaxCharsLabel.text = "/\(max)"
        textCounterLabel.isHidden = type == .memberInvite
        textMaxCharsLabel.isHidden = type == .memberInvite
        teamTextField.text = teamName
    }

    func setupLabels(header: String,
                     subHeader: String,
                     description: String,
                     cta: String,
                     leftButton: String,
                     animated: Bool) {
        self.subHeader = subHeader
        if animated {
            UIView.animate(withDuration: Animation.duration_04) {
                self.keyboardInputView.rightButton.setTitle(cta, for: .normal)
                self.keyboardInputView.leftButton.setTitle(leftButton, for: .normal)
                self.headerLabel.text = header
                self.titleLabel.text = description
            }
        } else {
            keyboardInputView.rightButton.setTitle(cta, for: .normal)
            keyboardInputView.leftButton.setTitle(leftButton, for: .normal)
            keyboardInputView.leftButton.sizeToFit()
            headerLabel.text = header
            titleLabel.text = description
        }
    }

    func refreshView(_ type: TeamEdit.View) {
        teamTextField.resignFirstResponder()
        teamTextField.text = nil
        teamTextField.keyboardType = type == .memberInvite ? .emailAddress : .default
        hideOutlets(interactor.getType)
        updateKeyboardInputView(false)
        keyboardInputView.leftButton.setImage(type == .memberInvite ? nil : R.image.close(), for: .normal)
        teamTextField.becomeFirstResponder()
    }

    func refreshMemberList(at indexPath: [IndexPath]) {
        let memberCount = interactor.rowCount(in: TeamEdit.Section.members.rawValue)
        teamTextField.text = nil
        updateKeyboardInputView(false)
        memberCounterLabel.text = String(memberCount)

        if memberCount > .zero && !indexPath.isEmpty {
            tableView.performBatchUpdates({
                self.tableView.insertRows(at: indexPath, with: .automatic)
            }, completion: { _ in
                if let at = indexPath.first {
                    self.tableView.scrollToRow(at: at, at: .bottom, animated: true)
                }
            })

            if interactor.canSendInvite == false {
                view.endEditing(true)
            }
        } else {
            tableView.reloadData()
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
        if interactor.getType == .memberInvite {
            return true
        }
        let currentString = textField.text! as NSString
        return currentString.replacingCharacters(in: range, with: string).count <= max
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        switch interactor.getType {
        case .create:
            updateKeyboardInputView(textField.text?.isEmpty == false)
            updateTextCounter(String(textField.text?.count ?? .zero))
        case .memberInvite:
            updateKeyboardInputView(textField.text?.isEmail == true)
        case .edit:
            updateKeyboardInputView(textField.text?.isEmpty == false)
            updateTextCounter(String(textField.text?.count ?? .zero))
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TeamEditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TeamEdit.Section.allCases[indexPath.section] {
        case .info:
            let identifier = R.reuseIdentifier.teamMemberEmailHeaderTableViewCell_ID.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.textLabel?.text = subHeader
            cell.setThemeBackgroundDark()
            return cell
        case .members:
            let identifier = R.reuseIdentifier.teamMemberEmailTableViewCell_ID.identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
            cell.textLabel?.text = interactor.item(at: indexPath)
            cell.setThemeBackgroundDark()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - KeyboardInputViewProtocol
extension TeamEditViewController: KeyboardInputViewProtocol {
    func didTapLeftButton() {
        teamTextField.resignFirstResponder()
        dismiss()
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
    override func keyboardWillAppear(_ notification: Notification) {
        animateKeyboardNotification(notification)
    }

    override func keyboardWillDisappear(_ notification: Notification) {
        animateKeyboardNotification(notification)
        refreshBottomNavigationItems()
    }

    private func animateKeyboardNotification(_ notification: Notification) {
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
