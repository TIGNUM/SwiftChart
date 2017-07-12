//
//  DownSyncOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 02.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import RealmSwift

final class DownSyncOperation<Intermediary, Persistable>: ConcurrentOperation where Intermediary: DownSyncIntermediary, Persistable: DownSyncable, Persistable: Object, Persistable.Data == Intermediary {

    private let networkManager: NetworkManager
    private let syncDescription: SyncDescription<Intermediary, Persistable>
    private let syncRecordService: SyncRecordService
    private let realmProvider: RealmProvider
    private let downSyncImporter: DownSyncImporter<Persistable>
    private let context: SyncContext
    private let isFinalOperation: Bool

    init(context: SyncContext,
         networkManager: NetworkManager,
         description: SyncDescription<Intermediary, Persistable>,
         syncRecordService: SyncRecordService,
         realmProvider: RealmProvider,
         downSyncImporter: DownSyncImporter<Persistable>,
         isFinalOperation: Bool = false
        ) {
        self.networkManager = networkManager
        self.syncDescription = description
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        self.downSyncImporter = downSyncImporter
        self.context = context
        self.isFinalOperation = isFinalOperation
    }

    override func execute() {
        guard context.state != .finished else {
            finish()
            return
        }

        getLastSyncDateAndContinue()
    }

    // MARK: Steps

    private func getLastSyncDateAndContinue() {
        do {
            startSync(lastSyncDate: try syncRecordService.lastSync(type: syncDescription.syncType))
        } catch let error {
            finish(error: .downSyncReadLastSyncDateFailed(type: syncType, error: error))
        }
    }

    private func startSync(lastSyncDate: Int64) {
        let request = StartSyncRequest(from: lastSyncDate)
        networkManager.request(request, parser: StartSyncResult.parse) { [weak self, syncType] (result) in
            switch result {
            case .success(let startSyncRestult):
                self?.fetchIntermediaries(syncToken: startSyncRestult.syncToken, syncDate: startSyncRestult.syncDate)
            case .failure(let error):
                self?.finish(error: .downSyncStartSyncFailed(type: syncType, error: error))
            }
        }

    }

    private func fetchIntermediaries(syncToken: String, syncDate: Int64) {
        let endpoint = syncDescription.syncType.endpoint
        networkManager.request(token: syncToken, endpoint: endpoint, page: 1) { [weak self, syncType] (result: Result<([DownSyncChange<Intermediary>], String), NetworkError>) in
            switch result {
            case .success(let (changes, nextSyncToken)):
                self?.confirmDownSync(syncToken: nextSyncToken, completion: { [weak self] in
                    self?.importChanges(changes: changes, syncDate: syncDate)
                })
            case .failure(let error):
                self?.finish(error: .downSyncFetchIntermediatesFailed(type: syncType, error: error))
            }
        }
    }

    private func confirmDownSync(syncToken: String, completion: @escaping () -> Void) {
        let endpoint = DownSyncConfirmRequest(endpoint: .downSyncConfirm, syncToken: syncToken)
        networkManager.request(endpoint, parser: DownSyncComplete.parse, completion: { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("Down sync confirm error: \(error)")
            }
            
            completion()
        })
    }

    private func importChanges(changes: [DownSyncChange<Intermediary>], syncDate: Int64) {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                try downSyncImporter.importChanges(changes, store: realm)
            }
            saveSyncDate(syncDate: syncDate)
        } catch let error {
            finish(error: .downSyncImportChangesFailed(type: syncType, error: error))
        }
    }

    private func saveSyncDate(syncDate: Int64) {
        do {
            try syncRecordService.recordSync(type: syncDescription.syncType, date: syncDate)
            finish(error: nil)
        } catch let error {
            finish(error: .downSyncSaveSyncDateFailed(type: syncType, error: error))
        }
    }

    // MARK: Finish

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        } else if isFinalOperation {
            context.finish(error: nil)
        }

        finish()
    }

    private var syncType: SyncType {
        return syncDescription.syncType
    }
}
