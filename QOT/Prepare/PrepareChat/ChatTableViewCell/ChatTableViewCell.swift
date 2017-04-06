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
    @IBOutlet weak var cardLikeView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardLikeView.layer.cornerRadius = 10
        self.cardLikeView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
