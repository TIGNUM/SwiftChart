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

class PrepareContentFooterTableViewCell: UITableViewCell, Dequeueable {
    
    weak var delegate: PrepareContentFooterTableViewCellDelegate?
    var preparationID: Int = 0
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        iconImageView.image = iconImageView.image!.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .black30

        let title = NSMutableAttributedString(
            string: R.string.localized.preparePrepareEventsSaveThisPreparation(),
            letterSpacing: 1,
            font: Font.DPText,
            textColor: .black40)

        saveButton.setAttributedTitle(title, for: .normal)
    }
        
    @IBAction func savePreparation(sender: UIButton) {
        delegate?.didSavePreparation(preparationID: preparationID, cell: self)
    }

}
