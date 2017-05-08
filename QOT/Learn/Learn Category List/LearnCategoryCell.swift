//
//  LearnCustomCell.swift
//  QOT
//
//  Created by Aamir Suhial on 3/20/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnCategoryCell: UICollectionViewCell {

    // MARK: - Properties

    private var circleLineShape: CAShapeLayer?
    private var shapeDashLayer: CAShapeLayer?
    private var percentageLearned = 0.0

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2

        return label
    }()
    
    fileprivate lazy var contentCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)

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
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = frame.width / 2
        drawCircles(frame: frame)
    }
    
    private func drawCircles(frame: CGRect) {
        let frame = bounds
        drawInnerCircle(frame: frame)
        drawDashedCircle(frame: frame)
    }
    
    private func drawInnerCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = CGFloat(frame.width / 2.2)
        let start: CGFloat = 0.0
        let end = 2.0 * CGFloat.pi
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 0.5
        layer.lineCap = kCALineCapRound
        
        self.circleLineShape?.removeFromSuperlayer()
        contentView.layer.addSublayer(layer)
        self.circleLineShape = layer
    }
    
    private func drawDashedCircle(frame: CGRect) {
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let radius = frame.width / 2.2
        let start: CGFloat = 0.0
        let end = 2.0 * CGFloat.pi * CGFloat(percentageLearned)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 6.0
        layer.lineDashPattern = [1]
        
        shapeDashLayer?.removeFromSuperlayer()
        contentView.layer.addSublayer(layer)
        shapeDashLayer = layer
    }
    
    func configure(with category: LearnContentCategory) {
        titleLabel.text =  category.title
        contentCountLabel.text = "\(category.viewedCount)/\(category.itemCount)"
        
        let percentageLearned = category.percentageLearned
        if percentageLearned != self.percentageLearned {
            self.percentageLearned = percentageLearned
            setNeedsLayout()
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.insideCircle(frame: bounds)
    }
}

private extension LearnCategoryCell {
    func setupLayout() {
        textContainerView.horizontalAnchors == contentView.horizontalAnchors + 20
        textContainerView.centerAnchors == contentView.centerAnchors
        
        contentCountLabel.topAnchor == textContainerView.topAnchor
        contentCountLabel.horizontalAnchors == textContainerView.horizontalAnchors
        contentCountLabel.bottomAnchor == titleLabel.topAnchor
        
        titleLabel.horizontalAnchors == textContainerView.horizontalAnchors
        titleLabel.bottomAnchor == textContainerView.bottomAnchor
    }
}

extension LearnCategoryCell: Dequeueable {}
