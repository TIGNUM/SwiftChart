//
//  WeeklyChoicesLayout.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/16/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class WeeklyChoicesLayout: UICollectionViewFlowLayout {
    struct Circle {
        let center: CGPoint
        let radius: CGFloat
    }
    var circle = Circle(center: .zero, radius: 0)

    override init() {
        super.init()
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var newAttributes = [UICollectionViewLayoutAttributes]()
        attributes.forEach { attribute in
            // must copy to avoid warning
            guard let attribute = attribute.copy() as? UICollectionViewLayoutAttributes else {
                return
            }
            let x = self.x(for: attribute.center.y, circle: circle)
            attribute.frame.origin.x = x
            attribute.frame.size.width -= x
            newAttributes += [attribute]
        }
        return newAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // MARK: - private

    private func x(for y: CGFloat, circle: Circle) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let center = CGPoint(
            x: circle.center.x + collectionView.contentOffset.x,
            y: circle.center.y + collectionView.contentOffset.y - collectionView.frame.origin.y
        )
        guard y > center.y - circle.radius && y < center.y + circle.radius else {
            return 0
        }
        let deltaY = abs(center.y - y)
        let base = sqrt(pow(circle.radius, 2) - pow(deltaY, 2))
        let x = circle.radius - base
        let inverseX = collectionView.bounds.width - x
        let normalized = inverseX - fabs(circle.center.x) - 8 // 8px is half the cell's dot
        return normalized
    }
}
