//
//  UpSyncTask.swift
//  QOT
//
//  Created by Sam Wyndham on 17.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class UpSyncTask<T>: SyncTask where T: SyncableObject, T: UpSyncable {
    typealias SyncToken = String

    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private var currentRequest: SerialRequest?
    private var isCancelled = false

    init(networkManager: NetworkManager, realmProvider: RealmProvider) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
    }

    func cancel() {
        isCancelled = true
        currentRequest?.cancel()
    }

    func start(completion: @escaping (SyncError?) -> Void) {
        fetchSyncToken(from: 0) { [weak self] (result) in // Any from value is fine here as it is ignored by the server
            switch result {
            case .success(let startSyncResult):
                self?.upSync(syncToken: startSyncResult.syncToken, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
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

    private func upSync(syncToken: String, completion: @escaping (SyncError?) -> Void) {
        fetchDirtyObjects { [weak self] (fetchResult) in
            switch fetchResult {
            case .success(let objects):
                guard let objects = objects else {
                    completion(nil)
                    return
                }
                sendDirty(data: objects, syncToken: syncToken) { (sendResult) in
                    switch sendResult {
                    case .success(let upSyncResult):
                        self?.updateDirty(data: objects, result: upSyncResult) { (error) in
                            if let error = error {
                                completion(error)
                            } else {
                                self?.upSync(syncToken: upSyncResult.nextSyncToken, completion: completion)
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

    private func fetchDirtyObjects(completion: (Result<UpSyncData?, SyncError>) -> Void) {
        do {
            completion(.success(try T.upSyncData(realm: realmProvider)))
        } catch let error {
            completion(.failure(.upSyncFetchDirtyFailed(error: error)))
        }
    }

    private func sendDirty(data: UpSyncData, syncToken: String, completion: @escaping (Result<UpSyncResult, SyncError>) -> Void) {
        guard isCancelled == false else {
            completion(.failure(.didCancel))
            return
        }

        let request = UpSyncRequest(endpoint: T.endpoint, body: data.body, syncToken: syncToken)
        currentRequest = networkManager.request(request, parser: UpSyncResultParser.parse) { (result) in
            switch result {
            case .success(let upSyncResult):
                completion(.success(upSyncResult))
            case .failure(let error):
                completion(.failure(.upSyncSendDirtyFailed(error: error)))
            }
        }
    }

    private func updateDirty(data: UpSyncData, result: UpSyncResult, completion: (SyncError?) -> Void) {
        guard isCancelled == false else {
            completion(.didCancel)
            return
        }

        do {
            let realm = try realmProvider.realm()
            try realm.write {
                try data.completion(result.remoteIDs, realm)
            }
            completion(nil)
        } catch {
            completion(.upSyncUpdateDirtyFailed(error: error))
        }
    }
}
