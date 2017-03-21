//
//  LearnCustomCell.swift
//  QOT
//
//  Created by tignum on 3/20/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnCustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = frame.width / 2
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.white.cgColor
        
        backgroundColor = UIColor.clear
        // created a cicular thin line
        let circleLinePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(frame.width / 2.2), startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
        let circleLineShape = CAShapeLayer()
        circleLineShape.path = circleLinePath.cgPath
        circleLineShape.fillColor = UIColor.clear.cgColor
        circleLineShape.strokeColor = UIColor.lightGray.cgColor
        circleLineShape.lineWidth = 0.5
        circleLineShape.lineCap = kCALineCapRound
        contentView.layer.addSublayer(circleLineShape)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(frame.width / 2.2), startAngle: 0.0, endAngle: 2.0 * CGFloat.pi - 0.6, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineDashPattern = [1]
        contentView.layer.addSublayer(shapeLayer)
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
