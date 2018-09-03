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
    private let keyboardListener = KeyboardListener()
	private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton(_:)))
    weak var delegate: PrepareContentNotesViewControllerDelegate?
    var notesType: PrepareContentReviewNotesTableViewCell.NotesType?
    var text: String?
    var placeholder: String?

     // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardListener.startObserving()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardListener.stopObserving()
        textView.resignFirstResponder()
		if notesType == .notes {
			text = textView.text
			delegate?.didEditText(text: text, in: self)
		}
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
		doneButton.tintColor = .gray
	}

    func textViewDidChange(_ textView: UITextView) {
        text = textView.text
        syncPlaceholder()
    }
}

private extension PrepareContentNotesViewController {

    static var textViewAttributes = NSAttributedString.makeAttributes(letterSpacing: 2,
                                                                      font: Font.PText,
                                                                      lineSpacing: 10,
                                                                      textColor: .nightModeBlack,
                                                                      alignment: .left,
                                                                      lineBreakMode: .byWordWrapping)

    func setup() {
		doneButton.tintColor = UIColor.gray.withAlphaComponent(0.5)
		navigationItem.rightBarButtonItem = doneButton
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
        placeholderTextView.attributedText = NSAttributedString(string: placeholder ?? R.string.localized.prepareNotesPlaceholder(),
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

	@objc func didTapDoneButton(_ sender: UIBarButtonItem) {
		delegate?.didEditText(text: text, in: self)
		if let previousVC = navigationController?.viewControllers.dropLast().last {
			navigationController?.popToViewController(previousVC, animated: true)
		}
	}
}
