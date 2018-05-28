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

    @IBOutlet private weak var saveButton: UIButton!
    weak var delegate: PrepareContentFooterTableViewCellDelegate?
    var preparationID: Int = 0

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        let title = NSMutableAttributedString(string: R.string.localized.preparePrepareEventsSaveThisPreparation(),
                                              letterSpacing: 1,
                                              font: Font.DPText,
                                              textColor: .white)
        saveButton.setAttributedTitle(title, for: .normal)
        let image = R.image.ic_save_prep()?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        saveButton.tintColor = .white
        saveButton.corner(radius: 4)
    }
}

// MARK: - Actions

extension PrepareContentFooterTableViewCell {

    @IBAction private func savePreparation(sender: UIButton) {
        delegate?.didSavePreparation(preparationID: preparationID, cell: self)
    }
}
