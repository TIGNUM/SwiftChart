//
//  LearnCategoryListBackgroundView.swift
//  QOT
//
//  Created by Sam Wyndham on 10.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class LearnCategoryListBackgroundView: UICollectionReusableView {

    fileprivate let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? LearnCategoryListBackgroundViewLayoutAttributes {
            setMask(frames: attributes.bubbleFrames)
        }
    }
}

final class LearnCategoryListBackgroundViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var bubbleFrames: [CGRect] = []
}

private extension LearnCategoryListBackgroundView {

    func setup() {
        backgroundColor = .clear
        addSubview(imageView)
        // FIXME: Set image
        // imageView.image =
        imageView.edgeAnchors == edgeAnchors
        imageView.contentMode = .scaleAspectFill
    }

    func setMask(frames: [CGRect]) {
        let maskPath = UIBezierPath(rect: bounds)
        for frame in frames {
            let circlePath = UIBezierPath(roundedRect: frame, cornerRadius: frame.width / 2)
            maskPath.append(circlePath)
        }

        let mask = CAShapeLayer()
        mask.path = maskPath.cgPath
        mask.fillRule = kCAFillRuleEvenOdd

        imageView.layer.mask = mask
    }
}
