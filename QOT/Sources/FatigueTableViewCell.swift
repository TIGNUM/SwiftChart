//
//  FatigueTableViewCell.swift
//  QOT
//
//  Created by karmic on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FatigueTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var fatigueLabel: UILabel!

    func configure(symptom: String) {
        fatigueLabel.text = symptom
    }
}
