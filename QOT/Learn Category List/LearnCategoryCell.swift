//
//  LearnCustomCell.swift
//  QOT
//
//  Created by tignum on 3/20/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnCustomCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = frame.width / 2
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.white.cgColor
        
        backgroundColor = UIColor.clear
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2), radius: CGFloat(frame.width / 2.8), startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        //shapeLayer.lineWidth = 3.0
        //change the fill color
        //you can change the stroke color
        
        //shapeLayer.lineWidth = 8.0
        shapeLayer.lineWidth = 10.0
        shapeLayer.lineDashPattern = [2, 4]
        
        contentView.layer.addSublayer(shapeLayer)
//        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
