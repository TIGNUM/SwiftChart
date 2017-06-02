
//
//  DownSyncNetworkOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

final class DownSyncNetworkOperation<T: JSONDecodable>: ConcurrentOperation {

    private let context: SyncContext
    private let networkManager: NetworkManger
    private let syncType: SyncType

    init(context: SyncContext, networkManager: NetworkManger, syncType: SyncType) {
        self.context = context
        self.networkManager = networkManager
        self.syncType = syncType
        super.init()
    }
    
    override func execute() {
        guard let token = context[.syncToken] as? String else {
            preconditionFailure("No token")
        }

        networkManager.request(token: token, endpoint: syncType.endpoint, page: 1) { [weak self] (result: Result<[DownSyncChange<T>], NetworkError>) in
            guard let context = self?.context, let intermediatesKey = self?.syncType.rawValue else {
                return
            }

            switch result {
            case .success(let changes):
                context[intermediatesKey] = DownSyncNetworkResult(changes: changes, syncDate: 0)
            case .failure(let error):
                context.syncFailed(error: error)
            }
            self?.finish()
        }
    }
}

// MARK: Helper types

struct DownSyncNetworkResult<T> {
    let changes: [DownSyncChange<T>]
    let syncDate: Int64
}

// MARK: Private helpers

fileprivate extension NetworkManger {

    func request<T: JSONDecodable>(token: String, endpoint: Endpoint, page: Int, accumulator: [DownSyncChange<T>] = [], completion: @escaping (Result<[DownSyncChange<T>], NetworkError>) -> Void) {
        let urlRequest = DownSyncRequest(endpoint: endpoint, syncToken: token, page: 1)
        self.request(urlRequest, parser: DownSyncResultParser<T>.parse) { [weak self] (result) in
            switch result {
            case .success(let value):
                let changes = accumulator + value.items
                if page >= value.maxPages {
                    completion(.success(changes))
                } else {
                    let page = page + 1
                    self?.request(token: token, endpoint: endpoint, page: page, accumulator: changes, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
