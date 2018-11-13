//
//  QuestionaireCellIndicator.swift
//  QOT
//
//  Created by Sanggeon Park on 13.11.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class QuestionaireCellIndicator: UIView {
    @IBOutlet weak private var inactiveCircle: UIView!
    @IBOutlet weak private var activeInnerCircle: UIView!
    @IBOutlet weak private var activeIconImageView: UIImageView!

    override func layoutSubviews() {
        super.layoutSubviews()
        var size = inactiveCircle.bounds.size
        inactiveCircle.layer.cornerRadius = size.width/2
        inactiveCircle.clipsToBounds = true

        size = activeInnerCircle.bounds.size
        activeInnerCircle.layer.cornerRadius = size.width/2
        activeInnerCircle.clipsToBounds = true
    }

    func setEnable(_ active: Bool, with color: UIColor) {
        inactiveCircle.isHidden = active == true ? true : false
        activeInnerCircle.isHidden = active != true ? true : false
        activeIconImageView.isHidden = active != true ? true : false
        inactiveCircle.backgroundColor = color
        activeInnerCircle.backgroundColor = color
        activeIconImageView.tintColor = color
    }
}
