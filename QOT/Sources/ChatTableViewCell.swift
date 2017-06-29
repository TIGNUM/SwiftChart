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

        iconImageView.layer.cornerRadius = 12
        iconImageView.layer.masksToBounds = true

        bubbleView.layer.cornerRadius = 8
        bubbleView.layer.masksToBounds = true
        backgroundColor = .clear
    }

    func setup(showIcon: Bool) {
        iconImageView?.isHidden = showIcon == false 
    }
}
