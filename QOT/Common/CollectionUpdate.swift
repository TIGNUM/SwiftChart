//
//  CollectionUpdate.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

/// Encapulates changes to be applied to an instance of `UICollectionView` or 
/// `UITableView`.
enum CollectionUpdate {
    /// Indicates the view should be reloaded.
    case reload
    /// Indicates the view should be updated.
    case update(deletions: [Int], insertions: [Int], modifications: [Int])
}
