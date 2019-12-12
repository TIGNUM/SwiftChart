//
//  RegisterIntroNoteTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 02/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol RegisterIntroNoteTableViewCellDelegate: class {
    func didTapReadMore()
}

final class RegisterIntroNoteTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    weak var delegate: RegisterIntroNoteTableViewCellDelegate?

    func configure(title: String?, body: String?, expanded: Bool = false) {
        ThemeText.registerIntroNoteTitle.apply(title, to: titleLabel)
        ThemeText.registerIntroBody.apply(body, to: bodyLabel)
        readMoreButton.isHidden = expanded
    }
    @IBAction func didTapReadMoreButton(_ sender: UIButton) {
        delegate?.didTapReadMore()

    }
}
