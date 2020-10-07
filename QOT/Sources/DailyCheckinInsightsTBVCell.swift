//
//  DailyCheckinInsightsTBVCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DailyCheckinInsightsTBVCell: BaseDailyBriefCell {

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    private weak var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var button: AnimatedButton!
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(tbvSentence)
        skeletonManager.addSubtitle(adviceText)
        skeletonManager.addOtherView(button)
    }

    func configure(with: DailyCheckIn2TBVModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: model.title,
                                  subtitle: model.introText)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        button.setTitle(model.cta, for: .normal)
        button.setButtonContentInset(padding: 16)
        tbvSentence.text = model.tbvSentence
        ThemeText.dailyInsightsTbvAdvice.apply(model.adviceText, to: adviceText)
        button.setTitle(AppTextService.get(.daily_brief_section_daily_insights_tbv_button_view_my_tbv), for: .normal)
        button.setButtonContentInset(padding: 16)
    }
}

private extension DailyCheckinInsightsTBVCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        delegate?.showTBV()
    }
}
