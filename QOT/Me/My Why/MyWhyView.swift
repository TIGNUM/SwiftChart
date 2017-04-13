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
        addSubview(footerLabel(with: vision.title, labelFrame: layout.myWhyVisionFooterFrame))
        addSubview(visionLabel(with: vision.text, labelFrame: layout.myWhyVisionLabelFrame))
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String, choices: [WeeklyChoice]) {
        addSubview(footerLabel(with: title, labelFrame: layout.myWhyWeeklyChoicesFooterFrame))
    }

    func addPartners(layout: Layout.MeSection, title: String, partners: [Partner]) {
        addSubview(footerLabel(with: title, labelFrame: layout.myWhyPartnersFooterFrame))
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
