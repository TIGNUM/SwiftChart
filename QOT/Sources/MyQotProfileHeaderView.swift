//
//  MyQotProfileHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileHeaderView: UITableViewHeaderFooterView, Dequeueable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var memberSinceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .carbonDark
    }
    
    func configure(data: MyQotProfileModel.HeaderViewModel) {
        nameLabel.text = data.name
        memberSinceLabel.text = data.memberSince
    }
}
