//
//  MeAtMyBestEmptyCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MeAtMyBestEmptyCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var buttonText: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addOtherView(buttonText)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
    }

    func configure(with: MeAtMyBestCellEmptyViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.intro)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.sprintText.apply(model.intro, to: baseHeaderView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        buttonText.setTitle(model.buttonText ?? "none", for: .normal)
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }
}
