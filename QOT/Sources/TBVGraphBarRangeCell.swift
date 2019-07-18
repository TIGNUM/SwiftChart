//
//  TBVGraphBarRangeCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVGraphBarRangeCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var initialValueLabel: UILabel!
    @IBOutlet private weak var finalValueLabel: UILabel!

    func configure(with range: TBVGraph.Range) {
        initialValueLabel.text = String(describing: range.inital)
        finalValueLabel.text = String(describing: range.final)
    }
}
