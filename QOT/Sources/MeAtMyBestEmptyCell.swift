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
    @IBOutlet private weak var buttonText: AnimatedButton!
    @IBOutlet private weak var title: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addSubtitle(title)
        skeletonManager.addSubtitle(intro)
        skeletonManager.addOtherView(buttonText)
    }

    func configure(with: MeAtMyBestCellEmptyViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: title)
        ThemeText.sprintText.apply(model.intro, to: intro)
        buttonText.setTitle(model.buttonText ?? "none", for: .normal)
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }
}
