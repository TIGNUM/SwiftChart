//
//  MyToBeVisionEditDetailsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyVisionEditDetailsViewControllerProtocol: class {
    func didSave(_ saved: Bool)
}

final class MyVisionEditDetailsViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var visionTextField: UITextField!
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var keyboardInputView: MyVisionEditDetailsKeyboardInputView!

    var interactor: MyVisionEditDetailsInteractorInterface?
    weak var delegate: MyVisionEditDetailsViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
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
        view.backgroundColor = .carbon
        titleTextView.returnKeyType = .next
        titleTextField.attributedText = title.isEmpty ? interactor?.formatPlaceholder(title: "TITLE") : interactor?.formatPlaceholder(title: "")
        titleTextView.attributedText = interactor?.format(title: title)
        visionTextField.attributedText = vision.isEmpty ? interactor?.formatPlaceholder(vision: "Write your to be vision...") : interactor?.formatPlaceholder(vision: "")
        descriptionTextView.attributedText = interactor?.format(vision: vision)
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
                titleTextField.attributedText = changedText.isEmpty ? interactor?.formatPlaceholder(title: "TITLE") : interactor?.formatPlaceholder(title: "")
            } else {
                visionTextField.attributedText = changedText.isEmpty ? interactor?.formatPlaceholder(vision: "Write your to be vision...") : interactor?.formatPlaceholder(vision: "")
            }
        }
        return true
    }
}

extension MyVisionEditDetailsViewController: MyVisionEditDetailsKeyboardInputViewProtocol {

    func didCancel() {
        var hasSaved = false
        if interactor?.firstTimeUser ?? false {
            didSave()
            hasSaved = true
        }
        delegate?.didSave(hasSaved)
        dismissController()
    }

    func didSave() {
        guard var toBeVision = interactor?.myVision else { return }
        if toBeVision.text != descriptionTextView.text {
            toBeVision.text = descriptionTextView.text
        }
        if toBeVision.headline != titleTextView.text {
            toBeVision.headline = titleTextView.text
        }
        toBeVision.modifiedAt = Date()
        interactor?.updateMyToBeVision(toBeVision, {[weak self] (error) in
            self?.delegate?.didSave(true)
            self?.dismissController()
        })
    }
}
