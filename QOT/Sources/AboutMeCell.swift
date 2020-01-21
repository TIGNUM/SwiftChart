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
    @IBOutlet private weak var aboutMeMoreInfo: UILabel!
    @IBOutlet private weak var footnoteView: UIView!
    @IBOutlet private weak var footnoteHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var footerVerticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var footerHorizontalConstraints: [NSLayoutConstraint]!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(aboutMeMoreInfo)
    }

    func configure(with viewModel: AboutMeViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.aboutMeContent)
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.aboutMeContent.apply(viewModel.aboutMeContent, to: baseHeaderView?.subtitleTextView)
        ThemeText.dailyBriefSubtitle.apply(viewModel.aboutMeMoreInfo, to: aboutMeMoreInfo)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
//        self.aboutMeMoreInfo.text = viewModel.aboutMeMoreInfo
        self.footnoteView.isHidden = viewModel.aboutMeMoreInfo?.isEmpty ?? true
        self.footnoteHeightConstraint.constant = self.calculateFooterHeight(for: self.footnoteView.frame.width)
        self.headerViewHeightConstraint.constant = self.baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        DispatchQueue.main.async {
//            self.footnoteHeightConstraint.constant = self.calculateFooterHeight(for: self.footnoteView.frame.width)
            self.headerViewHeightConstraint.constant = self.baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
//            self.frame.size.height = self.footnoteHeightConstraint.constant + self.headerViewHeightConstraint.constant
//            self.setNeedsLayout()
            self.setNeedsUpdateConstraints()
        }
    }

    private func calculateFooterHeight(for width: CGFloat) -> CGFloat {
        var height: CGFloat = 0
        var verticalConstraintsSum: CGFloat = 0
        var horizontalConstraintsSum: CGFloat = 0
        for constraint in footerVerticalConstraints {
            verticalConstraintsSum += constraint.constant
        }
        for constraint in footerHorizontalConstraints {
            horizontalConstraintsSum += constraint.constant
        }
        let moreInfoLabelSize = aboutMeMoreInfo.sizeThatFits(CGSize(width: width - horizontalConstraintsSum,
                                                                    height: .greatestFiniteMagnitude))
        height = height + moreInfoLabelSize.height + verticalConstraintsSum
        return height
    }
}
