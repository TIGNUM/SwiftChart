//
//  MySprintNotesViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintNotesViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MySprintNotesInteractorInterface?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var characterCountLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var textViewBottomConstraint: NSLayoutConstraint!
    private var infoAlertView: InfoAlertView?
    private var saveButton: RoundedButton?
    private var bottomNavigationItems = UINavigationItem()

    // MARK: - Init

    init(configure: Configurator<MySprintNotesViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
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

private extension MySprintNotesViewController {

    private func showDefaultBottomButtons() {
        bottomNavigationItems.leftBarButtonItems = [dismissNavigationItem()]
        bottomNavigationItems.rightBarButtonItems = []
        refreshBottomNavigationItems()
    }

    private func showBottomButtons(_ buttons: [ButtonParameters]) {
        bottomNavigationItems.leftBarButtonItems = nil
        bottomNavigationItems.rightBarButtonItems = buttons.map {
            let button = RoundedButton.barButton(title: $0.title, target: $0.target, action: $0.action)
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

    private func updateInfoViewWithViewModel(_ model: MySprintsInfoAlertViewModel?) {
        guard let model = model else {
            infoAlertView?.dismiss()
            infoAlertView = nil
            return
        }

        infoAlertView = InfoAlertView()
        infoAlertView?.set(icon: model.icon, title: model.title, attributedText: model.message)
        infoAlertView?.present(on: self.view)
        infoAlertView?.bottomInset = BottomNavigationContainer.height
        infoAlertView?.setBackgroundColor(self.view.backgroundColor)
    }

    private func updateTextViewText() {
        textView.attributedText = NSAttributedString(string: interactor?.noteText ?? "",
                                                     attributes: [.foregroundColor: UIColor.sand,
                                                                  .font: UIFont.sfProtextLight(ofSize: 16),
                                                                  .kern: CharacterSpacing.kern05])
    }
}

// MARK: - Actions

private extension MySprintNotesViewController {

    // Superclass already has a `didTapDismissButton` method
    @objc func didTapDismiss() {
        textView.resignFirstResponder()
        interactor?.didTapDismiss(with: textView.text)
    }

    @objc private func didTapSaveButton() {
        textView.resignFirstResponder()
        interactor?.saveNoteText(textView.text)
    }
}

// MARK: - MySprintNotesViewControllerInterface

extension MySprintNotesViewController: MySprintNotesViewControllerInterface {

    func update() {
        titleLabel.attributedText = NSAttributedString(string: interactor?.title ?? "",
                                                       attributes: [.kern: CharacterSpacing.kern02])
        characterCountLabel.text = interactor?.characterCountText ?? ""
        updateTextViewText()

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

extension MySprintNotesViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return interactor?.shouldChangeText(textView.text, shouldChangeTextIn: range, replacementText: text) ?? false
    }

    func textViewDidChange(_ textView: UITextView) {
        interactor?.didUpdateText(textView.text)
        characterCountLabel.text = interactor?.characterCountText ?? ""
    }
}
