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
    var baseView: QOTBaseHeaderView?
    @IBOutlet private weak var aboutMeMoreInfo: UILabel!
    @IBOutlet weak var footnoteView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(aboutMeMoreInfo)
    }

    @IBOutlet weak var stackView: UIStackView!
    func configure(with viewModel: AboutMeViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.aboutMeContent)
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseView?.titleLabel)
        ThemeText.aboutMeContent.apply(viewModel.aboutMeContent, to: baseView?.subtitleTextView)
        baseView?.subtitleTextViewBottomConstraint.constant = 0
        headerViewHeightConstraint.constant = baseView?.calculateHeight(for: self.frame.size.width) ?? 0
        self.aboutMeMoreInfo.text = viewModel.aboutMeMoreInfo
        footnoteView.isHidden = viewModel.aboutMeMoreInfo?.isEmpty ?? true
    }
}
