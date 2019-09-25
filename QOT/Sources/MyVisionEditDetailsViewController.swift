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

    var originalVisionTitle = ""
    var originalVisionSubtitle = ""
    var didChangeVision: Bool = false
    var didChangeTitle: Bool = false

    var interactor: MyVisionEditDetailsInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    private func dismissController() {
        dismiss(animated: true, completion: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
    }

    @objc private func handleKeyboard(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        let height = isKeyboardShowing ? keyboardFrame.height : Layout.padding_100
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        UIView.animate(withDuration: Animation.duration_06, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension MyVisionEditDetailsViewController: MyVisionEditDetailsControllerInterface {

    func setupView(title: String, vision: String) {
        guard let interactor = self.interactor else {
            return
        }
        enableSaveButton(!interactor.isFromNullState)
        originalVisionTitle = title
        originalVisionSubtitle = vision
        view.backgroundColor = .carbon
        titleTextView.returnKeyType = .next
        didChangeTitle = !title.isEmpty
        didChangeVision = !vision.isEmpty
        titleTextField.attributedText = title.isEmpty ? interactor.formatPlaceholder(title: "TITLE") : interactor.formatPlaceholder(title: "")
        titleTextView.attributedText = interactor.format(title: title)
        visionTextField.attributedText = vision.isEmpty ? interactor.formatPlaceholder(vision: "Write your to be vision...") : interactor.formatPlaceholder(vision: "")
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
            let currentText = textView.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let changedText = currentText.replacingCharacters(in: stringRange, with: text)
            if textView == titleTextView {
                didChangeTitle = !changedText.isEmpty
                enableSaveButton(didChangeTitle && didChangeVision)
                titleTextField.attributedText = changedText.isEmpty ? interactor?.formatPlaceholder(title: "TITLE") : interactor?.formatPlaceholder(title: "")
            } else {
                didChangeVision = !changedText.isEmpty
                enableSaveButton(didChangeTitle && didChangeVision)
                visionTextField.attributedText = changedText.isEmpty ? interactor?.formatPlaceholder(vision: "Write your to be vision...") : interactor?.formatPlaceholder(vision: "")
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
        guard let toBeVision = interactor?.myVision else {
            qot_dal.UserService.main.generateToBeVisionWith([], []) { [weak self] (vision, error) in
                guard let newVision = vision, let finalVision = self?.getVision(for: newVision) else { return }
                self?.interactor?.updateMyToBeVision(finalVision, {[weak self] (error) in
                    self?.dismissController()
                })
            }
            return
        }
        let myVision = getVision(for: toBeVision)
        interactor?.updateMyToBeVision(myVision, {[weak self] (error) in
            self?.dismissController()
        })
    }

    private func getVision(for toBeVision: QDMToBeVision) -> QDMToBeVision {
        var myVision = toBeVision
        guard let interactor = self.interactor else {
            return myVision
        }
        if titleTextView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            myVision.headline = interactor.visionPlaceholderTitle
        } else {
            myVision.headline = titleTextView.text
        }

        myVision.text = descriptionTextView.text

        myVision.modifiedAt = Date()
        return myVision
    }
}
