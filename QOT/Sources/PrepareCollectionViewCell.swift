//
//  PrepareCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 07.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PrepareCollectionViewCell: UICollectionViewCell, Dequeueable {

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
        trailingConstraint.constant = display == .flow ? 12 : 25
        titleLbl.prepareAndSetTextAttributes(text: name, font: Font.DPText, alignment: .left, lineSpacing: 7, characterSpacing: 0.3, color: cellStyle == .dashedSelected ? .white : .white60)
        let shapeLayer = CAShapeLayer()
        let cornerRadius: CGFloat = cellStyle == .dashed || cellStyle == .dashedSelected ? 10 : 30
        currentShapeLayer = shapeLayer
        let frame = CGRect(x: 2, y: 2, width: self.frame.size.width-2, height: self.frame.size.height-2)
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width/2, y: frame.height/2)
        shapeLayer.lineWidth = 1
        shapeLayer.strokeColor = UIColor.greyish20.cgColor
        shapeLayer.fillColor = UIColor.black40.cgColor
        shapeLayer.lineDashPattern = cellStyle == .dashed ? [4, 3] : nil
        shapeLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).cgPath
        layer.insertSublayer(shapeLayer, at: 0)
    }
}
