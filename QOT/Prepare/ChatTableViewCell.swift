//
//  ChatTableViewCell.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet fileprivate weak var messageLabel: UILabel!

    // MARK: - Life Cycle

    func setup(title: String?) {
        messageLabel.text = title
    }
}
