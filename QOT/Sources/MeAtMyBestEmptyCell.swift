//
//  MeAtMyBestEmptyCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestEmptyCell: BaseDailyBriefCell {

    @IBOutlet private weak var intro: UILabel!
    @IBOutlet private weak var buttonText: UIButton!
    @IBOutlet private weak var title: UILabel!
    var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }
    func configure(with: MeAtMyBestCellEmptyViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((with?.title ?? "").uppercased(), to: title)
        ThemeText.sprintText.apply(with?.intro, to: intro)
        buttonText.setTitle(with?.buttonText, for: .normal)
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }
}
