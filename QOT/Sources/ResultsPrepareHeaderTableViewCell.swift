//
//  ResultsPrepareHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 12.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ResultsPrepareHeaderTableViewCell: UITableViewCell, Dequeueable, UITextFieldDelegate {

    @IBOutlet weak var textfield: UITextField!
    weak var delegate: ResultsPrepareViewControllerDelegate?
    @IBOutlet weak var editButton: UIButton!

    func configure(title: String, hideEdit: Bool) {
        ThemeText.H01Light.apply(title, to: textfield)
        textfield.isUserInteractionEnabled = false
        editButton.isEnabled = true
        textfield.borderStyle = .none
        textfield.delegate = self
        editButton.isHidden = hideEdit
    }

    @IBAction func editButton(_ sender: Any) {
        textfield.isUserInteractionEnabled = true
        textfield.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField {
            textfield.resignFirstResponder()
            didUpdateTitle(title: textfield.text ?? "nothing")
            editButton.isEnabled = true
        }
        return false
    }

    func didUpdateTitle(title: String) {
        delegate?.didUpdateTitle(newTitle: title)
    }
}
