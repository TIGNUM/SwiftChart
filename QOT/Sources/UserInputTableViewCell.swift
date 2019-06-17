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
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var continueBbutton: UIButton!
    private weak var delegate: DecisionTreeQuestionnaireDelegate?
    private var benefits: String?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        continueBbutton.corner(radius: 20)
        showKeyBoard()
    }

    func configure(benefits: String?, delegate: DecisionTreeQuestionnaireDelegate?) {
        self.benefits = benefits
        self.delegate = delegate
        if let benefits = benefits {
            textView.text = benefits
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
        delegate?.didUpdatePrepareBenefits(textView.text)
    }
}

// MARK: - UITextViewDelegate

extension UserInputTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 100
    }

    func textViewDidChange(_ textView: UITextView) {
        counterLabel.text = String(format: "%d", textView.text.count)
        delegate?.didUpdatePrepareBenefits(textView.text)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.didUpdatePrepareBenefits(textView.text)
    }
}
