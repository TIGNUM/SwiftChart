//
//  ChatViewAvatarView.swift
//  QOT
//
//  Created by Sam Wyndham on 02.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Anchorage

final class ChatViewAvatarView: UICollectionReusableView {

    private let imageView = UIImageView(image: R.image.qBlack())
    private var animator: ChatViewAnimator?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attrs = layoutAttributes as? ChatViewLayoutAttibutes, let animator = attrs.animator {
            self.animator = animator
            animator.animate(view: self, using: attrs)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        animator?.cancel()
    }

    private func setup() {
        addSubview(imageView)
        imageView.edgeAnchors == edgeAnchors
    }
}
