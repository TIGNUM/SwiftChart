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
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet private weak var button: AnimatedButton!
    var interactor: DailyBriefInteractorInterface?
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(tbvSentence)
        skeletonManager.addSubtitle(adviceText)
        skeletonManager.addOtherView(button)
    }

    func configure(with: DailyCheckIn2TBVModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        baseHeaderview?.configure(title: model.title,
                                  subtitle: model.introText)
        baseHeaderview?.subtitleTextViewBottomConstraint.constant = 0
        headerHeightConstraint.constant = baseHeaderview?.calculateHeight(for: self.frame.size.width) ?? 0
        tbvSentence.text = model.tbvSentence
        self.adviceText.text = model.adviceText
    }
}

private extension DailyCheckinInsightsTBVCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
}
