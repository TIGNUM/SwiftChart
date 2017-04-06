//
//  AnswerCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class NavigationCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.black
    }
}

extension UIView {
    func addDashedBorder( lineWidth: CGFloat) {

        let borderColour = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.20)
        let cellBackgroundColour = UIColor(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.10)
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor =  cellBackgroundColour.cgColor
        shapeLayer.strokeColor = borderColour.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinMiter
        shapeLayer.lineDashPattern = [6, 3]
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
