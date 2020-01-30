//
//  FromTignumCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FromTignumCell: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var fromTignumText: UILabel!
    private var detailsExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(fromTignumText)
    }

    @IBAction func discoverButton(_ sender: Any) {
        detailsExpanded.toggle()
    }

    func configure(with viewModel: FromTignumCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.subtitle)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefFromTignumTitle.apply((model.subtitle ?? ""), to: baseHeaderView?.subtitleTextView)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.bespokeText.apply(model.text, to: fromTignumText)
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
}
