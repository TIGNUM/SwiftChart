//
//  MyWhyView.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyWhyView: UIView, MyUniverseView {

    // MARK: - Properties

    var previousBounds = CGRect.zero
    let myWhyViewModel: MyWhyViewModel
    let screenType: MyUniverseViewController.ScreenType
    lazy var weeklyChoices = [WeeklyChoice]()
    lazy var partners = [PartnerWireframe]()
    weak var delegate: MyWhyViewDelegate?
    var myToBeVisionBox: PassthroughView!
    var weeklyChoicesBox: PassthroughView!
    var qotPartnersBox: PassthroughView!
    fileprivate var hasBeenDrawn: Bool = false
    fileprivate var myToBeVisionLabel: UILabel!
    fileprivate var weeklyChoiceButtons = [UIButton]()
    fileprivate var qotPartnersButtons = [UIButton]()

    // MARK: - Init

    init(myWhyViewModel: MyWhyViewModel, frame: CGRect, screenType: MyUniverseViewController.ScreenType, delegate: MyWhyViewDelegate?) {
        self.myWhyViewModel = myWhyViewModel
        self.delegate = delegate
        self.screenType = screenType

        super.init(frame: frame)
        
        _ = myWhyViewModel.updates.observeNext { [weak self] (_: CollectionUpdate) in
            guard let `self` = self else { return }
            if self.hasBeenDrawn {
                self.reload()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        cleanUpAndDraw()
        hasBeenDrawn = true
    }

    func draw() {
        drawMyWhy(myWhyViewModel: myWhyViewModel, layout: Layout.MeSection(viewControllerFrame: bounds))
        addGestureRecognizer()
    }

    // MARK: - Gesture Recognizer

    private func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMyToBeVision))
        addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - Private Functions

private extension MyWhyView {

    func reload() {
        myWhyViewModel.items?.forEach { (myWhy: MyWhyViewModel.MyWhy) in
            switch myWhy {
            case .vision(let vision):
                // TODO: localise
                var visionText = "Your vision - what inspires you?"
                if let vision = vision, let text = vision.text, !text.isEmpty {
                    visionText = text
                }
                myToBeVisionLabel.text = visionText
            case .weeklyChoices(_, let choices):
                weeklyChoices = choices
                for index in 0..<Layout.MeSection.maxWeeklyPage {
                    var choice: WeeklyChoice?
                    if index < choices.count {
                        choice = choices[index]
                    }
                    weeklyChoiceButtons[index].setTitle(choice?.title?.uppercased(), for: .normal)
                }
            case .partners(_, let partners):
                self.partners = Array(partners)
                for index in 0..<Layout.MeSection.maxPartners {
                    var partner: Partner?
                    if index < partners.count {
                        partner = partners[index]
                    }
                    qotPartnersButtons[index].setTitle((partner?.profileImage == nil ? partner?.initials.uppercased() : nil), for: .normal)
                    qotPartnersButtons[index].setImage(partner?.profileImage, for: .normal)
                    qotPartnersButtons[index].imageView?.setupHexagonImageView()
                }
            }
        }
    }
    
    func drawMyWhy(myWhyViewModel: MyWhyViewModel, layout: Layout.MeSection) {
        drawSpikes(layout: layout)
        myWhyViewModel.items?.forEach { (myWhy: MyWhyViewModel.MyWhy) in
            switch myWhy {
            case .vision(let vision):
                addToBeVision(layout: layout, vision: vision)
            case .weeklyChoices(let title, let choices):
                weeklyChoices = choices
                addWeeklyChoices(layout: layout, title: title, choices: choices)
            case .partners(let title, let partners):
                self.partners = Array(partners)
                addPartners(layout: layout, title: title, partners: self.partners)
            }
        }
    }

    func drawSpikes(layout: Layout.MeSection) {
        MyUniverseHelper.myWhySpikes(layout: layout).forEach { (spikeShapeLayer: CAShapeLayer) in
            layer.addSublayer(spikeShapeLayer)
        }
    }

