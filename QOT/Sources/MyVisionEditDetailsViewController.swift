//
//  MyToBeVisionEditDetailsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyVisionEditDetailsViewController: BaseViewController, ScreenZLevelOverlay {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var visionTextField: UITextField!
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var keyboardInputView: MyVisionEditDetailsKeyboardInputView!

    var originalVisionTitle = String.empty
    var originalVisionSubtitle = String.empty
    var didChangeVision: Bool = false
    var didChangeTitle: Bool = false

    var interactor: MyVisionEditDetailsInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func addKeyboardObservers() {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.handleKeyboard(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.handleKeyboard(notification)
        }
    }

    @objc private func handleKeyboard(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        let height = isKeyboardShowing ? keyboardFrame.height : Layout.padding_100
        scrollView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: height, right: .zero)
        UIView.animate(withDuration: Animation.duration_06, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

extension MyVisionEditDetailsViewController: MyVisionEditDetailsControllerInterface {

    func setupView(title: String, vision: String) {
        guard let interactor = self.interactor else {
            return
        }
        NewThemeView.dark.apply(view)
        NewThemeView.dark.apply(scrollView)
        NewThemeView.dark.apply(titleTextField)
        NewThemeView.dark.apply(descriptionTextView)
        NewThemeView.dark.apply(titleTextView)
        NewThemeView.dark.apply(visionTextField)

        enableSaveButton(!interactor.isFromNullState)
        originalVisionTitle = title
        originalVisionSubtitle = vision
        NewThemeView.dark.apply(view)
        titleTextView.returnKeyType = .next
        didChangeTitle = !title.isEmpty
        didChangeVision = !vision.isEmpty
        titleTextField.attributedText = title.isEmpty ? interactor.formatPlaceholder(title: AppTextService.get(.my_qot_my_tbv_edit_title_placeholder)) :
                                                        interactor.formatPlaceholder(title: String.empty)
        titleTextView.attributedText = interactor.format(title: title)
        visionTextField.attributedText = vision.isEmpty ? interactor.formatPlaceholder(vision: AppTextService.get(.my_qot_my_tbv_edit_body_placeholder)) :
                                                          interactor.formatPlaceholder(vision: String.empty)
        descriptionTextView.attributedText = interactor.format(vision: vision)
        titleTextView.becomeFirstResponder()
        keyboardInputView.delegate = self
        addKeyboardObservers()
        titleTextView.inputAccessoryView = keyboardInputView
        descriptionTextView.inputAccessoryView = keyboardInputView
    }
}

extension MyVisionEditDetailsViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titleTextView.attributedText = interactor?.format(title: textView.text)
        } else if textView == descriptionTextView {
            descriptionTextView.attributedText = interactor?.format(vision: textView.text)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == titleTextView && text == "\n" {
            titleTextView.resignFirstResponder()
            descriptionTextView.becomeFirstResponder()
        } else {
            let currentText = textView.text ?? String.empty
            guard let stringRange = Range(range, in: currentText) else { return false }
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            if textView == titleTextView {
                didChangeTitle = !changedText.isEmpty
                enableSaveButton(didChangeTitle && didChangeVision)
                titleTextField.attributedText = changedText.isEmpty ?
                                                interactor?.formatPlaceholder(title: AppTextService.get(.my_qot_my_tbv_edit_title_placeholder)) :
                                                interactor?.formatPlaceholder(title: String.empty)
            } else {
                didChangeVision = !changedText.isEmpty
                enableSaveButton(didChangeTitle && didChangeVision)
                visionTextField.attributedText = changedText.isEmpty ?
                                                 interactor?.formatPlaceholder(vision: AppTextService.get(.my_qot_my_tbv_edit_body_placeholder)) :
                                                 interactor?.formatPlaceholder(vision: String.empty)
            }
        }
        return true
    }

    private func enableSaveButton(_ isEnabled: Bool) {
        guard let interactor = self.interactor else { return }
        var isButtonEnabled = isEnabled
        if !interactor.isFromNullState && !isEnabled {
            isButtonEnabled = true
        }
        keyboardInputView.saveButton.isEnabled = isButtonEnabled
        keyboardInputView.saveButton.corner(radius: 20, borderColor: isButtonEnabled ? .white : .clear)
        keyboardInputView.saveButton.alpha = isButtonEnabled ? 1.0 : 0.5
    }
}

extension MyVisionEditDetailsViewController: MyVisionEditDetailsKeyboardInputViewProtocol {

    func didCancel() {
        view.endEditing(true)
        trackUserEvent(.CANCEL, valueType: "EditMyToBeVision", action: .TAP)
        dismissController()
    }

    func didSave() {
        view.endEditing(true)
        trackUserEvent(.CONFIRM, valueType: "EditMyToBeVision", action: .TAP)
        guard let team = interactor?.team else {
            guard let toBeVision = interactor?.myVision else {
                UserService.main.generateToBeVisionWith([], []) { [weak self] (vision, _) in
                    guard let newVision = vision, let finalVision = self?.getVision(for: newVision) else { return }
                    self?.interactor?.updateMyToBeVision(finalVision, {[weak self] (_) in
                        self?.dismissController()
                    })
                }
                return
            }
            let myVision = getVision(for: toBeVision)
            interactor?.updateMyToBeVision(myVision, {[weak self] (_) in
                self?.dismissController()
            })

            return
        }
        guard !descriptionTextView.text.isEmpty, let teamVision = interactor?.teamVision else {
            TeamService.main.createTeamToBeVision(headline: String.empty,
                                                  subHeadline: String.empty,
                                                  text: String.empty,
                                                  for: team, { [weak self] (teamVision, _, _) in
                                                    guard let newTeamVision = teamVision,
                                                          let finalTeamVision = self?.getTeamVision(for: newTeamVision) else {
                                                        return
                                                    }
                                                    self?.interactor?.updateTeamToBeVision(finalTeamVision, { [weak self] (_) in
                                                        self?.dismissController()
                                                    })
            })
            return
        }
        let teamToBeVision = getTeamVision(for: teamVision)
        interactor?.updateTeamToBeVision(teamToBeVision, {[weak self] (_) in
            self?.dismissController()
        })
    }

    private func getVision(for toBeVision: QDMToBeVision) -> QDMToBeVision {
        var myVision = toBeVision
        myVision.headline = titleTextView.text.trimmingCharacters(in: .whitespaces)
        myVision.text = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        myVision.modifiedAt = Date()
        return myVision
    }

    private func getTeamVision(for teamToBeVision: QDMTeamToBeVision) -> QDMTeamToBeVision {
        var teamVision = teamToBeVision
        teamVision.headline = titleTextView.text.trimmingCharacters(in: .whitespaces)
        teamVision.text = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        teamVision.modifiedAt = Date()
        return teamVision
    }
}
