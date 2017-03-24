//
//  LearnCustomLayout.swift
//  QOT
//
//  Created by Aamir Suhial on 3/17/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnCategoryLayout: UICollectionViewLayout {
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize.zero
    
    init(height: CGFloat, categories: [LearnCategory]) {
        super.init()
        
        setup(height: height, categories: categories)
    }
    
    func setup(height: CGFloat, categories: [LearnCategory]) {
        let multiplier = height
        let frames = categories.map { (category) -> CGRect in
            let center = CGPoint(x: category.center.x * multiplier, y: category.center.y * multiplier)
            let radius = CGFloat(category.radius) * height
            return CGRect(x: center.x - radius, y: center.y - radius, width: 2 * radius, height: 2 * radius).integral
        }
        
        layoutAttributes = frames.enumerated().map { (index, frame) -> UICollectionViewLayoutAttributes in
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
            contentSize = CGSize.zero
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
