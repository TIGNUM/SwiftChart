//
//  ScrollViewAnimation.swift
//  QOT
//
//  Created by tignum on 4/12/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

private enum ScrollDirection {
    case left
    case stationary
    case right
}

class Helper {

    func scrollViewScroll(scrollView: UIScrollView, velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>, width: CGFloat) -> CGFloat {
        let cellWidth: CGFloat = width
        let cellSpaceing: CGFloat = 15
        let originalTargetPage = (targetContentOffset.pointee.x) / (cellWidth + cellSpaceing)
        let scrollDirection: ScrollDirection = (velocity.x < 0 ? .left : (velocity.x > 0 ? .right : .stationary))
        let targetPage: Int

        switch scrollDirection {
        case .stationary: targetPage = Int(round(originalTargetPage))
        case .left: targetPage = Int(floor(originalTargetPage))
        case .right: targetPage = Int(ceil(originalTargetPage))
        }
        
        let targetOffset = CGFloat(targetPage) * (cellWidth + cellSpaceing)

        return targetOffset
    }
}
