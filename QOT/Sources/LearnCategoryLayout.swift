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

final class LearnCategoryLayout: UICollectionViewLayout {
    
    private var layoutAttributes = [UICollectionViewLayoutAttributes]()
    private var contentSize = CGSize.zero {
        didSet {
            if contentSize != oldValue {
                centerCollectionView()
            }
        }
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
            return CGRect(x: center.x - radius, y: center.y - (radius + radius / 2), width: 2 * radius, height: 2 * radius).integral
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

            contentSize = CGSize(width: maxX + minX, height: maxY)
        } else {
            contentSize = .zero
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
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
