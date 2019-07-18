//
//  TBVDataGraphBarNextDurationViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVDataGraphBarNextDurationViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var durationlabel: UILabel!

    var duration: String? {
        willSet {
            durationlabel.text = R.string.localized.tbvDataGraphBarNextDurationViewCellInFourWeeks()
            let degrees: Double = -90 //the value in degrees
            durationlabel.transform = CGAffineTransform(rotationAngle: CGFloat(degrees * .pi/180))
            durationlabel.translatesAutoresizingMaskIntoConstraints = true
            durationlabel.frame = CGRect(origin: CGPoint(x: 0, y: durationlabel.frame.origin.y), size: durationlabel.frame.size)
            self.layoutIfNeeded()
        }
    }
}
