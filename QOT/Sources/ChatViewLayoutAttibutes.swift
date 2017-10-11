//
//  ChatViewLayoutAttibutes.swift
//  QOT
//
//  Created by Sam Wyndham on 28.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChatViewLayoutAttibutes: UICollectionViewLayoutAttributes {

    var animator: ChatViewAnimator?
    var insertedAt: Date?

    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? ChatViewLayoutAttibutes else {
            fatalError("copy failed")
        }
        copy.animator = animator
        copy.insertedAt = insertedAt
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ChatViewLayoutAttibutes else {
            return false
        }
        return other.animator === animator && other.insertedAt == insertedAt && super.isEqual(object)
    }

    convenience init(forSupplementaryViewOfKind kind: ChatViewSupplementaryViewKind, with indexPath: IndexPath) {
        self.init(forSupplementaryViewOfKind: kind.rawValue, with: indexPath)
    }
}
