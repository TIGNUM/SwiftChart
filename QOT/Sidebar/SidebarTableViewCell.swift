//
//  SidebarTableViewCell.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class SidebarTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var titleLabel: UILabel?
    
    // MARK: - Properties

    func setup(with title: String) {
        backgroundColor = .clear
        titleLabel?.text = title
    }
}
