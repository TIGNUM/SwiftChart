//
//  MyDataSelectionScreenTableViewCell.swift
//  QOT
//
//  Created by Voicu on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyDataSelectionScreenTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    var showSelected: Bool = false {
        didSet {
            self.setupForSelected(selected: showSelected)
        }
    }

    func configure(title: String?, selected: Bool) {
        guard let title = title else {
            return
        }
        showSelected = selected
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.2,
                                                       font: .sfProtextRegular(ofSize: 14),
                                                       lineSpacing: 6,
                                                       textColor: .sand,
                                                       alignment: .left)
        self.setupForSelected(selected: showSelected)
    }

    func setupForSelected(selected: Bool) {
        let image = selected ? UIImage.init(named: "activeCircle") : UIImage.init(named: "inactiveCircle")
        checkMarkImageView.image = image
    }
}
