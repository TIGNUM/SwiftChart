//
//  MyDataChartLegendTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
        resetContent()
        for label in labelsCollection {
            skeletonManager.addSubtitle(label)
        }
        skeletonManager.addOtherView(addButton)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }

    func configure(selectionModel: MyDataSelectionModel?) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString()
        guard let model = selectionModel else {
            labelsCollection.first?.attributedText = attributedString
            return
        }

        HealthService.main.availableHealthIndexesForToday { [weak self] (healthData) in
            guard let strongSelf = self else { return }
            let hasHealthKitDataForToday: Bool = (healthData?.count ?? 0) > 0

            strongSelf.skeletonManager.hide()
            var indexes: [Int] = []
            for (index, sectionModel) in model.myDataSelectionItems.enumerated() {
                if var title = sectionModel.title {
                    if hasHealthKitDataForToday && sectionModel.myDataExplanationSection == .SQN {
                        title.append(contentsOf: (" " + ScreenTitleService.main.localizedString(for: .myDataExplanationSQNSectionFromHealthKit)))
                    }
                    indexes.append(index)
                    for label in strongSelf.labelsCollection where label.tag == index {
                        ThemeText.myDataParameterLegendText(sectionModel.myDataExplanationSection).apply(title, to: label)
                    }
                }
            }

            for index in indexes where index != 0 {
                for constraint in strongSelf.labelHeightConstraintCollection where Int(constraint.identifier ?? "") == index {
                    constraint.constant = strongSelf.lineHeight
                }
            }
        }
    }

    // MARK: Helpers

    func resetContent() {
        for constraint in labelHeightConstraintCollection where Int(constraint.identifier ?? "") != 0 {
            constraint.constant = 0
        }
        for label in labelsCollection {
            label.text = nil
        }
    }

    // MARK: Actions

    @IBAction func didTapAddButton(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
