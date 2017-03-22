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

    func setup(with viewModel: SidebarViewModel) {
        backgroundColor = .clear
        titleLabel?.textColor = .lightGray
        titleLabel?.text = viewModel.
    }
}
