//
//  NewDailyBriefTableViewHeader.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 06/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class NewDailyBriefTableViewHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    typealias actionClosure = (() -> Void)
    private var actionLeft: actionClosure?
    private var actionRight: actionClosure?

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    @objc func didTapLeft() {
        actionLeft?()
    }

    @objc func didTapRight() {
        actionRight?()
    }

    public func configure(tapLeft: actionClosure?, tapRight: actionClosure?) {
        actionLeft = tapLeft
        actionRight = tapRight
        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }
}
