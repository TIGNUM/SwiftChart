//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var button: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(button)

    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
        guard let model = with else { return }
        baseHeaderview?.configure(title: model.title,
                                  subtitle: model.intro)
        ThemeText.dailyBriefTitle.apply(model.title, to: baseHeaderview?.titleLabel)
        ThemeText.dailyBriefDailyCheckInSights.apply(model.intro, to: baseHeaderview?.subtitleTextView)
        headerHeightConstraint.constant = baseHeaderview?.calculateHeight(for: self.frame.size.width) ?? 0
        skeletonManager.hide()
    }

    @IBAction func preparations(_ sender: Any) {
        delegate?.displayCoachPreparationScreen()
    }

}
