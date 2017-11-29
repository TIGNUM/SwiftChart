//
//  PrepareContentFooterTableViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 08/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentFooterTableViewCellDelegate: class {
    func didSavePreparation(preparationID: Int, cell: UITableViewCell)
}

final class PrepareContentFooterTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    weak var delegate: PrepareContentFooterTableViewCellDelegate?
    var preparationID: Int = 0
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .clear
        backgroundColor = .clear
        saveButton.imageView?.image = saveButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        saveButton.tintColor = .black30
        let title = NSMutableAttributedString(string: R.string.localized.preparePrepareEventsSaveThisPreparation(),
                                              letterSpacing: 1,
                                              font: Font.DPText,
                                              textColor: .black40)
        saveButton.setAttributedTitle(title, for: .normal)
    }
}

// MARK: - Actions

extension PrepareContentFooterTableViewCell {

    @IBAction private func savePreparation(sender: UIButton) {
        delegate?.didSavePreparation(preparationID: preparationID, cell: self)
    }
}
