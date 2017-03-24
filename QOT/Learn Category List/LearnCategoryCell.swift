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
    
    private var circleLineShape: CAShapeLayer?
    private var shapeDashLayer: CAShapeLayer?
    private var percentageLearned = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        
        backgroundColor = UIColor.clear
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.width / 2
        drawCircle(frame: frame)
    }
    
    func drawCircle(frame: CGRect) {
        self.circleLineShape?.removeFromSuperlayer()
        self.shapeDashLayer?.removeFromSuperlayer()
        
        let circleLinePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(frame.width / 2.2), startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
        let circleLineShape = CAShapeLayer()
        circleLineShape.path = circleLinePath.cgPath
        circleLineShape.fillColor = UIColor.clear.cgColor
        circleLineShape.strokeColor = UIColor.lightGray.cgColor
        circleLineShape.lineWidth = 0.5
        circleLineShape.lineCap = kCALineCapRound
        contentView.layer.addSublayer(circleLineShape)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(frame.width / 2.2), startAngle: 0.0, endAngle: 2.0 * CGFloat.pi * CGFloat(percentageLearned), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineDashPattern = [1]
        contentView.layer.addSublayer(shapeLayer)
        
        self.circleLineShape = circleLineShape
        self.shapeDashLayer = shapeLayer
    }
    
    func configure(with category: LearnCategory) {
        titleLabel.text =  category.title
        contentCountLabel.text = "\(category.viewedCount)/\(category.itemCount)"
        
        let percentageLearned = category.percentageLearned
        if percentageLearned != self.percentageLearned {
            self.percentageLearned = percentageLearned
            setNeedsLayout()
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let path = circleLineShape?.path else {
            preconditionFailure("Missing path")
        }
        return path.contains(point)
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
