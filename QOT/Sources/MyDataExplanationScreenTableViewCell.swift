//
//  MyDataExplanationScreenTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataExplanationScreenTableViewCell: MyDataBaseTableViewCell {

    // MARK: - Properties

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    func configure(forExplanationItem: MyDataExplanationModel.ExplanationItem?) {
        guard let explanationItem = forExplanationItem,
              let title = explanationItem.title,
              let subtitle = explanationItem.subtitle else { return }
        self.selectionStyle = .none
        ThemeText.myDataParameterExplanationTitle(explanationItem.myDataExplanationSection).apply(title, to: titleLabel)
        ThemeText.myDataExplanationCellSubtitle.apply(subtitle, to: subtitleLabel)
    }
}
