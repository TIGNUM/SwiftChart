//
//  AppDelegate+DatabaseBuilder.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

#if BUILD_DATABASE
    import Foundation
    import RealmSwift
    
    var databaseBuilder: DatabaseBuilder!

    extension AppDelegate {
        func __buildDatabase() {
            let realmProvider = BuilderRealmProvider()
            databaseBuilder = DatabaseBuilder(
                networkManager: NetworkManager(),
                syncRecordService: SyncRecordService(realmProvider: realmProvider),
                realmProvider: realmProvider,
                deviceID: deviceID
            )
            
            print("\nbuild database started (may take some time - get a tea...)\n")
            
            let context = SyncContext()
            
            databaseBuilder.setContentOperations([
                databaseBuilder.downSyncOperation(for: ContentCategory.self, context: context),
                databaseBuilder.downSyncOperation(for: ContentCollection.self, context: context),
                databaseBuilder.downSyncOperation(for: ContentItem.self, context: context),
                databaseBuilder.downSyncOperation(for: Question.self, context: context),
                databaseBuilder.downSyncOperation(for: Page.self, context: context),
                databaseBuilder.updateRelationsOperation(context: context)
                ])
            databaseBuilder.setCompletion({
                guard context.errors.count == 0 else {
                    print(context.errors[0])
                    return
                }
                
                do {
                    let realm = try realmProvider.realm()
                    let contentCollections = realm.objects(ContentCollection.self)
                    try realm.write {
                        for contentCollection in contentCollections {
                            contentCollection.viewedAt = nil
                        }
                    }

                    let name = "default-v1.realm"
                    let fileURL = try databaseBuilder.copyWithName(name)
                    print("\nbuild database completed successfully. paste this into terminal:")
                    print("cd <qot project>")
                    print("cp \"\(fileURL!.absoluteString.removeFilePrefix)\" \"QOT/Resources/Database/\(name)\"")
                    print("\nnow verify it by opening the database:")
                    print("open \"QOT/Resources/Database/\(name)\"")
                    print("\nthen close Realm browser, and remove all the crap:")
                    print("rm QOT/Resources/Database/*.lock;rm -r QOT/Resources/Database/*.management;rm QOT/Resources/Database/*.note")
                } catch {
                    print("\nbuild database failed with error: \(error.localizedDescription)")
                }
            })
            databaseBuilder.build()
        }
    }
#endif
