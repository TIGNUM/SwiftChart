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
    static let standardHeight: CGFloat = 150
    static let featuredHeight: CGFloat = 352
}

final class WhatsHotLayout: UICollectionViewLayout {
    private let dragOffset: CGFloat = 180
    fileprivate var indexPath = 0
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var offSet: CGFloat = 0
    fileprivate var featuredItemIndex: Int {
        return max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }
    
    fileprivate var nextItemPercentageOffset: CGFloat {
        return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
    }
    
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
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        let standardHeight = Constants.standardHeight
        let featuredHeight = Constants.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.zIndex = item
            
            var height = standardHeight
            
            if indexPath.item == featuredItemIndex {

                if offSet == 0 {
                    let yOffset = standardHeight * nextItemPercentageOffset
                    y = collectionView!.contentOffset.y - yOffset
                } else {
                    let yOffset = standardHeight * nextItemPercentageOffset + offSet
                    y = collectionView!.contentOffset.y - yOffset
                }
                height = featuredHeight

            } else if  indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                let maxY = height - standardHeight
                if maxY <= 200 {
                    offSet = maxY } else { offSet = 0 }
            }

            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y += height
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
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
