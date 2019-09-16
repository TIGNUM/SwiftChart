//
//  MyPeakPerformanceSectionCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceSectionCell: UIView {

    @IBOutlet weak var myPeakPerformanceSectionTitle: UILabel!

    @IBOutlet weak var myPeakperformanceSectionContent: UILabel!

    static func instantiateFromNib() -> MyPeakPerformanceSectionCell? {
        guard let section = R.nib.myPeakPerformanceSectionCell
            .instantiate(withOwner: self).first as? MyPeakPerformanceSectionCell else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return section
    }

    func configure(with: MyPeakPerformanceCellViewModel.MyPeakPerformanceSectionRow) {
        ThemeText.performanceSections.apply((with.sectionSubtitle ?? "").uppercased(), to: myPeakPerformanceSectionTitle)
        ThemeText.performanceSectionText.apply(with.sectionContent, to: myPeakperformanceSectionContent)
    }
}
