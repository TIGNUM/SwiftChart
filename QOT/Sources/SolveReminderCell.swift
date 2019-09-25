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
    }

    func configure(with viewModel: SolveReminderCellViewModel?) {
        ThemeText.dailyBriefTitle.apply((viewModel?.bucketTitle ?? "").uppercased(), to: bucketTitle)
        ThemeText.solveQuestions.apply(viewModel?.question1, to: question1)
        ThemeText.solveQuestions.apply(viewModel?.question2, to: question2)
        ThemeText.solveQuestions.apply(viewModel?.question3, to: question3)
        ThemeText.sprintText.apply(viewModel?.twoDayAgo, to: twoDayAgo)
    }
}
