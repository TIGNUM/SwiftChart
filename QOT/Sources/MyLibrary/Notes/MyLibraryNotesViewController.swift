//
//  MyLibraryNotesViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryNotesViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: MyLibraryNotesInteractorInterface?
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    private var saveButton: RoundedButton?
    private var initialBottomOffset: CGFloat = 0

    lazy var deleteButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapDeleteButton))
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.setImage(R.image.ic_delete(), for: .normal)
        ThemeTint.white.apply(button.imageView ?? UIImageView.init())
        ThemableButton.darkButton.apply(button, title: nil)
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
        } else if interactor?.isMyNote == false {
            textView.isUserInteractionEnabled = false
        } else {
            textView.isUserInteractionEnabled = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NewThemeView.dark.apply(view)
        interactor?.viewDidLoad()
        textViewBottomConstraint.constant = BottomNavigationContainer.height
        initialBottomOffset = textViewBottomConstraint.constant
        startObservingKeyboard()
        ThemeTint.white.apply(textView)
        textView.inputAccessoryView = keyboardToolbar()
        updateTextViewText()
    }

    @objc override func trackPage() {
        var pageTrack = QDMPageTracking()
        pageTrack.pageId = .zero
        pageTrack.pageKey = pageKey
        if let teamId = interactor?.teamId {
            pageTrack.associatedValueId = teamId
            pageTrack.associatedValueType = .TEAM
        }
        NotificationCenter.default.post(name: .reportPageTracking, object: pageTrack)
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return (interactor?.showDeleteButton ?? false) ? [deleteButton] : []
    }
}

// MARK: - Private
private extension MyLibraryNotesViewController {
    private func keyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: .zero, y: .zero, width: 100, height: 80))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)

        let dismissButton = dismissNavigationItem()
        if let dismiss = dismissButton.customView as? UIButton {
            dismiss.removeTarget(nil, action: nil, for: .allEvents)
            dismiss.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
        }
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let save = RoundedButton(title: interactor?.saveTitle, target: self, action: #selector(didTapSaveButton))
        ThemeButton.carbonButton.apply(save)
        save.setTitle(interactor?.saveTitle)
        saveButton = save
        toolbar.items = [dismissButton, space, save.barButton]
        return toolbar
    }

    private func updateTextViewText() {
        let attributedText: NSAttributedString
        if let text = interactor?.noteText {
            attributedText = NSAttributedString(string: text,
                                                attributes: [.foregroundColor: UIColor.white,
                                                             .font: UIFont.sfProtextLight(ofSize: 16),
                                                             .kern: CharacterSpacing.kern05])
        } else {
            attributedText = NSAttributedString(string: interactor?.placeholderText ?? String.empty,
                                                attributes: [.foregroundColor: UIColor.lightGrey,
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
            textView.textColor = .white
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        interactor?.didUpdateText(textView.text)
        saveButton?.isEnabled = interactor?.isSaveButtonEnabled ?? false
    }
}

// Keyboard
extension MyLibraryNotesViewController {
    @objc override func keyboardWillAppear(_ notification: Notification) {
        let parameters = keyboardParameters(from: notification)
        animateTextView(height: parameters?.height ?? .zero)
    }

    @objc override func keyboardWillDisappear(_ notification: Notification) {
        animateTextView(height: initialBottomOffset)
    }

    func animateTextView(height: CGFloat) {
        textViewBottomConstraint.constant = height
    }
}
