//
//  ScrollViewAnimation.swift
//  QOT
//
//  Created by tignum on 4/12/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    func scrollViewScroll(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, width: CGFloat) -> CGFloat {
        let cellWidth: CGFloat = width
        let cellSpaceing: CGFloat = 15
        let originalTargetPage = (targetContentOffset.pointee.x) / (cellWidth + cellSpaceing)
        
        let scrollDirection: ScrollDirection
        if velocity.x < 0 {
            scrollDirection = .left
        } else if velocity.x > 0 {
            scrollDirection = .right
        } else {
            scrollDirection = .stationary
        }
        
        let targetPage: Int
        switch scrollDirection {
        case .stationary:
            targetPage = Int(round(originalTargetPage))
        case .left:
            targetPage = Int(floor(originalTargetPage))
        case .right:
            targetPage = Int(ceil(originalTargetPage))
        }
        
        let targetOffset = CGFloat(targetPage) * (cellWidth + cellSpaceing)
        return targetOffset
    }
}
private enum ScrollDirection {
    case left, stationary, right
}
