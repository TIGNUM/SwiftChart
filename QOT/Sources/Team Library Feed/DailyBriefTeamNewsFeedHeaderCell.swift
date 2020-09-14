//
//  DailyBriefTeamNewsFeedHeaderCell.swift
//  QOT
//
//  Created by Sanggeon Park on 06.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class DailyBriefTeamNewsFeedHeaderCell: BaseDailyBriefCell {
    var titleColor: UIColor = .white
    @IBOutlet weak var headerView: UIView!
    var baseHeaderView: QOTBaseHeaderView?
    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
    }
    func configure(with viewModel: TeamNewsFeedDailyBriefViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        titleColor = UIColor(hex: viewModel.team.teamColor ?? "")
        baseHeaderView?.configure(title: viewModel.title, subtitle: viewModel.subtitle)
        baseHeaderView?.setColor(dashColor: titleColor, titleColor: titleColor, subtitleColor: nil)
    }
}
