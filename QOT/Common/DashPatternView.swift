//
//  AddDashPattern.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/21/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class DashPatternView: UIView {

    private var borderLayer: CAShapeLayer?
    fileprivate var borderColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    fileprivate var fillColor: UIColor = .clear
    fileprivate var cornerRadius: CGFloat = 8
    fileprivate var lineWidth: CGFloat = 1

    init(borderColor: UIColor, fillColor: UIColor) {
        super.init(frame: CGRect.zero)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.layer.cornerRadius = cornerRadius
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func addBorderLayer() -> CAShapeLayer {

        let  borderLayer = CAShapeLayer()
        let frameSize = frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        borderLayer.bounds = shapeRect
        borderLayer.position = CGPoint(x: frameSize.width/2 + lineWidth, y: frameSize.height/2 + lineWidth)

        borderLayer.fillColor = fillColor.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineDashPattern = [6, 3]

        let newFrame = CGRect(x: 0, y: 0, width: shapeRect.width - 2 * lineWidth, height: shapeRect.height - 2 * lineWidth)
        let path = UIBezierPath.init(roundedRect: newFrame, cornerRadius: cornerRadius)
        borderLayer.path = path.cgPath
        
        return borderLayer
        
    }
}
