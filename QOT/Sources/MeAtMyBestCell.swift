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
    var baseView: QOTBaseHeaderView?
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
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: self, showSkeleton: true)
    }

    func configure(with viewModel: MeAtMyBestCellViewModel?) {
        guard let model = viewModel else {
            return
        }
        skeletonManager.hide()
        baseView?.configure(title: (model.title ?? "").uppercased(), subtitle: model.intro)
        baseView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseView?.titleLabel)
        ThemeText.sprintText.apply(model.intro, to: baseView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseView?.calculateHeight(for: self.frame.size.width) ?? 0
        ThemeText.tbvStatement.apply(model.tbvStatement, to: meAtMyBestContent)
        ThemeText.solveFuture.apply(model.intro2, to: meAtMyBestFuture)
        meAtMyBestButtonText.setTitle(model.buttonText, for: .normal)
    }
}
