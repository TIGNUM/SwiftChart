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
        self.title.text = viewModel?.title
        self.aboutMeContent.text = viewModel?.aboutMeContent
        self.aboutMeMoreInfo.text = viewModel?.aboutMeMoreInfo
    }
}
