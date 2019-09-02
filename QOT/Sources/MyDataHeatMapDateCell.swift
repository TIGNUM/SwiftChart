//
//  MyDataHeatMapDateCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import JTAppleCalendar
import UIKit

final class MyDataHeatMapDateCell: JTAppleCell, Dequeueable {
    public var date: Date = Date()
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private weak var noDataImageView: UIImageView!

    func setDateLabel(text: String, isHighlighted: Bool = false) {
        if isHighlighted {
            ThemeText.myDataHeatMapCellDateHighlighted.apply(text, to: dateLabel)
        } else {
            ThemeText.myDataHeatMapCellDateText.apply(text, to: dateLabel)
        }

    }

    func setNoDataImageView(visible: Bool) {
        noDataImageView.isHidden = !visible
    }
}
