//
//  PartnerProfileView.swift
//  QOT
//
//  Created by Sam Wyndham on 06/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

class PartnerProfileView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        layer.mask = CAShapeLayer()
    }

    override func layoutSubviews() {
        guard let mask = layer.mask as? CAShapeLayer else { return }

        /*
         Calculate square frame which will have hexigon aligned with selfs bounds left and right edges. To do this we
         first calculate the ratio of hexagon circumradius to inradius -
         See: http://www.drking.org.uk/hexagons/misc/ratio.html
         */
        let ratio = CGFloat(3).squareRoot() / 2
        let length = bounds.width / ratio
        let x = (bounds.width - length) / 2
        let y = (bounds.height - length) / 2
        let frame = CGRect(x: x, y: y, width: length, height: length)
        let path = UIBezierPath(polygonIn: frame, sides: 6, lineWidth: 0, cornerRadius: 4, rotateByDegs: 180 / 6)
        mask.path = path.cgPath
    }
}
