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

    var isCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 2.0
            separatorView.backgroundColor = .redOrange
        }
    }

    var isAboveCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 1.0
            separatorView.backgroundColor = UIColor.redOrange.withAlphaComponent(0.4)
        }
    }

    var isBelowCurrentIndex: Bool = false {
        willSet {
            separatorViewHeight.constant = 1.0
            separatorView.backgroundColor = .accent40
        }
    }

    var indicatorWidth: CGFloat = 8.0 {
        willSet {
            separatorWidth.constant = newValue
        }
    }
}
