//
//  MyLibraryNotesViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryNotesViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyLibraryNotesInteractorInterface?

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var infoView: InfoHelperView!
    private var saveButton: RoundedButton?

    private var bottomNavigationItems = UINavigationItem()

    lazy var deleteButton: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(R.image.my_library_delete(), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        button.corner(radius: 20, borderColor: .accent40)
        return UIBarButtonItem(customView: button)
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        infoView.setBottomContentInset(BottomNavigationContainer.height)

        textView.tintColor = .sand
        textView.inputAccessoryView = keyboardToolbar()
        updateTextViewText()
        
        showDefaultBottomButtons()
    }

    override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.leftBarButtonItems
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.rightBarButtonItems
    }
}

// MARK: - Private

private extension MyLibraryNotesViewController {

    private func showDefaultBottomButtons() {
        bottomNavigationItems.leftBarButtonItems = [dismissNavigationItem()]
        bottomNavigationItems.rightBarButtonItems = (interactor?.showDeleteButton ?? false) ? [deleteButton] : []
        refreshBottomNavigationItems()
    }

    private func showBottomButtons(_ buttons: [ButtonParameters]) {
        bottomNavigationItems.leftBarButtonItems = nil
        bottomNavigationItems.rightBarButtonItems = buttons.map {
            let button = UIBarButtonItem(customView: RoundedButton(title: $0.title, target: $0.target, action: $0.action))
            button.isEnabled = $0.isEnabled
            return button
        }
        refreshBottomNavigationItems()
    }

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
        let save = RoundedButton(title: interactor?.saveTitle ?? "Save", target: self, action: #selector(didTapSaveButton))
        saveButton = save
        let saveBarButton = UIBarButtonItem(customView: save)
        
        toolbar.items = [dismissButton, space, saveBarButton]

        return toolbar
    }

    private func updateInfoViewWithViewModel(_ model: MyLibraryUserStorageInfoViewModel?) {
        guard let model = model else {
            infoView.isHidden = true
            return
        }
        
        infoView.isHidden = false
        infoView.set(icon: model.icon, title: model.title, attributedText: model.message)
    }

    private func updateTextViewText() {
        let attributedText: NSAttributedString
        if let text = interactor?.noteText {
            attributedText = NSAttributedString(string: text,
                                                attributes: [.foregroundColor: UIColor.sand,
                                                             .font: UIFont.sfProtextLight(ofSize: 16),
                                                             .kern: 0.5])
        } else {
            attributedText = NSAttributedString(string: interactor?.placeholderText ?? "",
                                                attributes: [.foregroundColor: UIColor.sand40,
                                                             .font: UIFont.sfProtextLight(ofSize: 16),
                                                             .kern: 0.5])
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

        updateInfoViewWithViewModel(interactor?.infoViewModel)

        if let bottomButtons = interactor?.bottomButtons {
            showBottomButtons(bottomButtons)
        } else {
            showDefaultBottomButtons()
        }
    }

    func beginEditing() {
        textView.becomeFirstResponder()
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
