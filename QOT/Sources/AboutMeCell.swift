//
//  AboutMeCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 30.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AboutMeCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var aboutMeContent: UILabel!
    @IBOutlet private weak var aboutMeMoreInfo: UILabel!

    func configure(with viewModel: AboutMeViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((viewModel?.title ?? "").uppercased(), to: title)
        self.aboutMeContent.text = viewModel?.aboutMeContent
        self.aboutMeMoreInfo.text = viewModel?.aboutMeMoreInfo
    }
}
