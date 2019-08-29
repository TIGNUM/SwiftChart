//
//  MyPeakPerformanceRowCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceRowCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var peakPerformanceRowTitle: UILabel!

    @IBOutlet weak var peakPerformanceRowSubtitle: UILabel!

    func configure(with: MyPeakPerformanceRowModel?) {
        ThemeView.level2.apply(self)
        ThemeText.performanceBucketTitle.apply(with?.title ?? "", to: peakPerformanceRowTitle)
        ThemeText.performanceSubtitle.apply(with?.subtitle ?? "", to: peakPerformanceRowSubtitle)
    }
}
