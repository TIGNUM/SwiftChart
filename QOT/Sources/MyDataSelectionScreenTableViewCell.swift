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
    @IBOutlet private weak var checkMarkImageView: UIImageView!
    var showSelected: Bool = false {
        didSet {
            self.setupForSelected(selected: showSelected)
        }
    }

    func configure(forSelectionItem: MyDataSelectionModel.SelectionItem?) {
        self.selectionStyle = .none
        guard let selectionItem = forSelectionItem,
              let title = selectionItem.title else {
            return
        }
        showSelected = selectionItem.selected
        titleLabel.attributedText = NSAttributedString(string: title,
                                                       letterSpacing: 0.2,
                                                       font: .sfProtextRegular(ofSize: 14),
                                                       lineSpacing: 6,
                                                       textColor: MyDataExplanationModel.color(for: selectionItem.myDataExplanationSection),
                                                       alignment: .left)
        self.setupForSelected(selected: showSelected)
    }

    func setupForSelected(selected: Bool) {
        let image = selected ? UIImage.init(named: "activeCircle") : UIImage.init(named: "inactiveCircle")
        checkMarkImageView.image = image
    }
}
