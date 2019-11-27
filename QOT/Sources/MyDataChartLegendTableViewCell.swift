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

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var stackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var addButton: UIButton!
    weak var delegate: MyDataChartLegendTableViewCellDelegate?
    private let lineHeight: CGFloat = 18.0

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeButton.accent40.apply(addButton)
        resetContent()
        skeletonManager.addSubtitle(stackView)
        skeletonManager.addOtherView(addButton)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetContent()
    }

    func configure(selectionModel: MyDataSelectionModel?) {
        guard let model = selectionModel else {
            return
        }

        HealthService.main.availableHealthKitTrackerDataForToday { [weak self] (healthData) in
            guard let strongSelf = self else { return }
            strongSelf.resetContent()
            let hasHealthKitDataForToday: Bool = (healthData?.count ?? 0) > 0
            strongSelf.stackViewHeightConstraint.constant = strongSelf.lineHeight * CGFloat(model.myDataSelectionItems.count)
            strongSelf.skeletonManager.hide()
            for sectionModel in model.myDataSelectionItems {
                if var title = sectionModel.title {
                    if hasHealthKitDataForToday && sectionModel.myDataExplanationSection == .SQN {
                        title.append(contentsOf: (" " + AppTextService.get(AppTextKey.my_qot_my_data_ir_add_parameters_section_five_day_recovery_title_from_healthkit)))
                    }
                    let label = UILabel.init(frame: .zero)
                    ThemeText.myDataParameterLegendText(sectionModel.myDataExplanationSection).apply(title, to: label)
                    strongSelf.stackView.addArrangedSubview(label)
                }
            }
        }
        layoutIfNeeded()
    }
    // MARK: Helpers

    func resetContent() {
        stackView.removeAllArrangedSubviews()
    }

    // MARK: Actions
    @IBAction func didTapAddButton(_ sender: UIButton) {
        delegate?.didTapAddButton()
    }
}
