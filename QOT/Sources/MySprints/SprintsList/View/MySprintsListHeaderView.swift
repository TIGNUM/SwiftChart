//
//  MySprintsListHeaderView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 16/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MySprintsListHeaderView: UIView {

    @IBOutlet private weak var titleLabel: UILabel!

    static func instantiateFromNib(title: String, isActive: Bool) -> MySprintsListHeaderView {
        guard let headerView = R.nib.mySprintsListHeaderView.instantiate(withOwner: self).first as? MySprintsListHeaderView else {
            fatalError("Cannot load header view")
        }
        headerView.configure(title: title, isActive: isActive)
        return headerView
    }

    func configure(title: String, isActive: Bool) {
        titleLabel.attributedText = NSAttributedString(string: title, attributes: [.kern: 0.2])
        self.backgroundColor = (isActive ? .carbonNew : .clear)
    }
}
