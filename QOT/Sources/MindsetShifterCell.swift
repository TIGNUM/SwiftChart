//
//  MindsetShifterCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.03.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class MindsetShifterCell: BaseDailyBriefCell {
    
     @IBOutlet weak var headerView: UIView!
     var baseHeaderView: QOTBaseHeaderView?

    override func awakeFromNib() {
          super.awakeFromNib()
          baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
          baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
      }

    func configure(with viewModel: MindsetShifterViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        baseHeaderView?.configure(title: viewModel.title?.uppercased(), subtitle: viewModel.subtitle)
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.aboutMeContent.apply(viewModel.subtitle, to: baseHeaderView?.subtitleTextView)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
    
}
