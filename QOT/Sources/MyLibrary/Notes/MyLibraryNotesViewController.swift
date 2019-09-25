//
//  MyLibraryNotesViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryNotesViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyLibraryNotesInteractorInterface?
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    private var saveButton: RoundedButton?
    private var bottomNavigationItems = UINavigationItem()
    private var initialBottomOffset: CGFloat = 0

    lazy var deleteButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapDeleteButton))
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.setImage(R.image.my_library_delete(), for: .normal)
        ThemableButton.myLibraryNotes.apply(button, title: nil)
        return button.barButton
    }()

    // MARK: - Init

    init(configure: Configurator<MyLibraryNotesViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        if interactor?.isCreatingNewNote ?? true {
            beginEditing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        textViewBottomConstraint.constant = BottomNavigationContainer.height
        initialBottomOffset = textViewBottomConstraint.constant
        startObservingKeyboard()
        textView.tintColor = .sand
        textView.inputAccessoryView = keyboardToolbar()
        updateTextViewText()
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return (interactor?.showDeleteButton ?? false) ? [deleteButton] : []
    }
}

// MARK: - Private

private extension MyLibraryNotesViewController {

    private func keyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 80))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        let dismissButton = dismissNavigationItem()
        if let dismiss = dismissButton.customView as? UIButton {
            dismiss.removeTarget(nil, action: nil, for: .allEvents)
            dismiss.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        }
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let save = RoundedButton(title: interactor?.saveTitle, target: self, action: #selector(didTapSaveButton))
        ThemableButton.myLibraryNotes.apply(save, title: interactor?.saveTitle)
        saveButton = save
        toolbar.items = [dismissButton, space, save.barButton]
        return toolbar
    }

    private func updateTextViewText() {
        let attributedText: NSAttributedString
        if let text = interactor?.noteText {
            attributedText = NSAttributedString(string: text,
                                                attributes: [.foregroundColor: UIColor.sand,
                                                             .font: UIFont.sfProtextLight(ofSize: 16),
                                                             .kern: CharacterSpacing.kern05])
        } else {
            attributedText = NSAttributedString(string: interactor?.placeholderText ?? "",
                                                attributes: [.foregroundColor: UIColor.sand40,
                                                             .font: UIFont.sfProtextLight(ofSize: 16),
                                                             .kern: CharacterSpacing.kern05])
        }
        textView.attributedText = attributedText
    }
}

// MARK: - Actions

private extension MyLibraryNotesViewController {

    // Superclass already has a `didTapDismissButton` method
    @objc func didTapDismiss() {
        textView.resignFirstResponder()
        interactor?.didTapDismiss(with: textView.text)
    }

    @objc private func didTapSaveButton() {
        textView.resignFirstResponder()
        interactor?.saveNoteText(textView.text)
    }

    @objc private func didTapDeleteButton() {
        interactor?.didTapDelete()
    }
}

// MARK: - MyLibraryNotesViewControllerInterface

extension MyLibraryNotesViewController: MyLibraryNotesViewControllerInterface {

    func update() {
        updateTextViewText()
        saveButton?.isEnabled = interactor?.isSaveButtonEnabled ?? false
    }

    func beginEditing() {
        textView.becomeFirstResponder()
    }

    func showAlert(title: String?, message: String?, buttons: [UIBarButtonItem]) {
        QOTAlert.show(title: title, message: message, bottomItems: buttons)
    }
}

// MARK: - UITextViewDelegate

extension MyLibraryNotesViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        saveButton?.isEnabled = interactor?.isSaveButtonEnabled ?? false
        if textView.text == interactor?.placeholderText {
            textView.text = nil
            textView.textColor = .sand
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        interactor?.didUpdateText(textView.text)
        saveButton?.isEnabled = interactor?.isSaveButtonEnabled ?? false
    }
}

// Keyboard

extension MyLibraryNotesViewController {

    @objc override func keyboardWillAppear(notification: NSNotification) {
        let parameters = keyboardParameters(from: notification)
        animateTextView(height: parameters?.height ?? 0)
    }

    @objc override func keyboardWillDisappear(notification: NSNotification) {
        animateTextView(height: initialBottomOffset)
    }

    func animateTextView(height: CGFloat) {
        textViewBottomConstraint.constant = height
    }
}
