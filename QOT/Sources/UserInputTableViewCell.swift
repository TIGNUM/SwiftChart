//
//  UserInputTableViewCell.swift
//  QOT
//
//  Created by karmic on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol UserInputTableViewCellProtocol: class {
    func didUpdateUserInput(_ text: String, questionKey: String)
}

final class UserInputTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var maxCharactersLabel: UILabel!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    private weak var delegate: UserInputTableViewCellProtocol?
    private var inputText: String?
    private var maxCharacters = 100
    private var observers: [NSKeyValueObservation] = []
    private var questionKey: String = ""

    func configure(questionKey: String,
                   inputText: String?,
                   maxCharacters: Int,
                   delegate: UserInputTableViewCellProtocol?) {
        self.questionKey = questionKey
        self.maxCharacters = maxCharacters
        self.inputText = inputText
        self.delegate = delegate
        observers = [textView.observe(\.contentSize, options: [.new]) { [weak self] (_, _) in
            self?.refreshHeight()
            }
        ]

        ThemeText.resultCounterMax.apply(String(format: "/%d", maxCharacters), to: maxCharactersLabel)
        if let inputText = inputText {
            textView.text = inputText
            ThemeText.resultCounter.apply(String(format: "%d", textView.text.count), to: counterLabel)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showKeyBoard()
        }
    }

    private func showKeyBoard() {
        textView.becomeFirstResponder()
    }
}

// MARK: - Private
private extension UserInputTableViewCell {
    func refreshHeight() {
        constraintHeight.constant = textView.contentSize.height + 16
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate
extension UserInputTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxCharacters
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        counterLabel.text = String(format: "%d", textView.text.count)
        delegate?.didUpdateUserInput(textView.text, questionKey: questionKey)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdateUserInput(textView.text, questionKey: questionKey)
    }
}
