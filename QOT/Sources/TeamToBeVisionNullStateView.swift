//
//  TeamToBeVisionNullStateView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionNullStateView: UIView {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var toBeVisionLabel: UILabel!
    @IBOutlet weak var teamNullStateImage: UIImageView!

    func setupView(with header: String, message: String, sectionHeader: String) {
        ThemeView.level2.apply(self)
        ThemeText.tbvSectionHeader.apply(sectionHeader, to: toBeVisionLabel)
        ThemeText.tbvHeader.apply(header, to: headerLabel)
        ThemeText.tbvVision.apply(message, to: detailLabel)
    }
}
