//
//  CollectionUpdate.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

/// Encapulates changes to be applied to an instance of `UICollectionView` or 
/// `UITableView`.
enum CollectionUpdate {
    /// Indicates the view should be reloaded.
    case reload
    /// Indicates the view should be updated.
    case update(deletions: [IndexPath], insertions: [IndexPath], modifications: [IndexPath])
}

extension RealmCollectionChange {

    func update(section: Index) -> CollectionUpdate {
        switch self {
        case .initial:
            return .reload
        case .error(let error):
            print("Realm collection errored: \(error)")
            return .reload
        case .update(_, let deletions, let insertions, let modifications):
            return .update(deletions: deletions.map({ IndexPath(item: $0, section: section) }),
                           insertions: insertions.map({ IndexPath(item: $0, section: section) }),
                           modifications: modifications.map({ IndexPath(item: $0, section: section) }))
        }
    }
}

extension UICollectionView {

    func performUpdate(_ update: CollectionUpdate, completion: ((Bool) -> Void)? = nil) {
        switch update {
        case .reload:
            reloadData()
            completion?(true)
        case .update(let deletions, let insertions, let modifications):
            performBatchUpdates({ [weak self] in
                self?.deleteItems(at: deletions)
                self?.insertItems(at: insertions)
                self?.reloadItems(at: modifications)
            }, completion: completion)
        }
    }
}
