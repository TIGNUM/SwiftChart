//
//  MyDataSelectionScreenTableViewCell.swift
//  QOT
//
//  Created by Voicu on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyDataSelectionScreenTableViewCell: MyDataBaseTableViewCell {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    var showSelected: Bool = false {
        didSet {
            self.setupForSelected(selected: showSelected)
        }
    }

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        skeletonManager.addOtherView(checkMarkImageView)
    }

    func configure(forSelectionItem: MyDataSelectionModel.SelectionItem?) {
        self.selectionStyle = .none
        guard let selectionItem = forSelectionItem,
            let subtitle = selectionItem.subtitle,
            let title = selectionItem.title else {
            return
        }
        skeletonManager.hide()
        showSelected = selectionItem.selected
        ThemeText.myDataParameterSelectionTitle(selectionItem.myDataExplanationSection).apply(title, to: titleLabel)
        ThemeText.myDataParameterSelectionSubtitle.apply(subtitle, to: subtitleLabel)
        self.setupForSelected(selected: showSelected)
    }

    private func setupForSelected(selected: Bool) {
        let image = selected ? UIImage.init(named: "ic_radio_selected_white") : UIImage.init(named: "ic_radio_unselected_white")
        checkMarkImageView.image = image
    }
}
