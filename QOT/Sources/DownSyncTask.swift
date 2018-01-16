//
//  DownSyncTask.swift
//  QOT
//
//  Created by Sam Wyndham on 17.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class DownSyncTask<T>: SyncTask where T: SyncableObject, T: DownSyncable, T.Data: DownSyncIntermediary {
    typealias SyncToken = String

    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private let syncRecordService: SyncRecordService
    private var currentRequest: SerialRequest?
    private var isCancelled = false
    var customImporter: (([DownSyncChange<T.Data>], ObjectStore) throws -> Void)? // FIXME: Remove hack

    init(networkManager: NetworkManager, realmProvider: RealmProvider, syncRecordService: SyncRecordService) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.syncRecordService = syncRecordService
    }

    func cancel() {
        isCancelled = true
        currentRequest?.cancel()
    }

    // MARK: Steps

    private func fetchSyncToken(from: Int64, completion: @escaping (Result<StartSyncResult, SyncError>) -> Void) {
        guard isCancelled == false else {
            completion(.failure(.didCancel))
            return
        }

        let request = StartSyncRequest(from: from)
        currentRequest = networkManager.request(request, parser: StartSyncResult.parse) { (result) in
            switch result {
            case .success(let startSyncResult):
                completion(.success(startSyncResult))
            case .failure(let error):
                completion(.failure(.fetchSyncTokenFailed(error: error)))
            }
        }
    }

    func start(completion: @escaping (SyncError?) -> Void) {
        getLastSyncDate { [weak self] (syncDateResult) in
            switch syncDateResult {
            case .success(let lastSyncDate):
                self?.fetchSyncToken(from: lastSyncDate) { (fetchSyncTokenResult) in
                    switch fetchSyncTokenResult {
                    case .success(let startSyncResult):
                        self?.fetchRemoteChanges(syncToken: startSyncResult.syncToken, syncDate: lastSyncDate) { (remoteChangesResult) in
                            switch remoteChangesResult {
                            case .success(let (changes, syncToken)):
                                self?.confirmDownSync(syncToken: syncToken)
                                self?.importChanges(changes: changes, syncDate: startSyncResult.syncDate) { (error) in
                                    completion(error)
                                }
                            case .failure(let error):
                                completion(error)
                            }
                        }
                    case .failure(let error):
                        completion(error)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }

    private func getLastSyncDate(completion: @escaping (Result<Int64, SyncError>) -> Void) {
        do {
            let date = try syncRecordService.lastSync(T.self) ?? 0
            completion(.success(date))
        } catch let error {
            completion(.failure(.downSyncReadLastSyncDateFailed(type: syncDescription, error: error)))
        }
    }

    private func fetchRemoteChanges(syncToken: String, syncDate: Int64, completion: @escaping (Result<([DownSyncChange<T.Data>], SyncToken), SyncError>) -> Void) {
        guard isCancelled == false else {
            completion(.failure(.didCancel))
            return
        }

        let endpoint = T.endpoint
        currentRequest = networkManager.request(token: syncToken, endpoint: endpoint, page: 1) { [syncDescription] (result: Result<([DownSyncChange<T.Data>], SyncToken), NetworkError>) in
            switch result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(.downSyncFetchIntermediatesFailed(type: syncDescription, error: error)))
            }
        }
    }

    private func confirmDownSync(syncToken: String) {
        guard isCancelled == false else {
            return
        }

        let endpoint = DownSyncConfirmRequest(endpoint: .downSyncConfirm, syncToken: syncToken)
        currentRequest = networkManager.request(endpoint, parser: DownSyncComplete.parse) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                log("Down sync confirm error: \(error)")
            }
        }
    }

    private func importChanges(changes: [DownSyncChange<T.Data>], syncDate: Int64, completion: (SyncError?) -> Void ) {
        guard isCancelled == false else {
            completion(.didCancel)
            return
        }

        do {
            let realm = try realmProvider.realm()
            try realm.write {
                if let importer = customImporter {
                    try importer(changes, realm)
                } else {
                    let importer = DownSyncImporter<T>()
                    try importer.importChanges(changes, store: realm)
                }
            }
            try syncRecordService.recordSync(T.self, date: syncDate)
            completion(nil)
        } catch let error {
            completion(.downSyncImportChangesFailed(type: syncDescription, error: error))
        }
    }

    private var syncDescription: String {
        return "class: \(String(describing: T.self)), endpoint: \(T.endpoint.rawValue)"
    }
}
