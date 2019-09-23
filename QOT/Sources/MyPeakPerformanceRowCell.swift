//
//  MyPeakPerformanceRowCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 07.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyPeakPerformanceRowCell: UIView {

    @IBOutlet weak var peakPerformanceRowTitle: UILabel!
    @IBOutlet weak var peakPerformanceRowSubtitle: UILabel!
    private var qdmUserPreparation: QDMUserPreparation?
    weak var delegate: DailyBriefViewControllerDelegate?
    weak var tapGestureRecognizer: UITapGestureRecognizer?

    static func instantiateFromNib() -> MyPeakPerformanceRowCell? {
        guard let header = R.nib.myPeakPerformanceRowCell
            .instantiate(withOwner: self).first as? MyPeakPerformanceRowCell else {
                preconditionFailure("Cannot load view \(#function)")
        }
        return header
    }

    func configure(with: MyPeakPerformanceCellViewModel.MyPeakPerformanceRow) {
        if tapGestureRecognizer == nil {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            addGestureRecognizer(tap)
            tapGestureRecognizer = tap
        }
        isUserInteractionEnabled = true
        qdmUserPreparation = with.qdmUserPreparation
        ThemeText.performanceBucketTitle.apply(with.title ?? "", to: peakPerformanceRowTitle)
        ThemeText.performanceSubtitle.apply(with.subtitle ?? "", to: peakPerformanceRowSubtitle)
    }

    // function which is triggered when handleTap is called
    @IBAction func handleTap() {
        guard let preview = qdmUserPreparation else { /* Handle nil case */ return }
        delegate?.openPreparation(preview)
    }
}
