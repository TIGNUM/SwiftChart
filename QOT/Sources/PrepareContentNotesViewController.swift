//
//  PrepareContentNoteViewController.swift
//  QOT
//
//  Created by karmic on 22.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentNotesViewControllerDelegate: class {

    func didEditText(text: String?, `in` viewController: PrepareContentNotesViewController)
}

final class PrepareContentNotesViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var placeholderTextView: UITextView!
    @IBOutlet private weak var textViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var cancelButtonItem: UIBarButtonItem!
    @IBOutlet private weak var saveButtonItem: UIBarButtonItem!
    private let keyboardListener = KeyboardListener()
    weak var delegate: PrepareContentNotesViewControllerDelegate?
    var notesType: PrepareNotesViewController.NotesType?
    var text: String?
    var placeholder: String?

     // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = notesType?.navBarTitle
        textView.becomeFirstResponder()
        keyboardListener.startObserving()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardListener.stopObserving()
        textView.resignFirstResponder()
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        syncLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        syncLayout()
    }
}

extension PrepareContentNotesViewController: UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
        saveButtonItem.tintColor = .gray
	}

    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
        syncPlaceholder()
    }
}

private extension PrepareContentNotesViewController {

    static var textViewAttributes = NSAttributedString.makeAttributes(letterSpacing: 2,
                                                                      font: .PText,
                                                                      lineSpacing: 10,
                                                                      textColor: .nightModeBlack,
                                                                      alignment: .left,
                                                                      lineBreakMode: .byWordWrapping)

    func setup() {
        saveButtonItem.tintColor = UIColor.gray.withAlphaComponent(0.5)
        cancelButtonItem.tintColor = .gray
        textView.backgroundColor = .clear
        placeholderTextView.backgroundColor = .clear
        view.backgroundColor = .nightModeBackground
        let textViewAttributes = PrepareContentNotesViewController.textViewAttributes
        var placeholderAttibutes = textViewAttributes
        placeholderAttibutes[.foregroundColor] = UIColor.nightModeBlack15
        automaticallyAdjustsScrollViewInsets = false
        textView.attributedText = NSAttributedString(string: text ?? "", attributes: textViewAttributes)
        textView.contentInset = .zero
        textView.textColor = .nightModeBlack
        placeholderTextView.attributedText = NSAttributedString(string: notesType?.placeholder ?? R.string.localized.prepareNotesPlaceholder(),
                                                                attributes: placeholderAttibutes)
        syncPlaceholder()
        syncLayout()
        keyboardListener.onStateChange { [weak self] (state) in
            self?.syncLayout()
        }
    }

    func syncPlaceholder() {
        placeholderTextView.isHidden = textView.hasText
    }

    func syncLayout() {
        let bottomeInset = max(safeAreaInsets.bottom, keyboardListener.state.height)
        textViewTopConstraint.constant = safeAreaInsets.top
        textView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: bottomeInset + 16, right: 0)
        placeholderTextView.contentInset = textView.contentInset
    }

    @IBAction func didTapSave() {
        delegate?.didEditText(text: text, in: self)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
}
