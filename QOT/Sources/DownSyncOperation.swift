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

final class DownSyncOperation<T>: ConcurrentOperation where T: DownSyncable, T: SyncableObject, T.Data: DownSyncIntermediary {

    private let networkManager: NetworkManager
    private let syncRecordService: SyncRecordService
    private let realmProvider: RealmProvider
    private let downSyncImporter: DownSyncImporter<T>
    private let context: SyncContext

    init(context: SyncContext,
         networkManager: NetworkManager,
         syncRecordService: SyncRecordService,
         realmProvider: RealmProvider,
         downSyncImporter: DownSyncImporter<T>
        ) {
        self.networkManager = networkManager
        self.syncRecordService = syncRecordService
        self.realmProvider = realmProvider
        self.downSyncImporter = downSyncImporter
        self.context = context
    }

    override func execute() {
        getLastSyncDateAndContinue()
    }

    // MARK: Steps

    private func getLastSyncDateAndContinue() {
        do {
            startSync(lastSyncDate: try syncRecordService.lastSync(className: String(describing: T.self)))
        } catch let error {
            finish(error: .downSyncReadLastSyncDateFailed(type: syncDescription, error: error))
        }
    }

    private func startSync(lastSyncDate: Int64) {
        let request = StartSyncRequest(from: lastSyncDate)
        networkManager.request(request, parser: StartSyncResult.parse) { [weak self, syncDescription] (result) in
            switch result {
            case .success(let startSyncRestult):
                self?.fetchIntermediaries(syncToken: startSyncRestult.syncToken, syncDate: startSyncRestult.syncDate)
            case .failure(let error):
                self?.finish(error: .downSyncStartSyncFailed(type: syncDescription, error: error))
            }
        }

    }

    private func fetchIntermediaries(syncToken: String, syncDate: Int64) {
        let endpoint = T.endpoint
        networkManager.request(token: syncToken, endpoint: endpoint, page: 1) { [weak self, syncDescription] (result: Result<([DownSyncChange<T.Data>], String), NetworkError>) in
            switch result {
            case .success(let (changes, nextSyncToken)):
                self?.confirmDownSync(syncToken: nextSyncToken, completion: { [weak self] in
                    self?.importChanges(changes: changes, syncDate: syncDate)
                })
            case .failure(let error):
                self?.finish(error: .downSyncFetchIntermediatesFailed(type: syncDescription, error: error))
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

    private func importChanges(changes: [DownSyncChange<T.Data>], syncDate: Int64) {
        do {
            let realm = try realmProvider.realm()
            try realm.write {
                try downSyncImporter.importChanges(changes, store: realm)
            }
            saveSyncDate(syncDate: syncDate)
        } catch let error {
            finish(error: .downSyncImportChangesFailed(type: syncDescription, error: error))
        }
    }

    private func saveSyncDate(syncDate: Int64) {
        do {
            try syncRecordService.recordSync(className: String(describing: T.self), date: syncDate)
            finish(error: nil)
        } catch let error {
            finish(error: .downSyncSaveSyncDateFailed(type: syncDescription, error: error))
        }
    }

    // MARK: Finish

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }

        finish()
    }

    private var syncDescription: String {
        return "class: \(String(describing: T.self)), endpoint: \(T.endpoint.rawValue)"
    }
}
