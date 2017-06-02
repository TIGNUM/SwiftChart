//
//  LearnContentLayout.swift
//  QOT
//
//  Created by Aamir Suhial on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentLayout: UICollectionViewLayout {

    private let bubbleDiameter: CGFloat
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var contentSize = CGSize.zero
    
    var bubbleCount: Int {
        didSet {
            invalidateLayout()
        }
    }
    
    init(bubbleCount: Int, bubbleDiameter: CGFloat) {
        self.bubbleCount = bubbleCount
        self.bubbleDiameter = bubbleDiameter
        
        super.init()
    }
    
    private func setup() {
        if let collectionView = collectionView {
            let horizontalPadding: CGFloat = 30
            let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
            let contentArray = createPattern()
            
            let attributes = contentArray.enumerated().map { (index, point) -> UICollectionViewLayoutAttributes in
                let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
                attrs.frame = CGRect(x: point.x, y: point.y, width: bubbleDiameter, height: bubbleDiameter)
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
        return collectionView?.bounds.size != newBounds.size
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
    
    func createPattern() -> ArraySlice<CGPoint> {
        var allBubbles = [CGPoint]()
        let horizontalPadding: CGFloat = 30
        let interBubbleSpacing: CGFloat = 15
        var xCoordinate: CGFloat = 0 + horizontalPadding
        let height: CGFloat = (3 * bubbleDiameter)
        let yCoordinate: CGFloat = height / 2 - (bubbleDiameter / 2 - horizontalPadding)

        for index in 0..<bubbleCount {
            if index != 0 {
                allBubbles.append(CGPoint(x: xCoordinate + bubbleDiameter + (interBubbleSpacing / 2), y: yCoordinate + bubbleDiameter / 2 + interBubbleSpacing))
                allBubbles.append(CGPoint(x: xCoordinate + bubbleDiameter, y: yCoordinate - bubbleDiameter / 2 - (interBubbleSpacing)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleDiameter * 2), y: yCoordinate - (interBubbleSpacing / 2)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleDiameter * 2) + interBubbleSpacing, y: yCoordinate + bubbleDiameter + (interBubbleSpacing)))
                allBubbles.append(CGPoint(x: xCoordinate + (bubbleDiameter * 2) - interBubbleSpacing, y: yCoordinate - bubbleDiameter - interBubbleSpacing * 2))
                xCoordinate = (xCoordinate + bubbleDiameter * 2)
            } else {
                allBubbles.append(CGPoint(x: xCoordinate, y: yCoordinate))
            }
        }

        return allBubbles.dropLast(allBubbles.count - bubbleCount)
    }
}
