//
//  ArticleCollectionLayout.swift
//  QOT
//
//  Created by AamirSuhialMir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol ArticleCollectionLayoutDelegate: class {

    func standardHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat

    func featuredHeightForLayout(_ layout: ArticleCollectionLayout) -> CGFloat
}

final class ArticleCollectionLayout: UICollectionViewLayout {

    private var cache = [UICollectionViewLayoutAttributes]()
    weak var delegate: ArticleCollectionLayoutDelegate?
    private var positionOne: CGFloat = 0
    fileprivate var width: CGFloat {
        return collectionView?.bounds.width ?? 0
    }

    fileprivate var itemCount: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    override var collectionViewContentSize: CGSize {
        guard
            let standardHeight = delegate?.standardHeightForLayout(self),
            let featuredHeight = delegate?.featuredHeightForLayout(self) else {
                return .zero
        }
        
        // FIXME: THis content height is incorrect
        let contentHeight = (CGFloat(itemCount) * standardHeight) +  (2 * standardHeight + featuredHeight)

        return CGSize(width: width, height: contentHeight)
    }

    override func prepare() {
        guard
            let collectionView = collectionView,
            let delegate = delegate else {
                self.cache = []

                return
        }

        let standardHeight = delegate.standardHeightForLayout(self)
        let featuredHeight = delegate.featuredHeightForLayout(self)
        var cache = [UICollectionViewLayoutAttributes]()
        cache.reserveCapacity(itemCount)

        for item in 0..<itemCount {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            let y = (CGFloat(item) * standardHeight) + (featuredHeight - standardHeight)
            let minimumAlpha: CGFloat = 0.3
            var frame: CGRect
            var alpha: CGFloat = minimumAlpha

            let contentOffsetY = collectionView.contentOffset.y + collectionView.contentInset.top
            if contentOffsetY < 0.0 {
                let  height: CGFloat = indexPath.item == 0 ? featuredHeight : standardHeight
                let convertedY = y + standardHeight - height
                frame = CGRect(x: 0, y: convertedY, width: width, height: height)
                alpha = indexPath.item == 0 ? 1.0 : minimumAlpha
            } else if y <= contentOffsetY + (featuredHeight - standardHeight) {
                let percentage = ((contentOffsetY / standardHeight) - CGFloat(item))
                let   diff = (featuredHeight - standardHeight) * percentage
                let convertedY = y - (featuredHeight - standardHeight) - diff
                frame = CGRect(x: 0, y: convertedY, width: width, height: featuredHeight)
                alpha = 1 - percentage
                alpha = alpha < minimumAlpha ? minimumAlpha : alpha
            } else if y <= contentOffsetY + featuredHeight {
                let percentage = ((contentOffsetY / standardHeight) - CGFloat(item)) + CGFloat(1)
                let diff = (featuredHeight - standardHeight) * percentage
                let height: CGFloat = standardHeight + diff
                let convertedY = y + standardHeight - height
                frame = CGRect(x: 0, y: convertedY, width: width, height: height)
                alpha =  percentage
                alpha = alpha < minimumAlpha ? minimumAlpha : alpha
            } else {
                frame = CGRect(x: 0, y: y, width: width, height: standardHeight)
                if y > contentOffsetY + featuredHeight {
                    let percentage = ((contentOffsetY / standardHeight) - CGFloat(item - 2))
                    alpha = percentage < 0.05 ? 0.05 : percentage > minimumAlpha ? minimumAlpha : percentage
                }
            }

            frame.origin.y += collectionView.contentInset.top
            attributes.frame = frame
            attributes.alpha = alpha
            cache.append(attributes)
        }

        self.cache = cache
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let delegate = delegate, let collectionView = collectionView else {
            return .zero
        }

        let itemIndex = round(proposedContentOffset.y / (delegate.standardHeightForLayout(self)))
        let yOffset = (itemIndex * (delegate.standardHeightForLayout(self))) - collectionView.contentInset.top
        return CGPoint(x: 0, y: yOffset)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cache {
            if attributes.frame.intersects(rect) == true {
                layoutAttributes.append(attributes)
            }
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
