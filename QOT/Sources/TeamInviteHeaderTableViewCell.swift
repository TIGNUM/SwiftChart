//
//  TeamInviteHeaderTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInviteHeaderTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    func configure(header: String, content: String) {
        headerLabel.text = header
        contentLabel.text = content
    }
}
