//
//  ChatTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell, Dequeueable {
    
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.bubbleView.layer.cornerRadius = 10
        self.bubbleView.layer.masksToBounds = true
    }    
}
