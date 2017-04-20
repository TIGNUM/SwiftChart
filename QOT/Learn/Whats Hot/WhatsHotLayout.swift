//
//  WhatsHotLayout.swift
//  QOT
//
//  Created by AamirSuhialMir on 4/13/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

private struct Constants {
    static let standardHeight: CGFloat = 130
    static let featuredHeight: CGFloat = 352 // At 473
}

final class WhatsHotLayout: UICollectionViewLayout {

    private var indexPath = 0
    private var cache = [UICollectionViewLayoutAttributes]()
    private var offSet: CGFloat = 0

    fileprivate var width: CGFloat {
        return collectionView!.bounds.width
    }

    fileprivate var height: CGFloat {
        return collectionView!.bounds.height
    }

    fileprivate var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }

    override var collectionViewContentSize: CGSize {
            let contentHeight = (Constants.standardHeight * CGFloat(numberOfItems))  + (Constants.featuredHeight - Constants.standardHeight) + Constants.featuredHeight
        return CGSize(width: width, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            self.cache = []
            return
        }

        let standardHeight = Constants.standardHeight
        let featuredHeight = Constants.featuredHeight

        var cache: [UICollectionViewLayoutAttributes] = []
        cache.reserveCapacity(numberOfItems)

        for item in 0..<numberOfItems {

            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item

            let y = (CGFloat(item) * standardHeight) + (featuredHeight - standardHeight)
            let frame: CGRect
            if y <= collectionView.contentOffset.y + (featuredHeight - standardHeight) {
                let percentage = ((collectionView.contentOffset.y / standardHeight) - CGFloat(item))

                let diff = (featuredHeight - standardHeight) * percentage
                let convertedY = y - (featuredHeight - standardHeight) - diff
                frame = CGRect(x: 0, y: convertedY, width: width, height: featuredHeight)

            } else if y <= collectionView.contentOffset.y + featuredHeight {
                let percentage = ((collectionView.contentOffset.y / standardHeight) - CGFloat(item)) + CGFloat(1)

                let diff = (featuredHeight - standardHeight) * percentage
                let height: CGFloat = standardHeight + diff
                let convertedY = y + standardHeight - height

                frame = CGRect(x: 0, y: convertedY, width: width, height: height)

            } else {
                frame = CGRect(x: 0, y: y, width: width, height: standardHeight)

            }

            attributes.frame = frame
            cache.append(attributes)
        }

        self.cache = cache

    }

    //    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    //        let itemIndex = round(proposedContentOffset.y / dragOffset)
    //        let yOffset = itemIndex * dragOffset + 0.5
    //        return CGPoint(x: 0, y: yOffset)
    //    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
