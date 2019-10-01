//
//  MyDataHeatMapButtonsTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

enum HeatMapMode: Int {
    case dailyIR = 0
    case fiveDaysRollingIR = 1
}

protocol MyDataHeatMapButtonsTableViewCellDelegate: class {
    func didChangeSelection(toMode: HeatMapMode)
}

final class MyDataHeatMapButtonsTableViewCell: MyDataBaseTableViewCell {
    // MARK: - Properties
    @IBOutlet weak var dailyIRButton: UIButton!
    @IBOutlet weak var fiveDaysRollingIRButton: UIButton!
    @IBOutlet var allButtons: [UIButton]!
    private var heatMapMode: HeatMapMode = .dailyIR

    weak var delegate: MyDataHeatMapButtonsTableViewCellDelegate?

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
        skeletonManager.addOtherView(dailyIRButton)
        skeletonManager.addOtherView(fiveDaysRollingIRButton)
        selectionStyle = .none
    }

    func configure(with firstTitle: String?, and secondTitle: String?) {
        skeletonManager.hide()
        dailyIRButton.setTitle(firstTitle ?? "", for: .normal)
        fiveDaysRollingIRButton.setTitle(secondTitle ?? "", for: .normal)
    }

    // MARK: UI Setup

    private func setupButtons() {
        dailyIRButton.tag = HeatMapMode.dailyIR.rawValue
        fiveDaysRollingIRButton.tag = HeatMapMode.fiveDaysRollingIR.rawValue

        selectButton(heatMapMode.rawValue)
    }

    // MARK: Actions

    @IBAction func didTapDailyIRButton(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        selectButton(sender.tag)
        delegate?.didChangeSelection(toMode: .dailyIR)
    }

    @IBAction func didFiveDaysRollingIRButton(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        selectButton(sender.tag)
        delegate?.didChangeSelection(toMode: .fiveDaysRollingIR)
    }

    func selectButton(_ forTag: Int) {
        for button in allButtons where button.tag == forTag {
            ThemeButton.accent40.apply(button, selected: true)
            button.isSelected = true
            for otherButton in allButtons where button != otherButton {
                ThemeButton.accent40.apply(otherButton, selected: false)
                otherButton.isSelected = false
            }
        }
    }
}
