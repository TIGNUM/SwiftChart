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
    var baseView: QOTBaseHeaderView?
    @IBOutlet private weak var buttonText: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addOtherView(buttonText)
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: headerView, showSkeleton: true)
    }

    func configure(with: MeAtMyBestCellEmptyViewModel?) {
        guard let model = with else { return }
        skeletonManager.hide()
        baseView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.intro)
        baseView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseView?.titleLabel)
        ThemeText.sprintText.apply(model.intro, to: baseView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseView?.calculateHeight(for: self.frame.size.width) ?? 0
        buttonText.setTitle(model.buttonText ?? "none", for: .normal)
        buttonText?.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }
}
