//
//  AboutMeCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AboutMeCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    var baseHeaderView: QOTBaseHeaderView?

    @IBOutlet private weak var aboutMeMoreInfoLabel: UILabel!

    @IBOutlet private weak var footnoteView: UIView!
    @IBOutlet private weak var footnoteHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var footerVerticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var footerHorizontalConstraints: [NSLayoutConstraint]!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(aboutMeMoreInfoLabel)
    }

    func configure(with viewModel: AboutMeViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.aboutMeContent)
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.aboutMeContent.apply(viewModel.aboutMeContent, to: baseHeaderView?.subtitleTextView)
        ThemeText.asterix.apply(viewModel.aboutMeMoreInfo, to: aboutMeMoreInfoLabel)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0

        self.aboutMeMoreInfoLabel.text = viewModel.aboutMeMoreInfo
        footnoteView.isHidden = viewModel.aboutMeMoreInfo?.isEmpty ?? true
    }

    override func updateConstraints() {
        super.updateConstraints()
        footnoteHeightConstraint.constant = calculateFooterHeight(for: self.footnoteView.frame.width)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
    }

    private func calculateFooterHeight(for width: CGFloat) -> CGFloat {
        // setting minimum to 1
        var height: CGFloat = 1
        var verticalConstraintsSum: CGFloat = 0
        var horizontalConstraintsSum: CGFloat = 0
        for constraint in footerVerticalConstraints {
            verticalConstraintsSum += constraint.constant
        }
        for constraint in footerHorizontalConstraints {
            horizontalConstraintsSum += constraint.constant
        }
        let moreInfoLabelSize = aboutMeMoreInfoLabel.sizeThatFits(CGSize(width: width - horizontalConstraintsSum,
                                                                    height: .greatestFiniteMagnitude))
        height += moreInfoLabelSize.height + verticalConstraintsSum
        return height
    }
}
