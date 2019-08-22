//
//  UpSyncMediaOperation.swift
//  QOT
//
//  Created by Lee Arromba on 07/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift
import Freddy
import Kingfisher

final class UpSyncMediaOperation: ConcurrentOperation {

    private let networkManager: NetworkManager
    private let realmProvider: RealmProvider
    private let context: SyncContext
    private let localID: String
    private var currentRequest: SerialRequest?

    init(networkManager: NetworkManager,
         realmProvider: RealmProvider,
         syncContext: SyncContext,
         localID: String) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.context = syncContext
        self.localID = localID
    }

    override func execute() {
        fetchSyncToken()
    }

    // MARK: Steps

    private func fetchSyncToken() {
        guard isCancelled == false else {
            finish(error: .didCancel)
            return
        }

        let request = StartSyncRequest(from: 0) // Any from value is fine here as it is ignored by the server
        currentRequest = networkManager.request(request, parser: StartSyncResult.parse) { [weak self] (result) in
            switch result {
            case .success(let startSyncRestult):
                self?.fetchData(syncToken: startSyncRestult.syncToken)
            case .failure(let error):
                self?.finish(error: .upSyncStartSyncFailed(error: error))
            }
        }
    }

    private func fetchData(syncToken: String) {
        do {
            let realm = try realmProvider.realm()
            if let resource = realm.object(ofType: MediaResource.self, forPrimaryKey: localID),
                let data = try resource.json()?.serialize() {
                sendData(data, syncToken: syncToken, localURL: resource.localURL)
            } else {
                finish(error: nil)
            }
        } catch let error {
            finish(error: .upSyncFetchDirtyFailed(error: error))
        }
    }

    private func sendData(_ data: Data, syncToken: String, localURL: URL?) {
        guard isCancelled == false else {
            finish(error: .didCancel)
            return
        }

        let request = UpSyncRequest(endpoint: .media, body: data, syncToken: syncToken)
        currentRequest = networkManager.request(request, parser: UpSyncMediaResultParser.parse) { [weak self] (result) in
            switch result {
            case .success(let upSyncResult):
                self?.handleResult(upSyncResult, localURL: localURL)
            case .failure(let error):
                self?.finish(error: .upSyncSendDirtyFailed(error: error))
            }
        }
    }

    private func handleResult(_ result: UpSyncMediaResult, localURL: URL?) {
        guard isCancelled == false else {
            finish(error: .didCancel)
            return
        }

        let cacheKey = result.remoteURL.path
        do {
            try cacheImage(withURL: localURL, key: cacheKey, completion: { [unowned self] in
                do {
                    let realm = try self.realmProvider.realm()
                    let resource = realm.object(ofType: MediaResource.self, forPrimaryKey: self.localID)
                    try realm.write {
                        resource?.uploadComplete(remoteID: result.remoteID, remoteURL: result.remoteURL)
                    }
                    if let localURL = localURL {
                        try FileManager.default.removeItem(at: localURL)
                    }
                    self.finish(error: nil)
                } catch {
                    self.uncacheImage(withKey: cacheKey, completion: { [unowned self] in
                        self.finish(error: .upSyncUpdateDirtyFailed(error: error))
                    })
                }
            })
        } catch {
            finish(error: .upSyncUpdateDirtyFailed(error: error))
        }
    }

    override func cancel() {
        super.cancel()

        currentRequest?.cancel()
    }

    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }
        finish()
    }

    private func cacheImage(withURL url: URL?, key: String, completion: @escaping () -> Void) throws {
        guard let url = url else {
            completion()
            return
        }
        guard let image = UIImage(dataUrl: url) else {
            throw SimpleError(localizedDescription: "couldn't load image with url \(url)")
        }
        log("caching image with key \(key)")
        KingfisherManager.shared.cache.store(image, forKey: key, completionHandler: { (result) in
            completion()
        })
    }

    private func uncacheImage(withKey key: String, completion: @escaping () -> Void) {
        log("uncaching image with key \(key)")
        KingfisherManager.shared.cache.removeImage(forKey: key, completionHandler: completion)
    }
}
