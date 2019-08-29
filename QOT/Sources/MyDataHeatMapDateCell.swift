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
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet weak var noDataImageView: UIImageView!
}
