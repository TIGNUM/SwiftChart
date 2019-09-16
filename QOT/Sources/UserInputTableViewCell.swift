//
//  UserInputTableViewCell.swift
//  QOT
//
//  Created by karmic on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol UserInputTableViewCellProtocol: class {
    func didUpdateUserInput(_ text: String)
}

final class UserInputTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var maxCharactersLabel: UILabel!
    private weak var delegate: UserInputTableViewCellProtocol?
    private var inputText: String?
    private var maxCharacters = 100
//    public var shouldEndEditing = false

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(inputText: String?, maxCharacters: Int, delegate: UserInputTableViewCellProtocol?) {
        self.maxCharacters = maxCharacters
        self.inputText = inputText
        self.delegate = delegate

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
        delegate?.didUpdateUserInput(textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdateUserInput(textView.text)
    }
}
