//
//  MyWhyView.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit

final class MyWhyView: PassthroughView, MyUniverseView {

    // MARK: - Properties

    var previousBounds = CGRect.zero
    let myWhyViewModel: MyWhyViewModel
    let screenType: MyUniverseViewController.ScreenType
    lazy var weeklyChoices = [WeeklyChoice]()
    lazy var partners = [Partner]()
    weak var delegate: MyWhyViewDelegate?
    var myToBeVisionBox: PassthroughView!
    var weeklyChoicesBox: PassthroughView!
    var qotPartnersBox: PassthroughView!
    private var myToBeVisionLabel: UILabel!
    private var myToBeVisionHeaderLabel: UILabel!
    private var weeklyChoiceButtons = [UIButton]()
    private var qotPartnersButtons = [UIButton]()
    private let fullViewFrame: CGRect
    private var updatesToken: Disposable?

    // MARK: - Init

    init(myWhyViewModel: MyWhyViewModel, frame: CGRect, screenType: MyUniverseViewController.ScreenType, delegate: MyWhyViewDelegate?) {
        self.myWhyViewModel = myWhyViewModel
        self.delegate = delegate
        self.screenType = screenType
        self.fullViewFrame = frame
        let viewRightMargin = Layout.MeSection(viewControllerFrame: frame).scrollViewOffset * 3.5

        let viewFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width - viewRightMargin, height: frame.height)
        super.init(frame: viewFrame)
        
        addGestureRecognizer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        cleanUpAndDraw()
        reload() // @warning reload after drawing else views won't be laid out
        
        if updatesToken == nil {
            updatesToken = myWhyViewModel.updates.observeNext { [weak self] (_: CollectionUpdate) in
                self?.reload()
            }
        }
    }

    func draw() {
        drawMyWhy(myWhyViewModel: myWhyViewModel, layout: Layout.MeSection(viewControllerFrame: self.fullViewFrame))
        layoutIfNeeded()
        drawMyWhyAfterDidLayoutSubviews()
    }

    // MARK: - Gesture Recognizer

    private func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMyToBeVision))
        addGestureRecognizer(tapGestureRecognizer)
    }

    deinit {
        updatesToken?.dispose()
    }
}

// MARK: - Private Functions

private extension MyWhyView {

