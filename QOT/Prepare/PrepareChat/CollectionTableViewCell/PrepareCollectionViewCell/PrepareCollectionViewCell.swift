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
        // Initialization code
    }

    func setStyle(cellType: CellType, borderType: BorderType, lineWidth: CGFloat, selectedState: Bool, name: String) {

        self.titleLbl.text = name
        let borderColour = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.20)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeColor = borderColour.cgColor

        switch cellType {
        case .Input:
            if selectedState {
                shapeLayer.fillColor = UIColor.blue.cgColor
            } else {
                shapeLayer.fillColor = UIColor.clear.cgColor
            }
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30).cgPath
            break
        case .Navigation:
            if selectedState {
                shapeLayer.fillColor = UIColor.blue.cgColor
            } else {
                shapeLayer.fillColor = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.10).cgColor
            }
            shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
            if borderType == .DashedBorder {
                shapeLayer.lineDashPattern = [6, 3]
            }
        }
        self.layer.addSublayer(shapeLayer)
    }

    enum CellType: Int {
        case Input
        case Navigation
    }

    enum BorderType: Int {
        case DashedBorder
        case CleanBorder
    }
}
