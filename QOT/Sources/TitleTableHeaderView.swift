//
//  TitleHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class TitleTableHeaderView: UITableViewHeaderFooterView, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    struct Config {
        var backgroundColor: UIColor
        var font: UIFont
        var textColor: UIColor
        
        init(backgroundColor: UIColor = UIColor.carbon,
             font: UIFont = UIFont.sfProTextMedium(ofSize: FontSize.fontSize14),
             textColor: UIColor = UIColor.sand30) {
            self.backgroundColor = backgroundColor
            self.font = font
            self.textColor = textColor
        }
    }
    
    var title: String = "" {
        willSet {
            titleLabel.text = newValue
        }
    }
    
    var config: Config? {
        willSet {
            titleLabel.textColor = newValue?.textColor
            titleLabel.font = newValue?.font
            containerView.backgroundColor = newValue?.backgroundColor
        }
    }
}
