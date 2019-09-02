//
//  MyDataChartLegendTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataChartLegendTableViewCellDelegate: class {
    func didTapAddButton()
}

final class MyDataChartLegendTableViewCell: MyDataBaseTableViewCell {
    // MARK: - Properties

    @IBOutlet private var labelsCollection: [UILabel]!
    @IBOutlet private var labelHeightConstraintCollection: [NSLayoutConstraint]!
    @IBOutlet weak var addButton: UIButton!
    weak var delegate: MyDataChartLegendTableViewCellDelegate?
    let lineHeight: CGFloat = 18.0

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeButton.accent40.apply(addButton)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        for constraint in labelHeightConstraintCollection where Int(constraint.identifier ?? "") != 0 {
            constraint.constant = 0
        }
    }

    func configure(selectionModel: MyDataSelectionModel?) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString()
        guard let model = selectionModel else {
            labelsCollection.first?.attributedText = attributedString
            return
        }
        var indexes: [Int] = []
        for (index, sectionModel) in model.myDataSelectionItems.enumerated() {
            if let title = sectionModel.title {
                indexes.append(index)
                for label in labelsCollection where label.tag == index {
                    ThemeText.myDataParameterLegendText(sectionModel.myDataExplanationSection).apply(title, to: label)
                }
            }
        }

        for index in indexes where index != 0 {
            for constraint in labelHeightConstraintCollection where Int(constraint.identifier ?? "") == index {
                constraint.constant = lineHeight
            }
        }
    }

    // MARK: Actions

    @IBAction func didTapAddButton(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
