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

    fileprivate var currentShapeLayer: CAShapeLayer?

    override func prepareForReuse() {
        super.prepareForReuse()
        currentShapeLayer?.removeFromSuperlayer()
    }

    func setStyle(cellStyle: Style, name: String, display: ChoiceListDisplay) {

        switch display {
        case .flow:
            titleLbl.numberOfLines = 1
            titleLbl.lineBreakMode = .byTruncatingTail
            titleLbl.textAlignment = .center
        case .list:
            titleLbl.numberOfLines = 0
            titleLbl.lineBreakMode = .byWordWrapping
            titleLbl.textAlignment = .right
        }

        titleLbl.text = name
        let borderColour = UIColor.white.withAlphaComponent(0.2)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        currentShapeLayer = shapeLayer
        let frame = CGRect(x: 2, y: 2, width: self.frame.size.width-2, height: self.frame.size.height-2)

        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = borderColour.cgColor

        switch cellStyle {
        case .dashed:
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
            shapeLayer.lineDashPattern = [6, 3]
        case .dashedSelected:
            shapeLayer.fillColor = UIColor.white20.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
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
