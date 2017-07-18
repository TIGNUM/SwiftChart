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
    fileprivate lazy var contentCountLabel = UILabel()
    fileprivate var indexPath = IndexPath(item: 0, section: 0)
    fileprivate var leftMarginConstraint: NSLayoutConstraint!
    fileprivate var rightMarginConstraint: NSLayoutConstraint!
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    fileprivate lazy var textContainerView: UIView = {
        let view = UIView()
        view.addSubview(self.titleLabel)
        view.addSubview(self.contentCountLabel)
        self.contentView.addSubview(view)

        return view
    }()

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
    
    override func updateConstraints() {
        let margin = contentView.bounds.width * (1.0 / 9.0)
        leftMarginConstraint.constant = margin
        rightMarginConstraint.constant = -margin
        
        super.updateConstraints()
    }

    private func drawCircles(frame: CGRect) {
        let frame = bounds
        applyGradient(frame: frame)
        drawInnerCircle(frame: frame)
        drawDashedCircle(frame: frame)
    }

    private func drawInnerCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.width / 2.3
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

        self.circleLineShape?.removeFromSuperlayer()
        contentView.layer.addSublayer(gradient)
        self.circleLineShape = gradient
    }

    private func drawDashedCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.width / 2.3
        let start: CGFloat = (3 * CGFloat.pi ) / 2
        let end: CGFloat = 2.0 * CGFloat.pi * CGFloat(percentageLearned) + start
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 6.0
        layer.lineDashPattern = [1]
        layer.addGlowEffect(color: UIColor.white)

        shapeDashLayer?.removeFromSuperlayer()
        contentView.layer.addSublayer(layer)
        shapeDashLayer = layer

    }

    func configure(with category: LearnCategoryListViewModel.Item, indexPath: IndexPath) {
        self.indexPath = indexPath
        let attributedTextTitle = NSMutableAttributedString(
            string: category.title.uppercased(),
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 2.5,
            textColor: .white60,
            lineBreakMode: .byTruncatingTail
        )
        let attributedTextCount = NSMutableAttributedString(
            string: "\(category.viewedCount)/\(category.itemCount)",
            letterSpacing: -1.1,
            font: Font.H3Subtitle,
            lineSpacing: 2
        )
        titleLabel.attributedText = attributedTextTitle
        contentCountLabel.attributedText = attributedTextCount
        let percentageLearned = category.percentageLearned

        if percentageLearned != self.percentageLearned {
            self.percentageLearned = percentageLearned
            setNeedsLayout()
        }
    }

    private func applyGradient(frame: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.40).cgColor]
        gradient.locations = [0.6, 1.0]

        let shape = CAShapeLayer()
        let lineWidth: CGFloat = 2
        let frame = gradient.bounds
        let newFrame = CGRect(x: frame.minX + lineWidth, y: frame.minY + lineWidth, width: frame.width - 2 * lineWidth, height: frame.height - 2 * lineWidth)
        shape.path = UIBezierPath(roundedRect: newFrame, cornerRadius: frame.width / 2).cgPath
        shape.strokeColor = UIColor.brown.cgColor
        shape.fillColor = UIColor.clear.cgColor

        gradient.mask = shape

        self.outerLayer?.removeFromSuperlayer()
        contentView.layer.addSublayer(gradient)
        outerLayer = gradient
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.insideCircle(frame: bounds)
    }
}

private extension LearnCategoryCell {

    func setupLayout() {
        textContainerView.topAnchor == contentView.topAnchor
        textContainerView.leadingAnchor == contentView.leadingAnchor
        textContainerView.trailingAnchor == contentView.trailingAnchor
        textContainerView.bottomAnchor == contentView.bottomAnchor
        
        leftMarginConstraint = contentCountLabel.leadingAnchor == contentView.leadingAnchor
        rightMarginConstraint = contentCountLabel.trailingAnchor == contentView.trailingAnchor
        contentCountLabel.bottomAnchor == titleLabel.topAnchor

        titleLabel.leftAnchor == contentCountLabel.leftAnchor
        titleLabel.rightAnchor == contentCountLabel.rightAnchor
        titleLabel.centerYAnchor == contentView.centerYAnchor + 15.0
    }
}
