//
//  BubblesView.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

struct Bubble {

    let shape: CAShapeLayer
    let type: SettingsBubblesModel.SettingsBubblesItem
}

protocol BubblesViewSelectionDelegate: class {

    func didTouchUp(settingsType: SettingsBubblesModel.SettingsBubblesItem, in view: BubblesView)
}

final class BubblesView: UIView {

    // MARK: - Properties

    private let bubble1 = CAShapeLayer()
    private let bubble2 = CAShapeLayer()
    private let bubble3 = CAShapeLayer()
    private let bubble4 = CAShapeLayer()
    private let bubble5 = CAShapeLayer()
    private let bubble1Label = UILabel()
    private let bubble2Label = UILabel()
    private let bubble3Label = UILabel()
    private let bubble4Label = UILabel()
    private let bubble5Label = UILabel()
    private var bubblesValues: [SettingsBubblesModel.SettingsBubblesItem] = []
    private var bubbles: [Bubble] = []
    var type: SettingsBubblesType?
    weak var selectionDelegate: BubblesViewSelectionDelegate!

    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }

    private var dividend: CGFloat {
        return UIDevice.isPad ? 1.2 : 1
    }

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        labelsLayout()
        setupHierarchy()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupBubblesInfo()
        setupBubbles()
        setupGestureRecognizer()
    }
}

// MARK: - Selection handling

private extension BubblesView {

    @objc func handleTap(recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: self)
        for bubble in bubbles {
            if let bubblePath = bubble.shape.path, bubblePath.contains(location) {
                selectionDelegate.didTouchUp(settingsType: bubble.type, in: self)
                return
            }
        }
    }
}

// MARK: - Layout

private extension BubblesView {

    func labelsLayout() {
        bubble1Label.textColor = .white
        bubble1Label.font = .H3Subtitle
        bubble1Label.adjustsFontSizeToFitWidth = true
        bubble1Label.numberOfLines = 0

        bubble2Label.textColor = .white
        bubble2Label.font = .H3Subtitle
        bubble2Label.adjustsFontSizeToFitWidth = true
        bubble2Label.numberOfLines = 0

        bubble3Label.textColor = .white
        bubble3Label.font = .H3Subtitle
        bubble3Label.adjustsFontSizeToFitWidth = true

        bubble4Label.textColor = .white
        bubble4Label.font = .H3Subtitle
        bubble4Label.adjustsFontSizeToFitWidth = true
        bubble4Label.numberOfLines = 0

        bubble5Label.textColor = .white
        bubble5Label.font = .H3Subtitle
        bubble5Label.adjustsFontSizeToFitWidth = true
        bubble5Label.numberOfLines = 0
    }
}

// MARK: - Bubbles setup

private extension BubblesView {

    func setupBubblesInfo() {
        type == .about ?
            (bubblesValues = SettingsBubblesModel.SettingsBubblesItem.aboutValues) :
            (bubblesValues = SettingsBubblesModel.SettingsBubblesItem.supportValues)
    }

    func setupHierarchy() {
        layer.addSublayer(bubble1Label.layer)
        layer.addSublayer(bubble2Label.layer)
        layer.addSublayer(bubble3Label.layer)
        layer.addSublayer(bubble4Label.layer)
        layer.addSublayer(bubble5Label.layer)
    }

