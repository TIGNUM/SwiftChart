//
//  WeeklyChoicesLayout.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/16/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol WeeklyChoicesDelegate: class {
    func radius() -> CGFloat
    func circleX() -> CGFloat
    func cellHeight() -> CGFloat
}

final class WeeklyChoicesLayout: UICollectionViewLayout {

    private var cache = [UICollectionViewLayoutAttributes]()
    weak var delegate: WeeklyChoicesDelegate? {
        didSet {
            invalidateLayout()
        }
    }

    private var width: CGFloat {
        return collectionView?.bounds.width ?? 0
    }

    private var itemCount: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    override var collectionViewContentSize: CGSize {
        guard let cellHeight = delegate?.cellHeight() else {
            return .zero
        }

        let contentHeight = (CGFloat(itemCount) * cellHeight) + cellHeight
        return CGSize(width: width, height: contentHeight)
    }

    override func prepare() {
        guard
            let radius = delegate?.radius(),
            let circleX = delegate?.circleX(),
            let cellHeight = delegate?.cellHeight()
            else {
                self.cache = []
                return
        }

        var cache = [UICollectionViewLayoutAttributes]()
        cache.reserveCapacity(itemCount)

        for index in 0..<itemCount {

            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let y = CGFloat(index) * cellHeight
            let cellCenterY = y + (cellHeight * 0.5)
            
            let x: CGFloat
            let cellWidth: CGFloat
            if let approxX = xPos(y: cellCenterY, radius: radius, circleX: circleX) {
                x = (abs(circleX / 2) - (radius - abs(circleX))) - approxX
                cellWidth = width - x
            } else {
                x = -10000
                cellWidth = width
            }
            attributes.frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            cache.append(attributes)
        }
        self.cache = cache
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

    func circleCenter(circleX: CGFloat, collectionView: UICollectionView?) -> CGPoint {
        guard let collectionView = collectionView else {
            return .zero
        }
        return CGPoint(
            x: circleX + collectionView.contentOffset.x,
            y: (collectionView.bounds.height / 2) + collectionView.contentOffset.y
        )
    }
    
    // MARK: - private

    private func xPos(y: CGFloat, radius: CGFloat, circleX: CGFloat) -> CGFloat? {
        let circleCent = circleCenter(circleX: circleX, collectionView: collectionView)
        guard y > circleCent.y - radius && y < circleCent.y + radius else {
            return nil
        }

        let deltaY = abs(circleCent.y - y)
        let base = sqrt(pow(radius, 2) - pow(deltaY, 2))
        return radius - base
    }
}
