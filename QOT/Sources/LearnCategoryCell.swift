//
//  LearnCustomCell.swift
//  QOT
//
//  Created by Aamir Suhial on 3/20/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnCategoryCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    private var circleLineShape: CAGradientLayer?
    private var shapeDashLayer: CAShapeLayer?
    private var outerLayer: CAGradientLayer?
    private var percentageLearned = 0.0
    private var indexPath = IndexPath(item: 0, section: 0)

    private lazy var learnedContentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        layer.addGlowEffect(color: .white20)
        return label
    }()

    private lazy var performanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()

    private lazy var textContainerView: UIView = {
        let view = UIView()
        view.addSubview(learnedContentLabel)
        view.addSubview(titleLabel)
        view.addSubview(performanceLabel)
        contentView.addSubview(view)
        return view
    }()

    private var titleFont: UIFont {
        if UIDevice.isPad == true {
            return .H7Tag
        } else {
            return UIScreen.main.bounds.width > Layout.Device.iPhone5width ? .H4Identifier : .H7Tag
        }
    }

    private var percentageFont: UIFont {
        if UIDevice.isPad == true {
            return .H8Tag
        } else {
            return UIScreen.main.bounds.width > Layout.Device.iPhone5width ? .H7Tag : .H7Tag
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.width / 2
        contentView.layer.masksToBounds = true
        drawCircles(frame: frame)
    }

    private func drawCircles(frame: CGRect) {
        let frame = bounds
        applyGradient(frame: frame)
        drawInnerCircle(frame: frame)
        drawDashedCircle(frame: frame)
    }

    private func drawInnerCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.width / 2.2
        let start: CGFloat = 0.0
        let end = 2.0 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.40).cgColor]
        gradient.locations = [0.6, 1.0]
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        shape.lineWidth = 0.1
        shape.lineCap = kCALineCapRound
        circleLineShape?.removeFromSuperlayer()
        contentView.layer.addSublayer(gradient)
        circleLineShape = gradient
    }

    private func drawDashedCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.width / 2.2
        let start: CGFloat = (3 * CGFloat.pi ) / 2
        let end: CGFloat = 2.0 * CGFloat.pi * CGFloat(percentageLearned) + start
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 5.0
        layer.lineDashPattern = [1]
        layer.addGlowEffect(color: .white20)
        shapeDashLayer?.removeFromSuperlayer()
        contentView.layer.addSublayer(layer)
        shapeDashLayer = layer
    }

    func configure(with category: LearnCategoryListViewModel.Item, indexPath: IndexPath) {
        self.indexPath = indexPath
		let attributedTextCount = NSMutableAttributedString(string: "\(category.viewedCount) OUT OF \(category.itemCount)",
            letterSpacing: 2,
			font: percentageFont,
			lineSpacing: 2.5,
			textColor: .white60,
            alignment: .center)
        if percentageLearned != category.percentageLearned {
            percentageLearned = category.percentageLearned
            drawDashedCircle(frame: frame)
        }
        learnedContentLabel.attributedText = attributedTextCount
        titleLabel.attributedText = attributedString(text: category.titleShort, textColor: .white)
        performanceLabel.attributedText = attributedString(text: R.string.localized.learnContentPerformanceTitle(),
                                                           textColor: .white60)
    }

    private func applyGradient(frame: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.40).cgColor]
        gradient.locations = [0.6, 1.0]
        let shape = CAShapeLayer()
        let lineWidth: CGFloat = 2
        let frame = gradient.bounds
        let newFrame = CGRect(x: frame.minX + lineWidth, y: frame.minY + lineWidth, width: (frame.width - (2 * lineWidth)), height: (frame.height - (2 * lineWidth)))
        shape.path = UIBezierPath(roundedRect: newFrame, cornerRadius: frame.width / 2).cgPath
        shape.strokeColor = UIColor.brown.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        outerLayer?.removeFromSuperlayer()
        contentView.layer.addSublayer(gradient)
        outerLayer = gradient
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.insideCircle(frame: bounds)
    }
}

// MARK: - Private

private extension LearnCategoryCell {

    func setupLayout() {
        // textContainerView is subview connected to all sides
        textContainerView.verticalAnchors == contentView.verticalAnchors
        textContainerView.horizontalAnchors == contentView.horizontalAnchors

        // create layout guides
        let topGuide = UILayoutGuide()
        let bottomGuide = UILayoutGuide()
        textContainerView.addLayoutGuide(topGuide)
        textContainerView.addLayoutGuide(bottomGuide)

        // connect top guide to top
        topGuide.topAnchor == textContainerView.topAnchor
        topGuide.horizontalAnchors == textContainerView.horizontalAnchors

        // connect bottom guide to bottom
        bottomGuide.bottomAnchor == textContainerView.bottomAnchor
        bottomGuide.horizontalAnchors == textContainerView.horizontalAnchors

        // make them equal heights to center (y) the content inbetween
        topGuide.heightAnchor == bottomGuide.heightAnchor

        // configure the inbtween content
        performanceLabel.topAnchor == topGuide.bottomAnchor
        performanceLabel.leadingAnchor == textContainerView.leadingAnchor  + Layout.padding_20
        performanceLabel.trailingAnchor == textContainerView.trailingAnchor - Layout.padding_20

        titleLabel.topAnchor == performanceLabel.bottomAnchor
        titleLabel.leadingAnchor == textContainerView.leadingAnchor + Layout.padding_20
        titleLabel.trailingAnchor == textContainerView.trailingAnchor - Layout.padding_20

        learnedContentLabel.topAnchor == titleLabel.bottomAnchor + Layout.padding_07
        learnedContentLabel.horizontalAnchors == titleLabel.horizontalAnchors
        learnedContentLabel.bottomAnchor == bottomGuide.topAnchor
    }

    func attributedString(text: String, textColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text.uppercased(),
                                         letterSpacing: 1.1,
                                         font: titleFont,
                                         lineSpacing: 2,
                                         textColor: textColor,
                                         alignment: .center,
                                         lineBreakMode: .byWordWrapping)
    }
}
