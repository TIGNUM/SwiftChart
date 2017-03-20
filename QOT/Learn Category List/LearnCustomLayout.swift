//
//  LearnCustomLayout.swift
//  QOT
//
//  Created by tignum on 3/17/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnCustomLayout: UICollectionViewLayout {
    private  var circlePathHandle = UIBezierPath()
    private  var shapeLayerHandle = CAShapeLayer()
         init(frame: CGRect) {
        let radius:CGFloat = 120
        let pos:CGPoint
        var positionOfCenterCircle: CGRect = frame
        pos = CGPoint(x: positionOfCenterCircle.midX, y: positionOfCenterCircle.midY)
        var circleSize: CGFloat = 100
        func changePosition(index: Int) -> (CGFloat, CGFloat, CGFloat) {
            print("my position of x is \(positionOfCenterCircle.midX)")
            var posX: CGFloat
            var posY: CGFloat
            var size = radius
            switch index {
            case 1:
                posX = (positionOfCenterCircle.minX - (radius))
                posY = (positionOfCenterCircle.minY - (radius) - radius / 4 )
                 return (posX, posY, 160)
            case 2:
                posX = (positionOfCenterCircle.minX -  radius ) - radius / 2
                posY = (positionOfCenterCircle.maxY - radius )
                return (posX, posY, 152)
            case 3:
                posX = (positionOfCenterCircle.maxX - radius ) - radius / 2
                posY = (positionOfCenterCircle.maxY ) + radius / 4
                return (posX, posY, 157.3)
            case 4:
                posX = (positionOfCenterCircle.maxX + radius / 5)
                posY = (positionOfCenterCircle.maxY - radius / 1.5)
                return (posX, posY, 134.3)
           case 5:
                posX = ((positionOfCenterCircle.maxX - radius / 4) )
                posY = (positionOfCenterCircle.minY - (radius) - radius / 4 )
                return (posX, posY, 168.9)
//            case 5:
//                posX = (positionOfCenterCircle.minY + radius)
//                posY = (positionOfCenterCircle.minX - radius)
//                return (posX, posY)
           
            default:
            return (00, 00, 00)
            }
        }
        var attributes: [UICollectionViewLayoutAttributes] = []
        self.contentSize = CGSize(width: frame.width, height: frame.height)
        var xCoordinate: CGFloat = 0
        var yCoordinate: CGFloat = 0
        var index = 0
        while index < 6 {
            if index == 0 {
                let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
                attrs.frame = CGRect(x:((frame.size.width / 2.0) - circleSize / 2.0), y:((frame.size.height / 2.0) - circleSize ), width: circleSize + 68.8, height: circleSize + 68.8).integral
                attributes.append(attrs)
                positionOfCenterCircle = attrs.frame
                xCoordinate = attrs.frame.minX
                yCoordinate = attrs.frame.minY
                index += 1 } else {
                let item = changePosition(index: index)
                xCoordinate = item.0
                yCoordinate = item.1
                circleSize = item.2
            let attrs = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
            attrs.frame = CGRect(x: xCoordinate, y: yCoordinate, width: circleSize, height: circleSize).integral
            attributes.append(attrs)
                index += 1 }
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
        return CGSize(width: contentSize.width + 50, height: contentSize.height )
    }
    
   }
