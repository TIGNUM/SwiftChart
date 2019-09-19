//
//  AboutMeCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AboutMeCell: BaseDailyBriefCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var aboutMeContent: UILabel!
    @IBOutlet private weak var aboutMeMoreInfo: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(aboutMeContent)
        skeletonManager.addSubtitle(aboutMeMoreInfo)
    }

    @IBOutlet weak var stackView: UIStackView!
    func configure(with viewModel: AboutMeViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply(viewModel.title?.uppercased(), to: title)
        self.aboutMeContent.text = viewModel.aboutMeContent
        self.aboutMeMoreInfo.text = viewModel.aboutMeMoreInfo
        guard let asteriskInfo = viewModel.aboutMeMoreInfo, !asteriskInfo.isEmpty else {
            dividerHeight.constant = 0
            return
        }
    }
}
