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

// MARK: - Private Functions

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
        MyUniverseHelper.myWhySpikes(layout: layout).forEach { (spikeShapeLayer: CAShapeLayer) in
            layer.addSublayer(spikeShapeLayer)
        }
    }

    func addToBeVision(layout: Layout.MeSection, vision: Vision) {
        addSubview(footerLabel(with: vision.title, labelFrame: layout.myWhyVisionFooterFrame))
        addSubview(visionLabel(with: vision.text, labelFrame: layout.myWhyVisionLabelFrame))
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String, choices: [WeeklyChoice]) {
        let buttonOffset = Layout.MeSection.labelHeight * 1.3
        var xPos = layout.myWhyWeeklyChoicesFooterXPos + CGFloat(choices.count * choices.count)
        var yPos = layout.myWhyWeeklyChoicesFooterYPos - ((buttonOffset + 1) * CGFloat(choices.count))

        for (index, weeklyChoice) in choices.enumerated() {
            print("xPos: ", xPos, "yPos: ", yPos)
            let buttonFrame = CGRect(
                x: xPos,
                y: yPos,
                width: layout.viewControllerFrame.width * 0.33,
                height: Layout.MeSection.labelHeight * 1.125
            )
            addSubview(weeklyChoiceButton(title: weeklyChoice.text, frame: buttonFrame))
            yPos += (buttonOffset + 2)
            xPos -= CGFloat(index + 1) * 3
        }

        addSubview(footerLabel(with: title, labelFrame: layout.myWhyWeeklyChoicesFooterFrame))
    }

    func addPartners(layout: Layout.MeSection, title: String, partners: [Partner]) {
        let buttonOffset = layout.profileImageWidth * 0.4
        var xPos = layout.myWhyPartnersFooterXPos
        let yPos = layout.myWhyPartnersFooterYPos - buttonOffset

        partners.forEach { (partner: Partner) in
            let buttonFrame = CGRect(
                x: xPos,
                y: yPos,
                width: (layout.profileImageWidth * 0.4) * layout.myWhyPartnerScaleFactor,
                height: (layout.profileImageWidth * 0.4)
            )
            addSubview(partnerButton(title: partner.initials, image: partner.profileImage, frame: buttonFrame))
            xPos += buttonFrame.width + 4
        }
        addSubview(footerLabel(with: title, labelFrame: layout.myWhyPartnersFooterFrame))
    }
}

// MARK: - Buttons

private extension MyWhyView {

    func weeklyChoiceButton(title: String, frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Font.H7Tag
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitleColor(Color.MeSection.whiteLabel, for: .normal)
        button.setBackgroundImage(R.image.myWhyChoicesFrame(), for: .normal)
        button.addTarget(self, action: #selector(didTapWeeklyChoices), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.alpha = 0.8

        return button
    }

    func partnerButton(title: String?, image: UIImage?, frame: CGRect) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Font.H6NavigationTitle
        button.setTitleColor(Color.MeSection.whiteLabel, for: .normal)
        button.setBackgroundImage(R.image.myWhyPartnerFrame(), for: .normal)
        button.addTarget(self, action: #selector(didTapPartner), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        return button

    }
}

// MARK: - Actions

private extension MyWhyView {

    @objc func didTapWeeklyChoices() {
        print("didTapWeeklyChoices")
    }

    @objc func didTapPartner() {
        print("didTapPartner")
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
