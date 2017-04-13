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

    var previousBounds = CGRect.zero
    var myWhyViewModel: MyWhyViewModel?

    init(myWhyViewModel: MyWhyViewModel, frame: CGRect) {
        self.myWhyViewModel = myWhyViewModel

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
        drawMyWhy(myWhyViewModel: myWhyViewModel, layout: Layout.MeSection(viewControllerFrame: bounds))
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

    func drawMyWhy(myWhyViewModel: MyWhyViewModel?, layout: Layout.MeSection) {
        drawSpikes(layout: layout)

        myWhyViewModel?.items.forEach { (myWhy: MyWhy) in
            switch myWhy {
            case .vision(let vision):
                addToBeVision(layout: layout, vision: vision)
            case .weeklyChoices(let title, let choices):
                addWeeklyChoices(layout: layout, title: title, choices: choices)
            case .partners(let title, let partners):
                addPartners(layout: layout, title: title, partners: partners)
            }
        }
    }

    func drawSpikes(layout: Layout.MeSection) {
        MeSolarViewDrawHelper.myWhySpikes(layout: layout).forEach { (spikeShapeLayer: CAShapeLayer) in
            layer.addSublayer(spikeShapeLayer)
        }
    }

    func addToBeVision(layout: Layout.MeSection, vision: Vision?) {
        let shiftedXPos = layout.myWhyVisionFooterXPos
        let shiftedYPos = layout.myWhyVisionFooterYPos
        let labelFrame = CGRect(x: shiftedXPos, y: shiftedYPos, width: 0, height: Layout.MeSection.labelHeight)

        addSubview(footerLabel(with: vision?.title, labelFrame: labelFrame))
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String?, choices: [WeeklyChoice]?) {
        let shiftedXPos = layout.myWhyWeeklyChoicesFooterXPos
        let shiftedYPos = layout.myWhyWeeklyChoicesFooterYPos
        let labelFrame = CGRect(x: shiftedXPos, y: shiftedYPos, width: 0, height: Layout.MeSection.labelHeight)

        addSubview(footerLabel(with: title, labelFrame: labelFrame))
    }

    func addPartners(layout: Layout.MeSection, title: String?, partners: [Partner]?) {
        let shiftedXPos = layout.myWhyPartnersFooterXPos
        let shiftedYPos = layout.myWhyPartnersFooterYPos
        let labelFrame = CGRect(x: shiftedXPos, y: shiftedYPos, width: 0, height: Layout.MeSection.labelHeight)

        addSubview(footerLabel(with: title, labelFrame: labelFrame))
    }

    func footerLabel(with text: String?, labelFrame: CGRect) -> UILabel {
        let label = UILabel(frame: labelFrame)

        guard let text = text else {
            assertionFailure("Footer Label text is nil!!!")
            return label
        }

        label.text = text.uppercased()
        label.textColor = Color.MeSection.whiteLabel
        label.font = Font.H7Tag
        label.sizeToFit()

        return label
    }
}
