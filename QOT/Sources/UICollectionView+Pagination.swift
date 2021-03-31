//
//  UICollectionView+Pagination.swift
//  QOT
//
//  Created by karmic on 31.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation

extension UICollectionView {
    var currentIndexPath: IndexPath {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return indexPathForItem(at: visiblePoint) ?? IndexPath(item: .zero, section: .zero)
    }

    var currentPageIndex: Int {
        return currentIndexPath.item
    }
}
