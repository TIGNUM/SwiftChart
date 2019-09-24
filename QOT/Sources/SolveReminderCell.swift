//
//  SolveReminderCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SolveReminderCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var twoDayAgo: UILabel!
    @IBOutlet private weak var question1: UILabel!
    @IBOutlet private weak var question2: UILabel!
    @IBOutlet private weak var question3: UILabel!
    private var solveViewModels: [SolveReminderCellViewModel.SolveViewModel]? = []
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(twoDayAgo)
        skeletonManager.addSubtitle(question1)
        skeletonManager.addSubtitle(question2)
        skeletonManager.addSubtitle(question3)
    }

    func configure(with viewModel: SolveReminderCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.solveQuestions.apply(model.question1, to: question1)
        ThemeText.solveQuestions.apply(model.question2, to: question2)
        ThemeText.solveQuestions.apply(model.question3, to: question3)
        ThemeText.sprintText.apply(model.twoDayAgo, to: twoDayAgo)
        ThemeView.level2.apply(contentView)
    }
}
