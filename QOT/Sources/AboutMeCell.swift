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
    @IBOutlet weak var footnoteView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(aboutMeMoreInfoLabel)
    }

    @IBOutlet weak var stackView: UIStackView!
    func configure(with viewModel: AboutMeViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.aboutMeContent)
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.aboutMeContent.apply(viewModel.aboutMeContent, to: baseHeaderView?.subtitleTextView)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        self.aboutMeMoreInfoLabel.text = viewModel.aboutMeMoreInfo
        footnoteView.isHidden = viewModel.aboutMeMoreInfo?.isEmpty ?? true
    }
}