    func reload() {
        myWhyViewModel.items?.forEach { (myWhy: MyWhyViewModel.MyWhy) in
            switch myWhy {
            case .vision(let vision):
                var visionHeadline = R.string.localized.meSectorMyWhyVisionHeadlinePlaceholder()
                var visionText = R.string.localized.meSectorMyWhyVisionMessagePlaceholder()
                if let vision = vision, let headline = vision.headline, let text = vision.text, text.isEmpty == false {
                    visionHeadline = headline
                    visionText = text
                }
                myToBeVisionHeaderLabel.setAttrText(text: visionHeadline.uppercased(),
                                                          font: Font.H6NavigationTitle,
                                                          lineSpacing: 3,
                                                          characterSpacing: 1)
                myToBeVisionLabel.setAttrText(text: visionText,
                                              font: Font.PTextSmall,
                                              lineSpacing: 7,
                                              characterSpacing: 1.73)
            case .weeklyChoices(_, let choices):
                weeklyChoices = choices
                for index in 0..<Layout.MeSection.maxWeeklyPage {
                    guard index < choices.count else {
                        return
                    }
                    let choice = choices[index]
                    let button = weeklyChoiceButtons[index]
                    button.setTitle(choice.title?.uppercased(), for: .normal)
                }
            case .partners(_, let partners):
                self.partners = Array(partners)
                for index in 0..<Layout.MeSection.maxPartners {
                    guard index < partners.count else {
                        return
                    }
                    let partner = partners[index]
                    let button = qotPartnersButtons[index]
                    button.configure(with: partner, index: index)
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
    
    func drawMyWhyAfterDidLayoutSubviews() {
        qotPartnersButtons.forEach { (button: UIButton) in
            button.applyHexagonMask()
        }
    }

    func drawSpikes(layout: Layout.MeSection) {
        MyUniverseHelper.myWhySpikes(layout: layout).forEach { (spikeShapeLayer: CAShapeLayer) in
            layer.addSublayer(spikeShapeLayer)
        }
    }

    func addToBeVision(layout: Layout.MeSection, vision: MyToBeVision?) {        
        myToBeVisionBox = PassthroughView()
        myToBeVisionBox.backgroundColor = .clear
        
        let footLabel = footerLabel(with: R.string.localized.meSectorMyWhyVisionTitle().uppercased())
        myToBeVisionBox.addSubview(footLabel)
        
        var visionHeadline = R.string.localized.meSectorMyWhyVisionHeadlinePlaceholder()
        var visionText = R.string.localized.meSectorMyWhyVisionMessagePlaceholder()
        if let vision = vision, let headline = vision.headline, let text = vision.text, !text.isEmpty {
            visionHeadline = headline
            visionText = text
        }
        myToBeVisionHeaderLabel = visionHeaderLabel(text: visionHeadline)
        myToBeVisionLabel = visionLabel(with: visionText)
        addSubview(myToBeVisionHeaderLabel)
        addSubview(myToBeVisionLabel)
        addSubview(myToBeVisionBox)
        myToBeVisionBox.topAnchor == topAnchor + 20
        myToBeVisionBox.leftAnchor == leftAnchor + 40
        myToBeVisionBox.rightAnchor == rightAnchor - 62
        myToBeVisionBox.heightAnchor == bounds.height * 0.325 + layout.myWhyDeviceOffset(screenType) + 30
        footLabel.heightAnchor == Layout.MeSection.labelHeight
        footLabel.leftAnchor == myToBeVisionBox.leftAnchor
        footLabel.rightAnchor == myToBeVisionBox.rightAnchor
        footLabel.bottomAnchor == myToBeVisionBox.bottomAnchor
        myToBeVisionLabel.leftAnchor == myToBeVisionBox.leftAnchor
        myToBeVisionLabel.rightAnchor == myToBeVisionBox.rightAnchor
        myToBeVisionLabel.bottomAnchor == footLabel.topAnchor - 8
        myToBeVisionHeaderLabel.leftAnchor == myToBeVisionBox.leftAnchor
        myToBeVisionHeaderLabel.rightAnchor == myToBeVisionBox.rightAnchor
        myToBeVisionHeaderLabel.bottomAnchor == myToBeVisionLabel.topAnchor - 8
        myToBeVisionHeaderLabel.topAnchor >= myToBeVisionBox.topAnchor + 8
    }

    func addWeeklyChoices(layout: Layout.MeSection, title: String, choices: [WeeklyChoice]) {
        weeklyChoicesBox = PassthroughView()
        weeklyChoicesBox.backgroundColor = .clear
        
        let max = Layout.MeSection.maxWeeklyPage

        var previousButton: UIButton?

        for index in 0..<max {
            var choice: WeeklyChoice?
            if index < choices.count {
                choice = choices[index]
            }

            let button = weeklyChoiceButton(title: choice?.title, index: index)
            weeklyChoiceButtons.append(button)
            weeklyChoicesBox.addSubview(button)

            button.widthAnchor == layout.viewControllerFrame.width * 0.33
            button.heightAnchor == Layout.MeSection.labelHeight * 1.125

            guard let topButton = previousButton else {

                button.topAnchor == weeklyChoicesBox.topAnchor
                button.rightAnchor == weeklyChoicesBox.rightAnchor - CGFloat(index + 1) * 2

                previousButton = button
                continue
            }

            button.topAnchor == topButton.bottomAnchor + 5
            button.rightAnchor == topButton.rightAnchor - CGFloat(index + 1) * 2

            previousButton = button
        }

        let weeklyChoicesFooterLabel = footerLabel(with: title)
        weeklyChoicesBox.addSubview(weeklyChoicesFooterLabel)
        addSubview(weeklyChoicesBox)

        if let lastButton = previousButton {
            weeklyChoicesFooterLabel.topAnchor == lastButton.bottomAnchor + 10
            weeklyChoicesFooterLabel.rightAnchor == lastButton.rightAnchor - CGFloat(max + 1) * 2
            weeklyChoicesFooterLabel.widthAnchor == layout.viewControllerFrame.width * 0.33
            weeklyChoicesFooterLabel.heightAnchor == Layout.MeSection.labelHeight
            weeklyChoicesFooterLabel.bottomAnchor == weeklyChoicesBox.bottomAnchor
        }

        weeklyChoicesBox.topAnchor == myToBeVisionBox.bottomAnchor + 10 + layout.myWhyDeviceOffset(screenType)
        weeklyChoicesBox.leftAnchor == self.leftAnchor
        weeklyChoicesBox.rightAnchor == self.rightAnchor - 30
    }

    func addPartners(layout: Layout.MeSection, title: String, partners: [Partner]) {
        qotPartnersBox = PassthroughView()
        qotPartnersBox.backgroundColor = .clear

        var previousButton: UIButton?

        for index in 0..<Layout.MeSection.maxPartners {
            var partner: Partner?
            if index < partners.count {
                partner = partners[index]
            }

            let button = UIButton()
            button.tag = index
            button.configure(with: partner, index: index)
            
            /*
             TODO:  For now we disable QOT Partners. Enable this bit when we need it.
             
            button.addTarget(self, action: #selector(didTapPartner), for: .touchUpInside)
            */
                        
            qotPartnersButtons.append(button)
            qotPartnersBox.addSubview(button)
            button.topAnchor == qotPartnersBox.topAnchor
            button.widthAnchor == (layout.profileImageWidth * 0.45) * layout.myWhyPartnerScaleFactor
            button.heightAnchor == (layout.profileImageWidth * 0.45)

            guard let leftButton = previousButton else {
                button.leftAnchor == qotPartnersBox.leftAnchor
                previousButton = button
                continue
            }

            button.leftAnchor == leftButton.rightAnchor + 7
            previousButton = button
        }

        let partnerFooterLabel = footerLabel(with: title)
        qotPartnersBox.addSubview(partnerFooterLabel)
        addSubview(qotPartnersBox)

        if qotPartnersButtons.count > 0 {
            let firstButton = qotPartnersButtons[0]

            partnerFooterLabel.leftAnchor == firstButton.leftAnchor
            partnerFooterLabel.rightAnchor == self.rightAnchor
            partnerFooterLabel.topAnchor == firstButton.bottomAnchor + 10
            partnerFooterLabel.bottomAnchor == qotPartnersBox.bottomAnchor
            addPartnersComingSoonLabel()
        }

        qotPartnersBox.topAnchor == weeklyChoicesBox.bottomAnchor + 12  + layout.myWhyDeviceOffset(screenType)
        qotPartnersBox.leftAnchor == self.leftAnchor
        qotPartnersBox.rightAnchor == self.rightAnchor
    }
    
    func addPartnersComingSoonLabel() {
        let comingSoonLabel = UILabel(frame: .zero)
        comingSoonLabel.setAttrText(text: R.string.localized.meChartCommingSoon().uppercased(),
                                    font: Font.PTextSubtitle,
                                    alignment: .center,
                                    lineSpacing: 2.5,
                                    characterSpacing: 2,
                                    color: .white)
        
        if
            let firstButton = qotPartnersButtons.first,
            let lastButton = qotPartnersButtons.last {
                qotPartnersBox.addSubview(comingSoonLabel)
                comingSoonLabel.leftAnchor == firstButton.leftAnchor
                comingSoonLabel.rightAnchor == lastButton.rightAnchor
                comingSoonLabel.centerYAnchor == firstButton.centerYAnchor
        }
    }
}

// MARK: - Buttons

private extension MyWhyView {

    func weeklyChoiceButton(title: String?, index: Index) -> UIButton {
        let button = UIButton()
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
}

// MARK: - Actions

private extension MyWhyView {

    @objc func didTapWeeklyChoices(sender: UIButton) {
        var selectedWeeklyChoice: WeeklyChoice? = nil
        if sender.tag < weeklyChoices.count {
            selectedWeeklyChoice = weeklyChoices[sender.tag]
        }

        delegate?.didTapWeeklyChoices(weeklyChoice: selectedWeeklyChoice, from: self)
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

    func footerLabel(with text: String) -> UILabel {
        return label(with: text, textColor: Color.MeSection.whiteLabel, font: Font.H7Tag)
    }

    func visionLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()
        label.setAttrText(text: text, font: Font.PTextSmall, lineSpacing: 7, characterSpacing: 1.73)
        
        return label
    }
    
    func visionHeaderLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()
        label.setAttrText(text: text.uppercased(), font: Font.H6NavigationTitle, lineSpacing: 3, characterSpacing: 1)
        
        return label
    }

    func label(with text: String, textColor: UIColor, font: UIFont, uppercase: Bool = true) -> UILabel {
        let label = UILabel()
        label.text = uppercase ? text.uppercased() : text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()

        return label
    }
}

private extension UIButton {

    func configure(with partner: Partner?, index: Index) {
        titleLabel?.font = Font.H6NavigationTitle
        setTitleColor(Color.MeSection.whiteLabel, for: .normal)
        setTitle(nil, for: .normal)
        setImage(comingSoonImage(index), for: .normal)
        backgroundColor = .whiteLight

        /*
         TODO:  For now we disable QOT Partners and using default assets.
                Enable this bit when we need it.
         
        if let partner = partner {
            if let imageResource = partner.profileImageResource, imageResource.isAvailable {
                setTitle(nil, for: .normal)
                setImageFromResource(imageResource)
            } else if partner.initials.isEmpty == false {
                setTitle(partner.initials.uppercased(), for: .normal)
                setImage(nil, for: .normal)
            }
        }
        */
    }
    
    private func comingSoonImage(_ index: Index) -> UIImage? {
        switch index {
        case 0: return R.image.partner_comingSoon_01()
        case 1: return R.image.partner_comingSoon_02()
        default: return R.image.partner_comingSoon_03()
        }
    }
}
