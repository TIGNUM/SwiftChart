//
//  SolveReminderCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SolveReminderCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var twoDayAgo: UILabel!
    @IBOutlet private weak var question1: UILabel!
    @IBOutlet private weak var question2: UILabel!
    @IBOutlet private weak var question3: UILabel!
    private var solveViewModels: [SolveReminderCellViewModel.SolveViewModel]? = []
    var delegate: DailyBriefViewControllerDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func configure(with viewModel: SolveReminderCellViewModel?) {
        self.bucketTitle.text = viewModel?.bucketTitle
        self.twoDayAgo.text = viewModel?.twoDayAgo
        self.question1.text = viewModel?.question1
        self.question2.text = viewModel?.question2
        self.question3.text = viewModel?.question3
    }
}
