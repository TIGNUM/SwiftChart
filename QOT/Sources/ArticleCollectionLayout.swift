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
    private var contentSize: CGSize = .zero
    weak var delegate: ArticleCollectionLayoutDelegate?

    private var itemCount: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        guard let collectionView = collectionView, let delegate = delegate else {
            self.cache = []
            self.contentSize = .zero
            return
        }
        let yOffset = collectionView.insetAdjustedYOffset
        let contractedHeight = delegate.standardHeightForLayout(self)
        let expandedHeight = delegate.featuredHeightForLayout(self)
        let firstContractedRow = Int(yOffset / expandedHeight) + 1
        let width = collectionView.bounds.width - collectionView.contentInset.horizontal
        var cache = [UICollectionViewLayoutAttributes]()
        cache.reserveCapacity(itemCount)
        var y: CGFloat = 0
        for row in 0..<itemCount {
            let height: CGFloat
            if row < firstContractedRow {
                height = expandedHeight
            } else if row == firstContractedRow {
                let adjustedHeight = contractedHeight + expandedHeight - (y - yOffset)
                height = adjustedHeight.constrainedTo(min: contractedHeight, max: expandedHeight)
            } else {
                height = contractedHeight
            }
            let indexPath = IndexPath(row: row, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = CGRect(x: 0, y: y, width: width, height: height)
            cache.append(attributes)
            y += height
        }
        let height = y + collectionView.bounds.height - collectionView.contentInset.vertical - expandedHeight
        self.cache = cache
        self.contentSize = CGSize(width: width, height: height)
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let delegate = delegate, let collectionView = collectionView, itemCount > 0 else { return .zero }
        let expandedHeight = delegate.featuredHeightForLayout(self)
        let targetRowFloat = (proposedContentOffset.y + collectionView.contentInset.top) / expandedHeight
        let targetRow = Int(round(targetRowFloat)).constrainedTo(min: 0, max: itemCount - 1)
        let yOffset = (CGFloat(targetRow) * expandedHeight) - collectionView.contentInset.top
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

private extension UICollectionView {

    var insetAdjustedYOffset: CGFloat {
        return contentOffset.y + contentInset.top
    }
}
