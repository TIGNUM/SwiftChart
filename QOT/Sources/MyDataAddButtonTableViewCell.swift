//
//  MyDataAddButtonTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataAddButtonTableViewCellDelegate: class {
    func didTapAddButton()
}

class MyDataAddButtonTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MyDataAddButtonTableViewCellDelegate?

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        addButton.layer.cornerRadius = 20.0
        addButton.layer.borderWidth = 1.0
        addButton.layer.borderColor = UIColor.accent40.cgColor
    }

    // MARK: Actions

    @IBAction func didTapAddButton(_ sender: Any) {
        delegate?.didTapAddButton()
    }
}
