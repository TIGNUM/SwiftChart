//
//  UpdateRelationsOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 13.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class UpdateRelationsOperation: ConcurrentOperation {

    private let context: SyncContext
    private let realmProvider: RealmProvider

    init(context: SyncContext, realmProvider: RealmProvider) {
        self.context = context
        self.realmProvider = realmProvider
    }

    override func execute() {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                let contentCategories = realm.objects(ContentCategory.self)
                let contentCollections = realm.objects(ContentCollection.self)
                let contentItems = realm.objects(ContentItem.self)

                // First create relationships in one direction
                contentCollections.forEach { $0.buildRelations(realm: realm) }
                contentItems.forEach { $0.buildRelations(realm: realm) }

                // Next create inverse relationships. Must happen after above relationships created
                contentCategories.forEach { $0.buildInverseRelations(realm: realm) }
                contentCollections.forEach { $0.buildInverseRelations(realm: realm) }
            }

            finish(error: nil)
        } catch let error {
            finish(error: .updateRelationsFailed(error: error))
        }
    }

    // MARK: Finish

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }
        finish()
    }
}