    func addToBeVision(layout: Layout.MeSection, vision: MyToBeVision?) {        
        myToBeVisionBox = PassthroughView(frame: bounds)
        myToBeVisionBox.backgroundColor = .clear
        
        let footLabel = footerLabel(with: R.string.localized.meSectorMyWhyVisionTitle().uppercased(), labelFrame: layout.myWhyVisionFooterFrame(screenType))
        myToBeVisionBox.addSubview(footLabel)
        
        //TODO: frame based views are now a bit old-school!
        var visionText = "Your vision - what inspires you?"
        if let vision = vision, let text = vision.text, !text.isEmpty {
            visionText = text
        }
        let visLabel = visionLabel(with: visionText, labelFrame: .zero, screenType)
        let stackView = UIStackView(arrangedSubviews: [visLabel])
        stackView.alignment = .bottom
        stackView.spacing = 0.0
        stackView.frame = CGRect(
            x: footLabel.frame.origin.x,
            y: 20.0,
            width: layout.myWhyVisionLabelFrame(screenType).width - 10.0,
            height: (footLabel.frame.origin.y - 30.0)
        )
        myToBeVisionBox.addSubview(stackView)
        addSubview(myToBeVisionBox)
        myToBeVisionLabel = visLabel
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String, choices: [WeeklyChoice]) {
        weeklyChoicesBox = PassthroughView(frame: bounds)
        weeklyChoicesBox.backgroundColor = .clear
        
        let max = Layout.MeSection.maxWeeklyPage
        let buttonOffset = Layout.MeSection.labelHeight * 1.3
        var xPos = layout.myWhyWeeklyChoicesFooterXPos + CGFloat(max * max)
        var yPos = layout.myWhyWeeklyChoicesFooterYPos - ((buttonOffset + 1) * CGFloat(max))

        for index in 0..<max {
            var choice: WeeklyChoice?
            if index < choices.count {
                choice = choices[index]
            }
            let buttonFrame = CGRect(
                x: xPos,
                y: yPos,
                width: layout.viewControllerFrame.width * 0.33,
                height: Layout.MeSection.labelHeight * 1.125
            )
            
            let button = weeklyChoiceButton(title: choice?.title, frame: buttonFrame, index: index)
            weeklyChoiceButtons.append(button)
            weeklyChoicesBox.addSubview(button)
            yPos += (buttonOffset + 2)
            xPos -= CGFloat(index + 1) * 2
        }

        weeklyChoicesBox.addSubview(footerLabel(with: title, labelFrame: layout.myWhyWeeklyChoicesFooterFrame))
        addSubview(weeklyChoicesBox)
    }

    func addPartners(layout: Layout.MeSection, title: String, partners: [PartnerWireframe]) {
        qotPartnersBox = PassthroughView(frame: bounds)
        qotPartnersBox.backgroundColor = .clear
        
        let buttonOffset = layout.profileImageWidth * 0.4
        var xPos = layout.myWhyPartnersFooterXPos
        let yPos = layout.myWhyPartnersFooterYPos - buttonOffset

        for index in 0..<Layout.MeSection.maxPartners {
            var partner: PartnerWireframe?
            if index < partners.count {
                partner = partners[index]
            }
            let buttonFrame = CGRect(
                x: xPos,
                y: yPos,
                width: (layout.profileImageWidth * 0.4) * layout.myWhyPartnerScaleFactor,
                height: (layout.profileImageWidth * 0.4)
            )
            
            let button = partnerButton(title: partner?.initials, frame: buttonFrame, profileImage: partner?.profileImage, index: index)
            qotPartnersButtons.append(button)
            qotPartnersBox.addSubview(button)
            xPos += buttonFrame.width + 4
        }
        qotPartnersBox.addSubview(footerLabel(with: title, labelFrame: layout.myWhyPartnersFooterFrame))
        addSubview(qotPartnersBox)
    }
}

// MARK: - Buttons

private extension MyWhyView {

    func weeklyChoiceButton(title: String?, frame: CGRect, index: Index) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle(title ?? "", for: .normal)
        button.titleLabel?.font = Font.H7Tag
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.setTitleColor(Color.MeSection.whiteLabel, for: .normal)
        button.setBackgroundImage(R.image.myWhyChoicesFrame(), for: .normal)        
        button.addTarget(self, action: #selector(didTapWeeklyChoices), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.alpha = 0.8
        button.tag = index

        return button
    }

    func partnerButton(title: String?, frame: CGRect, profileImage: UIImage?, index: Index) -> UIButton {
        let button = UIButton(frame: frame)
        button.setTitle((profileImage == nil ? title : nil), for: .normal)
        button.titleLabel?.font = Font.H6NavigationTitle
        button.setTitleColor(Color.MeSection.whiteLabel, for: .normal)
        button.setBackgroundImage(R.image.myWhyPartnerFrame(), for: .normal)
        button.addTarget(self, action: #selector(didTapPartner), for: .touchUpInside)
        button.setImage(profileImage, for: .normal)
        button.imageView?.setupHexagonImageView()
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index

        return button
    }
}

// MARK: - Actions

private extension MyWhyView {

    @objc func didTapWeeklyChoices(sender: UIButton) {
        guard sender.tag < weeklyChoices.count else {
            return
        }
        delegate?.didTapWeeklyChoices(weeklyChoice: weeklyChoices[sender.tag], from: self)
    }

    @objc func didTapPartner(sender: UIButton) {
        delegate?.didTapQOTPartner(selectedIndex: sender.tag, partners: partners, from: self)
    }

    @objc func didTapMyToBeVision() {
        delegate?.didTapMyToBeVision(vision: myWhyViewModel.myToBeVision, from: self)
    }
}

// MARK: - Labels

private extension MyWhyView {

    func footerLabel(with text: String, labelFrame: CGRect) -> UILabel {
        return label(with: text, labelFrame: labelFrame, textColor: Color.MeSection.whiteLabel, font: Font.H7Tag)
    }

    func visionLabel(with text: String, labelFrame: CGRect, _ screenType: MyUniverseViewController.ScreenType) -> UILabel {
        switch screenType {
        case .big: return label(with: text, labelFrame: labelFrame, textColor: .white, font: Font.H4Headline)
        case .medium: return label(with: text, labelFrame: labelFrame, textColor: .white, font: Font.H5SecondaryHeadline)
        case .small: return label(with: text, labelFrame: labelFrame, textColor: .white, font: Font.H6NavigationTitle)
        }
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
