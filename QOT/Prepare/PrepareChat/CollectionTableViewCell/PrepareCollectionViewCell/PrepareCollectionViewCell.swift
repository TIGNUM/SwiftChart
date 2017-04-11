//
//  PrepareCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 07.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class PrepareCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setStyle(cellStyle: Style, name: String) {

        self.titleLbl.text = name
        let borderColour = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.20)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = borderColour.cgColor

        switch cellStyle {
        case .dashed:
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30).cgPath
            shapeLayer.lineDashPattern = [6, 3]
            break
        case .dashedSelected:
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30).cgPath
            shapeLayer.lineDashPattern = [6, 3]
            break

        case .plain:
            shapeLayer.fillColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.10).cgColor
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
            break

        case .plainSelected:
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
            break
        }
        self.layer.addSublayer(shapeLayer)
    }

    enum Style {
        case dashed
        case dashedSelected
        case plain
        case plainSelected
    }
}
