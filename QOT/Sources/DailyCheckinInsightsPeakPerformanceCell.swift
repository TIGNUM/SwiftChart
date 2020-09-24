//
//  DailyCheckinInsightsPeakPerformanceCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckinInsightsPeakPerformanceCell: BaseDailyBriefCell {

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var button: AnimatedButton!
    @IBOutlet weak var buttonToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    private var hasNoPerformance: Bool? = false
    private weak var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        ThemeButton.dailyBriefButtons.apply(button, selected: false)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(button)

    }

    func configure(with: DailyCheckIn2PeakPerformanceModel?) {
        guard let model = with else { return }
        baseHeaderView?.configure(title: model.title,
                                  subtitle: model.intro)
        ThemeText.dailyBriefTitle.apply(model.title, to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefDailyCheckInSights.apply(model.intro, to: baseHeaderView?.subtitleTextView)
        button.setTitle(AppTextService.get(.daily_brief_section_daily_insights_peak_performances_button_get_started), for: .normal)
        self.hasNoPerformance = model.hasNoPerformance
        if let hasNoPerformance = model.hasNoPerformance {
            button.isHidden = hasNoPerformance
        }
        skeletonManager.hide()
    }

    override func updateConstraints() {
        super.updateConstraints()
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        if self.hasNoPerformance ?? false {
            buttonToBottomConstraint.constant = 0
            buttonHeightConstraint.constant = 0
        }
    }

    @IBAction func preparations(_ sender: Any) {
        delegate?.displayCoachPreparationScreen()
    }
}
