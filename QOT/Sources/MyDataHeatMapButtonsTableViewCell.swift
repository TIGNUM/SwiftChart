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
    func didChangeSelection(to: HeatMapMode)
}

class MyDataHeatMapButtonsTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    @IBOutlet weak var dailyIRButton: UIButton!
    @IBOutlet weak var fiveDaysRollingIRButton: UIButton!
    @IBOutlet var allButtons: [UIButton]!
    var heatMapMode: HeatMapMode = .dailyIR
    
    weak var delegate: MyDataHeatMapButtonsTableViewCellDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()
    }
    
    // MARK: UI Setup
    
    func setupButtons() {
        dailyIRButton.layer.cornerRadius = 20.0
        dailyIRButton.layer.borderWidth = 1.0
        dailyIRButton.layer.borderColor = UIColor.accent40.cgColor
        
        fiveDaysRollingIRButton.layer.cornerRadius = 20.0
        fiveDaysRollingIRButton.layer.borderWidth = 1.0
        fiveDaysRollingIRButton.layer.borderColor = UIColor.accent40.cgColor
        
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
        delegate?.didChangeSelection(to: .dailyIR)
    }
    
    @IBAction func didFiveDaysRollingIRButton(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        selectButton(sender.tag)
        delegate?.didChangeSelection(to: .fiveDaysRollingIR)
    }
    
    func selectButton(_ forTag: Int) {
        for button in allButtons where button.tag == forTag {
            button.backgroundColor = .accent40
            button.isSelected = true
            for otherButton in allButtons where button != otherButton {
                otherButton.isSelected = false
                otherButton.backgroundColor = .clear
            }
        }
    }
}
