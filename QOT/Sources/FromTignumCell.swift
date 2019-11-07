//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromTignumCell: BaseDailyBriefCell {

    @IBOutlet private weak var titleLabel: UILabel!
//    add the height constraint to the label in the cell.
    @IBOutlet private weak var heightOfText: NSLayoutConstraint!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var isLabelAtMaxHeight = false
    @IBOutlet private weak var button: AnimatedButton!
    @IBOutlet weak var fromTignumTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent.apply(button)
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(fromTignumText)
        skeletonManager.addSubtitle(fromTignumTitle)
        skeletonManager.addOtherView(button)
    }

    @IBAction func discoverButton(_ sender: Any) { }

    func configure(with viewModel: FromTignumCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: titleLabel)
        ThemeText.bespokeText.apply(model.text, to: fromTignumText)
    }
}
