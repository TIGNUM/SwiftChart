//
//  RegisterIntroNoteTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class RegisterIntroNoteTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    func configure(title: String?, body: String?) {
        ThemeText.registerIntroNoteTitle.apply(title, to: titleLabel)
        ThemeText.registerIntroBody.apply(body, to: bodyLabel)
    }
}
