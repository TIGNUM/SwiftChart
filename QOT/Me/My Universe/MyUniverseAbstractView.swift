//
//  MyUniverseAbstractView.swift
//  QOT
//
//  Created by karmic on 15.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyUniverseAbstractView: UIView {

    // MARK: - Properties

    internal var previousBounds = CGRect.zero

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        guard previousBounds.equalTo(bounds) == false else {
            return
        }

        cleanUp()
        previousBounds = bounds
    }
}

// MARK: - Clean View

extension MyUniverseAbstractView {

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}
