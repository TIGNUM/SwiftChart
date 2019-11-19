//
//  DailyCheckinInsightsTBVCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 16.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class DailyCheckinInsightsTBVCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var button: AnimatedButton!
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!

    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
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
        tbvSentence.text = model.tbvSentence
        self.adviceText.text = model.adviceText
    }
}

private extension DailyCheckinInsightsTBVCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
}
