//
//  MyPrepTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 14.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyPrepTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var mainTextLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var prepCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
}
