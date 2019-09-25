//
//  BaseMyLibraryTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 01/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseMyLibraryTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedView = UIView()
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
    }
}
