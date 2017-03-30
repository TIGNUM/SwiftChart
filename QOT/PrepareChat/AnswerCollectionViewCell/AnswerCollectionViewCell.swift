//
//  AnswerCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 30.03.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addDashedBorder(color: UIColor.gray.cgColor, lineWidth: 2)
        self.contentView.backgroundColor = UIColor.black
    }

    func initWithTitle(title: String!)
    {
        self.titleLbl.text = title
    }
    
}

extension UIView {
    func addDashedBorder(color: CGColor!, lineWidth: CGFloat) {

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

        self.layer.addSublayer(shapeLayer)

    }
}
