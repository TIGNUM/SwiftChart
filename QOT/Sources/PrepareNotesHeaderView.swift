//
//  PrepareNotesHeaderView.swift
//  QOT
//
//  Created by karmic on 08.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareNotesHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .nightModeBackground
    }

    func configure(title: String) {
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 1,
                                                       font: .bentonBookFont(ofSize: 16),
                                                       textColor: .nightModeSubFont,
                                                       alignment: .left)
    }
}
