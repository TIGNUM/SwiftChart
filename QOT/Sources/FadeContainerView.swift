//
//  FadeContainerView.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 15/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class FadeContainerView: UIView {

    private let maskLayer = CAGradientLayer()
    private var topFade: CGFloat = 0
    private var bottomFade: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setFade(top: CGFloat, bottom: CGFloat) {
        topFade = top
        bottomFade = bottom
        updateMask()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    private func setup() {
        let clear = UIColor.clear.cgColor
        let opaque = UIColor.white.cgColor
        maskLayer.colors = [clear, clear, opaque, opaque, clear, clear]
        layer.mask = maskLayer
    }

    private func updateMask() {
        maskLayer.frame = bounds
        if bounds.height != 0 {
            let top = topFade / bounds.height
            let midTop = top / 2
            let bottom = 1 - (bottomFade / bounds.height)
            let midBottom = 1 - ((bottomFade / bounds.height) / 2)
            maskLayer.locations = [0, midTop, top, bottom, midBottom, 1].map { NSNumber(value: Double($0)) }
        }
    }
}
