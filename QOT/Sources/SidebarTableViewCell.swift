//
//  SidebarTableViewCell.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class SidebarTableViewCell: UITableViewCell, Dequeueable {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Properties

    func setup(with title: String, font: UIFont, textColor: UIColor) {
        backgroundColor = .clear
        titleLabel.textColor = textColor
        titleLabel.text = title.uppercased()
        titleLabel.font = font
    }
}
