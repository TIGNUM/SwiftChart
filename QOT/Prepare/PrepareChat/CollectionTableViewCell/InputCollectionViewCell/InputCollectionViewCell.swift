//
//  InputCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 06.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class InputCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
    }
}

extension UIView {
    func addBorder( lineWidth: CGFloat) {

        let borderColour = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.20)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor =  UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColour.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 35).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
