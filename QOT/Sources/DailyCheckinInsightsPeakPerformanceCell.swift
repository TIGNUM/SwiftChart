//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var peakEventsLabel: UILabel!
    @IBOutlet private weak var button: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(peakEventsLabel)
        skeletonManager.addOtherView(button)
    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
        guard let model = with else { return }
        ThemeText.dailyBriefDailyCheckInSights.apply(model.intro, to: peakEventsLabel)
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply(model.title, to: bucketTitle)
    }

    @IBAction func preparations(_ sender: Any) {
        delegate?.displayCoachPreparationScreen()
    }

}
