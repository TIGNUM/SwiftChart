//
//  HorizontalHeaderCollectionViewCell.swift
//  QOT
//
//  Created by karmic on 10.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class HorizontalHeaderCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var horizontalHeaderView: HorizontalHeaderView!

    func configure(headerItems: [Team.Item]) {
        horizontalHeaderView.configure(headerItems: headerItems)
    }
}
