//
//  PrepareEventTableViewCell.swift
//  QOT
//
//  Created by karmic on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareEventTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dateIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        dateIcon.image = R.image.ic_event()?.withRenderingMode(.alwaysTemplate)
        dateIcon.tintColor = .carbon40
    }

    func configure(title: String?, dateString: String?) {
        ThemeText.resultTitle.apply(title, to: titleLabel)
        ThemeText.resultDate.apply(dateString, to: dateLabel)
    }
}
