//
//  LearnCustomLayout.swift
//  QOT
//
//  Created by Aamir Suhial on 3/17/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnCategoryLayoutDelegate: UICollectionViewDelegate {
    func bubbleLayoutInfo(layout: LearnCategoryLayout, index: Index) -> BubbleLayoutInfo
}

private let backgroundViewDecorationKind = "backgroundViewDecorationKind"
private let backgroundViewIndexPath = IndexPath(item: 0, section: 0)

final class LearnCategoryLayout: UICollectionViewLayout {

    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var backgroundImageAttributes: LearnCategoryListBackgroundViewLayoutAttributes = {
        return LearnCategoryListBackgroundViewLayoutAttributes(forDecorationViewOfKind: backgroundViewDecorationKind,
                                                               with: backgroundViewIndexPath)
    }()
    private var contentSize = CGSize.zero {
        didSet {
            if contentSize != oldValue {
                centerCollectionView()
            }
        }
    }

    override init() {
        super.init()

        register(LearnCategoryListBackgroundView.self, forDecorationViewOfKind: backgroundViewDecorationKind)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView, let delegate = collectionView.delegate as? LearnCategoryLayoutDelegate else {
            layoutAttributes = []
            contentSize = .zero

            return
        }

        let multiplier = collectionView.bounds.height

        var bubbles: [BubbleLayoutInfo] = []
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            bubbles.append(delegate.bubbleLayoutInfo(layout: self, index: i))
        }

        let frames = bubbles.map { (bubble) -> CGRect in
            let center = CGPoint(x: CGFloat(bubble.centerX) * multiplier, y: CGFloat(bubble.centerY) * multiplier)
            let radius = CGFloat(bubble.radius) * multiplier

            return CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius).integral
        }

        layoutAttributes = frames.enumerated().map { (index: Index, frame: CGRect) -> UICollectionViewLayoutAttributes in
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attrs.frame = frame
            return attrs
        }

        if let first = frames.first {
            var minX: CGFloat = first.minX
            var maxX: CGFloat = first.maxX
            var maxY: CGFloat = first.maxY

            for frame in frames {
                minX = min(minX, frame.minX)
                maxX = max(maxX, frame.maxX)
                maxY = max(maxY, frame.maxY)
            }

            contentSize = CGSize(width: maxX + minX, height: collectionView.bounds.height)
        } else {
            contentSize = .zero
        }

        backgroundImageAttributes.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        backgroundImageAttributes.zIndex = -1
        backgroundImageAttributes.bubbleFrames = frames
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrs = layoutAttributes.filter { $0.frame.intersects(rect) }
        attrs.append(backgroundImageAttributes)
        return attrs
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return backgroundImageAttributes
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    private func centerCollectionView() {
        if let collectionView = collectionView {
            let xOffset = (contentSize.width - collectionView.frame.width) / 2
            collectionView.contentOffset = CGPoint(x: xOffset, y: collectionView.contentOffset.y)
        }
    }
}
