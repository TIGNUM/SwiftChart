//
//  MeAtMyBestCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestCell: BaseDailyBriefCell {

    @IBOutlet private weak var meAtMyBestTitle: UILabel!
    @IBOutlet private weak var meAtMyBestLabel: UILabel!
    @IBOutlet private weak var meAtMyBestContent: UILabel!
    @IBOutlet private weak var meAtMyBestFuture: UILabel!
    @IBOutlet private weak var meAtMyBestButtonText: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        meAtMyBestButtonText.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addSubtitle(meAtMyBestLabel)
        skeletonManager.addSubtitle(meAtMyBestContent)
        skeletonManager.addOtherView(meAtMyBestFuture)
        skeletonManager.addOtherView(meAtMyBestButtonText)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        guard let model = viewModel else {
            return
        }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: meAtMyBestTitle)
        ThemeText.sprintText.apply(model.intro, to: meAtMyBestLabel)
        ThemeText.tbvStatement.apply(model.tbvStatement, to: meAtMyBestContent)
        ThemeText.solveFuture.apply(model.intro2, to: meAtMyBestFuture)
        meAtMyBestButtonText.setTitle(model.buttonText, for: .normal)
    }
}
