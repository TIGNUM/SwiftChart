//
//  MeAtMyBestCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var meAtMyBestContent: UILabel!
    @IBOutlet private weak var meAtMyBestFuture: UILabel!
    @IBOutlet private weak var suggestionLabel: UILabel!
    @IBOutlet private weak var ctaButton: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        skeletonManager.addSubtitle(meAtMyBestContent)
        skeletonManager.addOtherView(meAtMyBestFuture)
        skeletonManager.addOtherView(ctaButton)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        guard let model = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.intro)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.sprintText.apply(model.intro, to: baseHeaderView?.subtitleTextView)
        ThemeText.tbvStatement.apply(model.tbvStatement, to: meAtMyBestContent)
        ThemeText.tbvStatement.apply(model.intro2, to: meAtMyBestFuture)
        ThemeText.suggestionMyBest.apply("Suggestion for today", to: suggestionLabel)
        ctaButton.setButtonContentInset(padding: 16)
        ctaButton.setTitle(model.buttonText, for: .normal)
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 10
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
    }
}
