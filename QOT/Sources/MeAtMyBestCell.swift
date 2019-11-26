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
    @IBOutlet private weak var meAtMyBestButtonText: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?

    @IBAction func presentTBV(_ sender: Any) {
        delegate?.presentMyToBeVision()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        meAtMyBestButtonText.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        skeletonManager.addSubtitle(meAtMyBestContent)
        skeletonManager.addOtherView(meAtMyBestFuture)
        skeletonManager.addOtherView(meAtMyBestButtonText)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        guard let model = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.intro)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 10
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.sprintText.apply(model.intro, to: baseHeaderView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        ThemeText.tbvStatement.apply(model.tbvStatement, to: meAtMyBestContent)
        ThemeText.solveFuture.apply(model.intro2, to: meAtMyBestFuture)
        meAtMyBestButtonText.setTitle(model.buttonText, for: .normal)
    }
}
