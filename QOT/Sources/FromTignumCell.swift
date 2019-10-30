//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromTignumCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var detailsExpanded = false
    @IBOutlet private weak var button: AnimatedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent.apply(button)
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(fromTignumText)
        skeletonManager.addOtherView(button)
    }

    @IBAction func discoverButton(_ sender: Any) {
        if detailsExpanded {
            detailsExpanded = false
        } else {
//          link to more details
            detailsExpanded = true
        }
    }

    func configure(with viewModel: FromTignumCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderview?.configure(title: (model.title ?? "").uppercased(), subtitle: model.subtitle)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderview?.titleLabel)
        ThemeText.bespokeText.apply(model.text, to: fromTignumText)
    }
}
