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
        myPeakPerformanceSectionTitle?.text = with?.sectionSubtitle
        myPeakperformanceSectionContent?.text = with?.sectionContent
    }

}
