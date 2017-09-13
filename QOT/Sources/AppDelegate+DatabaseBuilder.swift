//
//  AppDelegate+DatabaseBuilder.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

#if BUILD_DATABASE
    import Foundation
    
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
            
            log("\nbuild database started (may take some time - get a tea...)\n")
            
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
                    log(context.errors[0])
                    return
                }
                
                do {
                    let name = "default-v1.realm"
                    let fileURL = try databaseBuilder.copyWithName(name)
                    log("\nbuild database completed successfully. paste this into terminal:")
                    log("cd <qot project>")
                    log("cp \"\(fileURL!.absoluteString.removeFilePrefix)\" \"QOT/Resources/Database/\(name)\"")
                    log("\nnow verify it by opening the database:")
                    log("open \"QOT/Resources/Database/\(name)\"")
                    log("\nthen close Realm browser, and remove all the crap:")
                    log("rm QOT/Resources/Database/*.lock;rm -r QOT/Resources/Database/*.management;rm QOT/Resources/Database/*.note")
                } catch {
                    log("\nbuild database failed with error: \(error.localizedDescription)")
                }
            })
            databaseBuilder.build()
        }
    }
#endif