    func setupGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapRecognizer)
    }

    func applyBubbleGradient(bubble: CAShapeLayer) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.white, UIColor.clear].map { $0.cgColor }
        gradient.locations = [0.3, 1.0]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.mask = bubble

        let bubbleGradient = CAShapeLayer()
        bubbleGradient.bounds = bubble.bounds
        bubbleGradient.path = bubble.path
        bubbleGradient.strokeColor = UIColor.brown.cgColor
        bubbleGradient.fillColor = UIColor(red: 0.10, green: 0.25, blue: 0.35, alpha: 1.0).cgColor

        gradient.mask = bubbleGradient
        bubbleGradient.opacity = 0.16
        layer.addSublayer(gradient)
    }

    func setupBubbles() {
        let bubble1centerPoint = CGPoint(x: centerPoint.x - 60, y: centerPoint.y + 115)
        bubble1.path = UIBezierPath.circlePath(center: bubble1centerPoint, radius: 90 / dividend).cgPath
        bubbles.append(Bubble(shape: bubble1, type: bubblesValues[0]))
        applyBubbleGradient(bubble: bubble1)

        let bubble2centerPoint = CGPoint(x: centerPoint.x + 60, y: centerPoint.y - 105)
        bubble2.path = UIBezierPath.circlePath(center: bubble2centerPoint, radius: 90 / dividend).cgPath
        bubbles.append(Bubble(shape: bubble2, type: bubblesValues[1]))
        applyBubbleGradient(bubble: bubble2)

        let bubble3centerPoint = CGPoint(x: centerPoint.x - 85, y: centerPoint.y - 45)
        bubble3.path = UIBezierPath.circlePath(center: bubble3centerPoint, radius: 60 / dividend).cgPath
        bubbles.append(Bubble(shape: bubble3, type: bubblesValues[2]))
        applyBubbleGradient(bubble: bubble3)

        let bubble4centerPoint = CGPoint(x: centerPoint.x + 95, y: centerPoint.y + 55)
        bubble4.path = UIBezierPath.circlePath(center: bubble4centerPoint, radius: 60 / dividend).cgPath
        bubbles.append(Bubble(shape: bubble4, type: bubblesValues[3]))
        applyBubbleGradient(bubble: bubble4)

        let bubble1LabelSize = CGSize(width: 140, height: 100)
        let bubble1LabelCenter = CGPoint(x: bubble1centerPoint.x - 70, y: bubble1centerPoint.y - 45)
        bubble1Label.frame = CGRect(origin: bubble1LabelCenter, size: bubble1LabelSize).integral
        bubble1Label.text = bubblesValues.first?.title

        let bubble2LabelSize = CGSize(width: 140, height: 100)
        let bubble2LabelCenter = CGPoint(x: bubble2centerPoint.x - 70, y: bubble2centerPoint.y - 45)
        bubble2Label.frame = CGRect(origin: bubble2LabelCenter, size: bubble2LabelSize).integral
        bubble2Label.text = bubblesValues[1].title

        let bubble3LabelSize = CGSize(width: 85, height: 70)
        let bubble3LabelCenter = CGPoint(x: bubble3centerPoint.x - 45, y: bubble3centerPoint.y - 35)
        bubble3Label.frame = CGRect(origin: bubble3LabelCenter, size: bubble3LabelSize).integral
        bubble3Label.text = bubblesValues[2].title

        let bubble4LabelSize = CGSize(width: 100, height: 70)
        let bubble4LabelCenter = CGPoint(x: bubble4centerPoint.x - 50, y: bubble4centerPoint.y - 35)
        bubble4Label.frame = CGRect(origin: bubble4LabelCenter, size: bubble4LabelSize).integral
        bubble4Label.text = bubblesValues[3].title

        if type == .about {
            let yBubblePadding: CGFloat = UIDevice.isPad ? 145 : 170
            let bubble5centerPoint = CGPoint(x: centerPoint.x - 85, y: centerPoint.y - yBubblePadding)
            bubble5.path = UIBezierPath.circlePath(center: bubble5centerPoint, radius: 50 / dividend).cgPath
            bubbles.append(Bubble(shape: bubble5, type: bubblesValues[4]))
            applyBubbleGradient(bubble: bubble5)

            let bubble5LabelSize = CGSize(width: 75, height: 50)
            let bubble5LabelCenter = CGPoint(x: bubble5centerPoint.x - 38, y: bubble5centerPoint.y - 25)
            bubble5Label.frame = CGRect(origin: bubble5LabelCenter, size: bubble5LabelSize).integral
            bubble5Label.text = bubblesValues[4].title
        }
    }
}
