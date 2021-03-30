//
//  TextCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 29.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!

    func configure(title: String?) {
        titleLabel.text = title
    }
}
