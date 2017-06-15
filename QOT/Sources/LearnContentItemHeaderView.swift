//
//  LearnContentItemHeaderView.swift
//  QOT
//
//  Created by karmic on 14.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemHeaderView: UIView {

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subTitleLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var subTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var subTitleLabelBottomConstraint: NSLayoutConstraint!

    lazy var viewHeight: CGFloat = {
        return CGFloat(
            self.titleLabel.frame.height +
            self.titleLabelTopConstraint.constant +
            self.subTitleLabelTopConstraint.constant +
            self.subTitleLabelBottomConstraint.constant
        )
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView(title: NSAttributedString, subtitle: NSAttributedString) {        
        titleLabel.attributedText = title
        subTitleLabel.attributedText = subtitle
        backgroundColor = .white
        titleLabel.sizeToFit()
    }
}
