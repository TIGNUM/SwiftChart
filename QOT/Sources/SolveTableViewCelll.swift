//
//  SolveTableViewCelll.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

import UIKit

final class SolveTableViewCell: BaseDailyBriefCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var solve: QDMSolve?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent.apply(button)
    }

    func configure(title: String?, date: String?, solve: QDMSolve?) {
        ThemeView.level2.apply(self)
        ThemeText.durationString.apply(date, to: dateLabel)
        ThemeText.sprintTitle.apply((title ?? "").uppercased(), to: titleLabel)
        self.solve = solve
    }

    @IBAction func checkIt(_ sender: Any) {
        if let solve = solve {
            delegate?.showSolveResults(solve: solve)
        }
    }
}
