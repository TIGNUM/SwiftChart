//
//  UpdateRelationsOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 13.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol BuildRelations {
    func buildRelations(realm: Realm)
    func buildInverseRelations(realm: Realm)
}
extension BuildRelations { // optional
    func buildRelations(realm: Realm) {}
    func buildInverseRelations(realm: Realm) {}
}

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
                let collections: [[BuildRelations]] = [
                    Array(realm.objects(ContentCategory.self)),
                    Array(realm.objects(ContentCollection.self)),
                    Array(realm.objects(ContentItem.self)),
                    Array(realm.objects(Preparation.self)),
                    Array(realm.objects(PreparationCheck.self))
                ]
                collections.forEach { $0.forEach { $0.buildRelations(realm: realm) } }
                collections.forEach { $0.forEach { $0.buildInverseRelations(realm: realm) } }
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
