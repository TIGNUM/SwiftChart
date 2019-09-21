//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var peakEventsLabel: UILabel!
    @IBOutlet private weak var button: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(peakEventsLabel)
        skeletonManager.addOtherView(button)
    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
//TO DO: title label text should not be hardcoded in the xib file
        ThemeText.dailyBriefDailyCheckInSights.apply(with?.intro, to: peakEventsLabel)
        skeletonManager.hide()
    }

    @IBAction func preparations(_ sender: Any) {
        delegate?.displayCoachPreparationScreen()
    }

}
