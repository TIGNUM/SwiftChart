//
//  MyPeakPerformanceSectionCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceSectionCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var myPeakPerformanceSectionTitle: UILabel!

    @IBOutlet weak var myPeakperformanceSectionContent: UILabel!

    func configure(with: MyPeakPerformanceSectionModel?) {
        ThemeView.level2.apply(self)
        ThemeText.performanceSections.apply((with?.sectionSubtitle ?? "").uppercased(), to: myPeakPerformanceSectionTitle)
        ThemeText.performanceSectionText.apply(with?.sectionContent, to: myPeakperformanceSectionContent)
    }
}
