//
//  MyQOTAdminEditSprintsDetailsTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyQOTAdminEditSprintsDetailsTableViewCellDelegate: class {
    func textFieldDidEndEditing(withText: String?)
}

class MyQOTAdminEditSprintsDetailsTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    weak var delegate: MyQOTAdminEditSprintsDetailsTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailTextField.delegate = self
    }

    func configure(title: String, subTitle: String) {
        titleLabel.text = title
        detailTextField.text = subTitle
    }
}

extension MyQOTAdminEditSprintsDetailsTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(withText: textField.text)
    }
}
