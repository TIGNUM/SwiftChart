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
    @IBOutlet private weak var meAtMyBestButtonText: UIButton!
    var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        meAtMyBestButtonText.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: meAtMyBestTitle)
        ThemeText.sprintText.apply(viewModel?.intro, to: meAtMyBestLabel)
        ThemeText.tbvStatement.apply(viewModel?.tbvStatement, to: meAtMyBestContent)
        ThemeText.solveFuture.apply(viewModel?.intro2, to: meAtMyBestFuture)
        meAtMyBestButtonText.setTitle(viewModel?.buttonText, for: .normal)
    }
}
