//
//  PrepareCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 07.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

class PrepareCollectionViewCell: UICollectionViewCell, Dequeueable {

    enum Style {
        case dashed
        case dashedSelected
        case plain
        case plainSelected
    }

    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

    fileprivate var currentShapeLayer: CAShapeLayer?

    override func prepareForReuse() {
        super.prepareForReuse()
        currentShapeLayer?.removeFromSuperlayer()
    }

    func setStyle(cellStyle: Style, name: String, display: ChoiceListDisplay) {

        var alignment: NSTextAlignment = .center
        switch display {
        case .flow:
            alignment = .center
            trailingConstraint.constant = 12
        case .list:
            alignment = .left
            trailingConstraint.constant = 25
        }

        titleLbl.prepareAndSetTextAttributes(text: name, font: UIFont(name: "BentonSans-Book", size: 16)!, alignment: alignment, lineSpacing: 7)
        titleLbl.textColor = .white60
        let borderColour = UIColor.greyish20
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        currentShapeLayer = shapeLayer
        let frame = CGRect(x: 2, y: 2, width: self.frame.size.width-2, height: self.frame.size.height-2)

        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = borderColour.cgColor

        switch cellStyle {
        case .dashed:
            shapeLayer.fillColor = UIColor.black40.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 10).cgPath
            shapeLayer.lineDashPattern = [4, 3]
        case .dashedSelected:
            shapeLayer.fillColor = UIColor.black40.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 10).cgPath
            titleLbl.textColor = UIColor.white
        case .plain:
            shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 30).cgPath
        case .plainSelected:
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 30).cgPath
        }
        
        layer.addSublayer(shapeLayer)
    }
}
