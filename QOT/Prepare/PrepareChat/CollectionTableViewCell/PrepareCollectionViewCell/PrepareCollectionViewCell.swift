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
        let frame = CGRect(x: 2, y: 2, width: self.frame.size.width-2, height: self.frame.size.height-2)

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = borderColour.cgColor

        switch cellStyle {
        case .dashed:
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
            shapeLayer.lineDashPattern = [6, 3]
            break

        case .dashedSelected:
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 12).cgPath
            shapeLayer.lineDashPattern = [6, 3]
            break

        case .plain:
            shapeLayer.fillColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.10).cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 30).cgPath
            break

        case .plainSelected:
            shapeLayer.fillColor = UIColor.blue.cgColor
            shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 30).cgPath
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
