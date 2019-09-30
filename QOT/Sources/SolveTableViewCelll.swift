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
    @IBOutlet weak var button: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var solve: QDMSolve?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent.apply(button)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(dateLabel)
        skeletonManager.addOtherView(button)
    }

    func configure(title: String?, date: String?, solve: QDMSolve?) {
        guard let titleText = title, let dateString = date, let qdmSolve = solve else { return }

        ThemeText.durationString.apply(dateString, to: dateLabel)
        ThemeText.sprintTitle.apply(titleText.uppercased(), to: titleLabel)
        self.solve = qdmSolve
    }

    @IBAction func checkIt(_ sender: Any) {
        ThemeView.audioPlaying.apply(button)
        button.layer.borderWidth = 0
        if let solve = solve {
            delegate?.showSolveResults(solve: solve)
        }
    }
}
