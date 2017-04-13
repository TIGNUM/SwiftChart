//
//  MyWhyView.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyWhyView: UIView {

    // MARK: - Properties

    var myWhyItems = [MyWhy]()
    var previousBounds = CGRect.zero

    init(myWhyItems: [MyWhy], frame: CGRect) {
        self.myWhyItems = myWhyItems

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard previousBounds.equalTo(bounds) == false else {
            return
        }

        cleanUp()
        previousBounds = bounds
        drawMyWhy(myWhyItems: myWhyItems, layout: Layout.MeSection(viewControllerFrame: bounds))
    }
}

// MARK: - Private Helpers / Clean View

private extension MyWhyView {

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}

// MARK: - Private Helpers

private extension MyWhyView {

    func drawMyWhy(myWhyItems: [MyWhy], layout: Layout.MeSection) {
        drawSpikes(layout: layout)
    }

    func drawSpikes(layout: Layout.MeSection) {
        MeSolarViewDrawHelper.myWhySpikes(layout: layout).forEach { (spikeShapeLayer: CAShapeLayer) in
            layer.addSublayer(spikeShapeLayer)
        }
    }
}
