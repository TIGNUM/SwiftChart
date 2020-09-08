//
//  PollCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 07.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class PollCollectionViewCell: MultipleSelectionCollectionViewCell {

    // MARK: - Properties
    @IBOutlet private weak var titeLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        counterLabel.circle()
    }
}
