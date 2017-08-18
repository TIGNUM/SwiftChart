//
//  LearnContentListBackgroundView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift
import Anchorage

final class LearnContentListBackgroundView: UICollectionReusableView {

    static let kind = "LearnContentListBackgroundViewKind"

    fileprivate let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let attributes = layoutAttributes as? LearnContentListBackgroundViewLayoutAttributes {
            imageView.image = attributes.image
            layoutIfNeeded()
        }
    }
}

final class LearnContentListBackgroundViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var image = R.image.learnBack1()
}

private extension LearnContentListBackgroundView {

    func setup() {
        backgroundColor = .clear
        addSubview(imageView)
        imageView.image = R.image.learnBack1()
        imageView.edgeAnchors == edgeAnchors
        imageView.contentMode = .scaleAspectFill
    }
}
