//
//  MyPeakperformanceTitleCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyPeakPerformanceTitleCell: UIView {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var containerView: UIView!

    static func instantiateFromNib() -> MyPeakPerformanceTitleCell? {
        guard let header = R.nib.myPeakPerformanceTitleCell
            .instantiate(withOwner: self).first as? MyPeakPerformanceTitleCell else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return header
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.maskCorners(corners: [.topRight, .topLeft], radius: Layout.cornerRadius08)
    }

    func configure(bucketTitle: String?) {
        ThemeText.dailyBriefTitleBlack.apply(bucketTitle, to: title)
    }
}
