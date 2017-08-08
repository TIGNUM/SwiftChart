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
    private let item: MediaResource
    private let isFinalOperation: Bool
    
    init(networkManager: NetworkManager,
         realmProvider: RealmProvider,
         syncContext: SyncContext,
         item: MediaResource,
         isFinalOperation: Bool) {
        self.networkManager = networkManager
        self.realmProvider = realmProvider
        self.context = syncContext
        self.item = item
        self.isFinalOperation = isFinalOperation
    }
    
    override func execute() {
        guard context.state != .finished else {
            finish()
            return
        }
        
        fetchSyncToken()
    }
    
    // MARK: Steps
    
    private func fetchSyncToken() {
        let request = StartSyncRequest(from: 0) // Any from value is fine here as it is ignored by the server
        networkManager.request(request, parser: StartSyncResult.parse) { [weak self] (result) in
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
            if let data = try item.upSyncData(realm: realmProvider) {
                sendData(data, syncToken: syncToken)
            } else {
                finish(error: nil)
            }
        } catch let error {
            finish(error: .upSyncFetchDirtyFailed(error: error))
        }
    }

    private func sendData(_ data: UpSyncMediaData, syncToken: String) {
        let request = UpSyncRequest(endpoint: item.endpoint, body: data.body, syncToken: syncToken)
        networkManager.request(request, parser: UpSyncMediaResultParser.parse) { [weak self] (result) in
            switch result {
            case .success(let upSyncResult):
                self?.handleResult(upSyncResult)
            case .failure(let error):
                self?.finish(error: .upSyncSendDirtyFailed(error: error))
            }
        }
    }
    
    private func handleResult(_ result: UpSyncMediaResult) {
        guard let localURL = item.localURL else {
            let error = SimpleError(localizedDescription: "missing local url")
            finish(error: .upSyncUpdateDirtyFailed(error: error))
            return
        }
        let cacheKey = result.remoteURLString
        do {
            try cacheImage(withURL: localURL, key: cacheKey, completion: { [unowned self] in
                do {
                    let realm = try self.realmProvider.realm()
                    try realm.write {
                        self.item.remoteID.value = result.remoteID
                        self.item.localURLString = nil
                        self.item.remoteURLString = result.remoteURLString
                    }
                    try FileManager.default.removeItem(at: localURL)
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
    
    private func finish(error: SyncError?) {
        if let error = error {
            context.add(error: error)
        }
        
        if isFinalOperation {
            context.finish()
        }
        
        finish()
    }
    
    private func cacheImage(withURL url: URL, key: String, completion: @escaping () -> Void) throws {
        guard let image = UIImage(dataUrl: url) else {
            throw SimpleError(localizedDescription: "couldn't load image with url \(url)")
        }
        log("caching image with key \(key)")
        KingfisherManager.shared.cache.store(image, forKey: key, completionHandler: completion)
    }
    
    private func uncacheImage(withKey key: String, completion: @escaping () -> Void) {
        log("uncaching image with key \(key)")
        KingfisherManager.shared.cache.removeImage(forKey: key, completionHandler: completion)
    }
}
