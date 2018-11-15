//
//  LearnContentItemHeaderView.swift
//  QOT
//
//  Created by karmic on 14.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnContentItemHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var subTitleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var subTitleLabelBottomConstraint: NSLayoutConstraint!

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

    class func fromXib(contentTitle: String, categoryTitle: String) -> LearnContentItemHeaderView {
        let nib = R.nib.learnContentItemHeaderView()
        let headerView = (nib.instantiate(withOwner: self, options: nil).first as? LearnContentItemHeaderView)!
        headerView.setupView(title: contentTitle, subtitle: categoryTitle)
        headerView.backgroundColor = .nightModeBackground
        return headerView
    }

    func setupView(title: String, subtitle: String) {
        titleLabel.attributedText = Style.postTitle(title.uppercased(), .nightModeMainFont).attributedString()
        subTitleLabel.attributedText = Style.tag(subtitle.uppercased(), .nightModeSubFont).attributedString()
        backgroundColor = .clear
        layoutIfNeeded()
    }
}
