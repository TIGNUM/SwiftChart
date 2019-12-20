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
}

class MyQOTAdminEditSprintsDetailsTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextField: UITextField!
    private var sprintEditObject: SprintEditObject?
    weak var delegate: MyQOTAdminEditSprintsDetailsTableViewCellDelegate?
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        detailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }

    // MARK: Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch sprintEditObject?.type {
        case .Int:
            sprintEditObject?.value = Int(detailTextField.text ?? "") ?? 0
        case .Date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            sprintEditObject?.value = dateFormatter.date(from: detailTextField.text ?? "") ?? Date()
        case .String:
            sprintEditObject?.value = detailTextField.text ?? ""
        case .Bool:
            sprintEditObject?.value = detailTextField.text == "true"
        default:
            break
        }
        delegate?.didChangeProperty(sprintEditObject)
    }

    // MARK: Public
    func configure(_ sprintEditObject: SprintEditObject) {
        titleLabel.text = sprintEditObject.property.rawValue
        detailTextField.text = "\(sprintEditObject.value)"
        self.sprintEditObject = sprintEditObject
    }
}
