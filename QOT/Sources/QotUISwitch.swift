//
//  QotUISwitch.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 12/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class QotUISwitch: UISwitch {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        ThemeSwitch.accent.apply(self)
    }
}
