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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes as? LearnContentListBackgroundViewLayoutAttributes != nil {
            layoutIfNeeded()
        }
    }
}

final class LearnContentListBackgroundViewLayoutAttributes: UICollectionViewLayoutAttributes {}

private extension LearnContentListBackgroundView {

    func setup() {
        backgroundColor = .navy
    }
}
