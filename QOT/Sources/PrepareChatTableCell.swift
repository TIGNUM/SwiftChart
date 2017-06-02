//
//  PrepareChatTableCell.swift
//  QOT
//
//  Created by tignum on 4/21/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PrepareChatTableCell: UITableViewCell, Dequeueable {

    @IBOutlet fileprivate weak var dashedView: UIView!
    @IBOutlet fileprivate weak var dashedChatLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
    }

    func updateChatLabel(with text: String) {
       dashedChatLabel.text = text
    }
}
