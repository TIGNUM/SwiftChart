//
//  SolveReminderCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveReminderCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var question1: UILabel!
    @IBOutlet private weak var question2: UILabel!
    @IBOutlet private weak var question3: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(question1)
        skeletonManager.addSubtitle(question2)
        skeletonManager.addSubtitle(question3)
    }

    func configure(with viewModel: SolveReminderCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.bucketTitle ?? "").uppercased(), subtitle: model.twoDayAgo)
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        ThemeText.sprintText.apply(model.twoDayAgo, to: baseHeaderView?.subtitleTextView)
        ThemeText.solveQuestions.apply(model.question1, to: question1)
        ThemeText.solveQuestions.apply(model.question2, to: question2)
        ThemeText.solveQuestions.apply(model.question3, to: question3)
        ThemeView.level2.apply(contentView)
    }
}
