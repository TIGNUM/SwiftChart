//
//  LearnContentLayout.swift
//  QOT
//
//  Created by Aamir Suhial on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentLayout: UICollectionViewLayout {
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize: CGSize = CGSize.zero
    
    var bubbleCount: Int {
        didSet {
            invalidateLayout()
        }
    }
    
    init(bubbleCount: Int) {
        self.bubbleCount = bubbleCount
        
        super.init()
    }
    
    private func setup() {
        
        if let collectionView = collectionView {
            let horizontalPadding: CGFloat = 30
            let bounds = collectionView.bounds
            let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            
            let contentArray = createPattern(frame: frame)
            
            let attributes = contentArray.enumerated().map { (index, point) -> UICollectionViewLayoutAttributes in
                let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
                attrs.frame = CGRect(x: point.x, y: point.y, width: 160, height: 160)
                return attrs
            }
            
            let maxX = attributes.reduce(CGFloat(0), { max($0.0, $0.1.frame.maxX) }) + horizontalPadding
            contentSize = CGSize(width: maxX + horizontalPadding, height: frame.height)
            
            layoutAttributes = attributes
        } else {
            contentSize = CGSize.zero
            layoutAttributes = []
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let collectionView = collectionView {
            return collectionView.bounds.size != newBounds.size
        } else {
            return false
        }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        setup()
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
        return CGSize(width: contentSize.width, height: contentSize.height )
    }
    
    func createPattern(frame: CGRect) -> ArraySlice<CGPoint> {
        var allBubbles = [CGPoint]()
        let horizontalPadding: CGFloat = 30
        let interBubbleSpacing: CGFloat = 15
        let bubbleSize: CGFloat = 160
        var xCoordinate: CGFloat = frame.minX + horizontalPadding
        let yCoordinate: CGFloat = frame.height / 2 - bubbleSize / 2
        
        for index in 0..<bubbleCount {
            if index != 0 {
                allBubbles.append(CGPoint(x: xCoordinate + bubbleSize + (interBubbleSpacing / 2), y: yCoordinate + bubbleSize / 2 + interBubbleSpacing))
                allBubbles.append(CGPoint(x: xCoordinate + bubbleSize, y: yCoordinate - bubbleSize / 2 - (interBubbleSpacing)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleSize * 2), y: yCoordinate - (interBubbleSpacing / 2)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleSize * 2) + interBubbleSpacing, y: yCoordinate + bubbleSize + (interBubbleSpacing)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleSize * 2) - interBubbleSpacing, y: yCoordinate - bubbleSize - interBubbleSpacing * 2))
                xCoordinate = (xCoordinate + bubbleSize * 2)
            } else {
                allBubbles.append(CGPoint(x: xCoordinate, y: yCoordinate))
            }
        }
        return allBubbles.dropLast(allBubbles.count - bubbleCount)
    }
}
