//
//  MyQOTAdminEditSprintsDetailsTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyQOTAdminEditSprintsDetailsTableViewCellDelegate: class {
    func didChangeProperty(_ property: SprintEditObject?)
    func didBegiEditing(cell: MyQOTAdminEditSprintsDetailsTableViewCell, _ property: SprintEditObject?)
}

class MyQOTAdminEditSprintsDetailsTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var boolValueSwitch: UISwitch!

    private var sprintEditObject: SprintEditObject?
    weak var delegate: MyQOTAdminEditSprintsDetailsTableViewCellDelegate?
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        detailTextField.delegate = self
        detailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        boolValueSwitch.addTarget(self, action: #selector(didChangeSwitchValue(_:)), for: UIControl.Event.valueChanged)
    }

    // MARK: Actions
    @objc func didChangeSwitchValue(_ sender: UISwitch) {
        sprintEditObject?.value = sender.isOn
        delegate?.didChangeProperty(sprintEditObject)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        switch sprintEditObject?.type {
        case .Int:
            sprintEditObject?.value = Int(detailTextField.text ?? "") ?? 0
        case .String:
            sprintEditObject?.value = detailTextField.text ?? ""
        default:
            break
        }
        delegate?.didChangeProperty(sprintEditObject)
    }

    // MARK: Public
    func configure(_ sprintEditObject: SprintEditObject) {
        titleLabel.text = sprintEditObject.property.rawValue
        self.sprintEditObject = sprintEditObject
        self.boolValueSwitch.isHidden = true
        self.detailTextField.isHidden = false
        switch self.sprintEditObject?.type {
        case .Int, .String:
            detailTextField.text = "\(sprintEditObject.value)"
        case .Date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            guard let date = sprintEditObject.value as? Date else { return }
            let displayDate = dateFormatter.string(from: date)
            detailTextField.text = displayDate
        case .Bool:
            guard let isSelected =  sprintEditObject.value as? Bool else { return }
            self.boolValueSwitch.isHidden = false
            self.detailTextField.isHidden = true
            boolValueSwitch.isOn = isSelected
        default:
            break
        }
    }
}

extension MyQOTAdminEditSprintsDetailsTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBegiEditing(cell: self, sprintEditObject)
    }
}
