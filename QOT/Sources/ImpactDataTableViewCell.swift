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
    @IBOutlet private weak var customDiagonalView: UIView!
    @IBOutlet private weak var targetRefValue: UILabel!
    @IBOutlet private weak var targetRefLabel: UILabel!
    @IBOutlet private weak var customAsteriskView: UIView!
    @IBOutlet weak var button: UIButton!

    func configure(title: String, subTitle: String, averageValue: String, targetRefValue: Double) {
        self.title.text = title.uppercased()
        self.subTitle.text = subTitle
        self.averageValue.text = averageValue
        self.targetRefValue.text = String(targetRefValue)
        self.targetRefValue.textColor = .accent
        self.bringSubview(toFront: button)
    }
    
    @IBAction func customizeTarget(_ sender: Any) {
        delegate?.showCustomizeTarget()
    }
}
