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
        dateIcon.tintColor = UIColor.carbon.withAlphaComponent(0.4)
    }

    func configure(title: String?, dateString: String?) {
        titleLabel.text = title
        dateLabel.text = dateString
    }
}
