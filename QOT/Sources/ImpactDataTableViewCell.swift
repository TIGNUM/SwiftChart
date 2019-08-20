//
//  ImpactDataTableViewCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 15.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class ImpactDataTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var subTitle: UILabel!
    @IBOutlet private weak var averageValue: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?
    //TODO configure the data type for averageValue
    @IBOutlet private weak var customDiagonalView: UIView!
    @IBOutlet private weak var targetRefValue: UILabel!
    @IBOutlet private weak var targetRefLabel: UILabel!
    @IBOutlet private weak var customAsteriskView: UIView!
    @IBOutlet private weak var button: UIButton!

    func configure(title: String, subTitle: String, averageValue: String, targetRefValue: Int) {
        self.title.text = title.uppercased()
        self.subTitle.text = subTitle
        self.averageValue.text = averageValue
        self.targetRefValue.text = String(targetRefValue)
        self.bringSubview(toFront: button)
    }

    func setTargetRefLabelText(_ text: String) {
        targetRefLabel.text = text
    }

    @IBAction func customizeTarget(_ sender: Any) {
        delegate?.showCustomizeTarget()
    }
}
