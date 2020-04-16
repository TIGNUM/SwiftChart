//
//  ResultsPrepareHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareHeaderTableViewCell: UITableViewCell, Dequeueable, UITextViewDelegate {

    @IBOutlet private weak var textView: UITextView!
    weak var delegate: ResultsPrepareViewControllerDelegate?
    @IBOutlet private weak var editButton: UIButton!

    func configure(title: String, hideEdit: Bool) {
        ThemeText.H01Light.apply(title, to: textView)
        textView.centerVertically()
        textView.isUserInteractionEnabled = false
        textView.textContainer.maximumNumberOfLines = 2
        editButton.isEnabled = true
        textView.delegate = self
        editButton.isHidden = hideEdit
    }

    @IBAction func editButton(_ sender: Any) {
        textView.isUserInteractionEnabled = true
        textView.becomeFirstResponder()
    }

    private func textViewdDidBeginEditing(_ textField: UITextField) {
        ThemeText.H01Light.apply(textView.text?.uppercased(), to: textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            didUpdateTitle(title: textView.text ?? "")
            editButton.isEnabled = true
            return false
        }
        return textView.text.count + (text.count - range.length) <= 42
    }

    func didUpdateTitle(title: String) {
        delegate?.didUpdateTitle(newTitle: title)
        textView.centerVertically()
    }
}

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }
}

