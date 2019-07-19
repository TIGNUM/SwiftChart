//
//  UserInputTableViewCell.swift
//  QOT
//
//  Created by karmic on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class UserInputTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var maxCharactersLabel: UILabel!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var continueBbutton: UIButton!
    private weak var delegate: DecisionTreeQuestionnaireDelegate?
    private var inputText: String?
    private var maxCharacters = 100

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        continueBbutton.cornerDefault()
        showKeyBoard()
    }

    func configure(inputText: String?, maxCharacters: Int, delegate: DecisionTreeQuestionnaireDelegate?) {
        self.maxCharacters = maxCharacters
        self.inputText = inputText
        self.delegate = delegate
        maxCharactersLabel.text = String(format: "/%d", maxCharacters)
        if let inputText = inputText {
            textView.text = inputText
            counterLabel.text = String(format: "%d", textView.text.count)
        }
    }

    func showKeyBoard() {
        textView.becomeFirstResponder()
    }
}

// MARK: - Actions
extension UserInputTableViewCell {
    @IBAction func didTapDismiss() {
        delegate?.didPressDimiss()
    }

    @IBAction func didTapContinue() {
        delegate?.didPressContinue()
        delegate?.didUpdateUserInput(textView.text)
    }
}

// MARK: - UITextViewDelegate
extension UserInputTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= maxCharacters
    }

    func textViewDidChange(_ textView: UITextView) {
        counterLabel.text = String(format: "%d", textView.text.count)
        delegate?.didUpdateUserInput(textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdateUserInput(textView.text)
    }
}
