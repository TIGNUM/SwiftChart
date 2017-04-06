//
//  InputCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 06.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class InputCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.black
    }

}
