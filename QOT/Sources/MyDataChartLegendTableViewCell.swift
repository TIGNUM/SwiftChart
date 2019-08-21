//
//  MyDataChartLegendTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyDataChartLegendTableViewCell: UITableViewCell, Dequeueable {
    // MARK: - Properties
    
    @IBOutlet private weak var label: UILabel!

    func configure(labelString: String?) {
        guard let labelString = labelString else {
            return
        }
        label.attributedText = NSAttributedString(string: labelString.uppercased(),
                                                       letterSpacing: 0.16,
                                                       font: .sfProtextRegular(ofSize: 11),
                                                       lineSpacing: 9,
                                                       textColor: .sand60,
                                                       alignment: .left)
        
    }
}
