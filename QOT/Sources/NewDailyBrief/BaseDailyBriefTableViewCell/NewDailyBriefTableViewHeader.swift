//
//  NewDailyBriefTableViewHeader.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 06/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class NewDailyBriefTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    typealias ActionClosure = (() -> Void)
    private var actionLeft: ActionClosure?
    private var actionRight: ActionClosure?

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc func didTapLeft() {
        actionLeft?()
    }

    @objc func didTapRight() {
        actionRight?()
    }

    public func configure(tapLeft: ActionClosure?, tapRight: ActionClosure?) {
        actionLeft = tapLeft
        actionRight = tapRight
        ThemeText.navigationBarHeader.apply(AppTextService.get(.daily_brief_section_header_title), to: titleLabel)
        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }
}
