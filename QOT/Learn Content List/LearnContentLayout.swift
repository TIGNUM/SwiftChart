//
//  LearnContentLayout.swift
//  QOT
//
//  Created by Aamir Suhial on 3/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentLayout: UICollectionViewLayout {
    init(frame: CGRect, totalNumberOfBubbles: Int) {
        
        func createPattern(frame: CGRect) -> [CGPoint] {
            var allBubbles = [CGPoint]() // an array for all sorted bubbles
            let padding: CGFloat = 20
            let bubbleSize: CGFloat = 159.9
            var xCoordinate: CGFloat = frame.minX + bubbleSize * 2
            let yCoordinate: CGFloat = frame.height / 2 - bubbleSize / 2
            
            for index in 0..<totalNumberOfBubbles {
                if index != 0 {
                    allBubbles.append(CGPoint(x: xCoordinate + bubbleSize, y: yCoordinate + bubbleSize / 2 + padding / 2))
                    allBubbles.append(CGPoint(x: xCoordinate + bubbleSize, y: yCoordinate - bubbleSize / 2 - padding / 2))
                    allBubbles.append(CGPoint(x: xCoordinate + bubbleSize * 2, y: yCoordinate))
                    allBubbles.append(CGPoint(x: xCoordinate + bubbleSize * 2, y: yCoordinate + bubbleSize + padding))
                    allBubbles.append(CGPoint(x: xCoordinate + bubbleSize * 2, y: yCoordinate - bubbleSize - padding))
                    xCoordinate = (xCoordinate + bubbleSize * 2)
                } else {
                    allBubbles.append(CGPoint(x: xCoordinate, y: yCoordinate ))
                }
            }
            return allBubbles
        }
        
        var attributes: [UICollectionViewLayoutAttributes] = []
        self.contentSize = CGSize(width: frame.width * 100, height: frame.height)
        let contentArray: Array = createPattern(frame: frame)
        
        for index in 0..<totalNumberOfBubbles {
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attrs.frame = CGRect(x: contentArray[index].x, y:contentArray[index].y, width: 159.9, height: 159.9).integral
            attributes.append(attrs)
        }
        
        self.layoutAttributes = attributes
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var layoutAttributes: [UICollectionViewLayoutAttributes]
    private var contentSize: CGSize
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height )
    }
    
}
