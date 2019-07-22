//
//  QuestionaireCellIndicator.swift
//  QOT
//
//  Created by Sanggeon Park on 13.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class QuestionaireCellIndicator: UIView {

    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var separatorWidth: NSLayoutConstraint!
    @IBOutlet weak private var separatorViewHeight: NSLayoutConstraint!

    var config = ControllerType.Config.myVision()

    var isCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 2.0
            separatorView.backgroundColor = config.currentIndexColor
        }
    }

    var isAboveCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 1.0
            separatorView.backgroundColor = config.aboveCurrentIndexColor
        }
    }

    var isBelowCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 1.0
            separatorView.backgroundColor = config.belowCurrentIndexColor
        }
    }

    var indicatorWidth: CGFloat = 8.0 {
        willSet {
            separatorWidth.constant = newValue
        }
    }
}
