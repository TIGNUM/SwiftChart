//
//  MyLibraryCategoryTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyLibraryCategoryTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var infoText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let selectedBackground = UIView(frame: bounds)
        ThemeView.level2Selected.apply(selectedBackground)
        selectedBackgroundView = selectedBackground
    }
}
