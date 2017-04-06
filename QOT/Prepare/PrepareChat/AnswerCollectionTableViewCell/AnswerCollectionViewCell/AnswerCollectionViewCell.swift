//
//  AnswerCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.black
    }
}

extension UIView {
    func addDashedBorder(color: CGColor!, lineWidth: CGFloat) {

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size

        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
        self.layer.addSublayer(shapeLayer)

    }
}
