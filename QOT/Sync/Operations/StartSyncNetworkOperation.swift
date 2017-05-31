//
//  StartSyncOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class StartSyncNetworkOperation: ConcurrentOperation {

    private let context: SyncContext
    private let networkManager: NetworkManger
    private let lastSyncDate: Int64

    init(context: SyncContext, networkManager: NetworkManger, lastSyncDate: Int64 = 0) {
        self.context = context
        self.networkManager = networkManager
        self.lastSyncDate = lastSyncDate
    }

    override func execute() {
        let request = StartSyncRequest(from: lastSyncDate)
        networkManager.request(request, parser: StartSyncTokenParser.parse) { [weak self] (result) in
            switch result {
            case .success(let syncToken):
                self?.context.data["syncToken"] = syncToken
            case .failure(let error):
                self?.context.syncFailed(error: error)
            }
            self?.finish()
        }
    }
}
