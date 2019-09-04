//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet private weak var peakEventsLabel: UILabel!
    @IBOutlet private weak var button: UIButton!
    var delegate: DailyBriefViewControllerDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
        ThemeText.dailyBriefDailyCheckInSights.apply(with?.intro, to: peakEventsLabel)
    }

    @IBAction func preparations(_ sender: Any) {
        delegate?.displayCoachPreparationScreen()
    }

}
