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

    func addToBeVision(layout: Layout.MeSection, vision: Vision) {
        let shiftedXPos = layout.myWhyVisionFooterXPos
        let shiftedYPos = layout.myWhyVisionFooterYPos
        let footerLabelLabelFrame = CGRect(
            x: shiftedXPos,
            y: shiftedYPos,
            width: 0,
            height: Layout.MeSection.labelHeight
        )

        let visionLabelLabelFrame = CGRect(
            x: shiftedXPos,
            y: layout.viewControllerFrame.height * 0.25,
            width: layout.profileImageWidth * 2.25,
            height: Layout.MeSection.labelHeight
        )

        addSubview(footerLabel(with: vision.title, labelFrame: footerLabelLabelFrame))
        addSubview(visionLabel(with: vision.text, labelFrame: visionLabelLabelFrame))
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String, choices: [WeeklyChoice]) {
        let shiftedXPos = layout.myWhyWeeklyChoicesFooterXPos
        let shiftedYPos = layout.myWhyWeeklyChoicesFooterYPos
        let labelFrame = CGRect(x: shiftedXPos, y: shiftedYPos, width: 0, height: Layout.MeSection.labelHeight)

        addSubview(footerLabel(with: title, labelFrame: labelFrame))
    }

    func addPartners(layout: Layout.MeSection, title: String, partners: [Partner]) {
        let shiftedXPos = layout.myWhyPartnersFooterXPos
        let shiftedYPos = layout.myWhyPartnersFooterYPos
        let labelFrame = CGRect(x: shiftedXPos, y: shiftedYPos, width: 0, height: Layout.MeSection.labelHeight)

        addSubview(footerLabel(with: title, labelFrame: labelFrame))
    }
}

// MARK: - Labels

private extension MyWhyView {

    func footerLabel(with text: String, labelFrame: CGRect) -> UILabel {
        return label(with: text, labelFrame: labelFrame, textColor: Color.MeSection.whiteLabel, font: Font.H7Tag)
    }

    func visionLabel(with text: String, labelFrame: CGRect) -> UILabel {
        return label(with: text, labelFrame: labelFrame, textColor: .white, font: Font.H4Headline)
    }

    func label(with text: String, labelFrame: CGRect, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel(frame: labelFrame)
        label.text = text.uppercased()
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()

        return label
    }
}
