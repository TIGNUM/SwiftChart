
//
//  DownSyncNetworkOperation.swift
//  QOT
//
//  Created by Sam Wyndham on 26.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import Alamofire

final class DownSyncNetworkOperation<T: JSONDecodable>: ConcurrentOperation {

    private let context: SyncContext
    private let sessionManager: SessionManager
    private let syncType: SyncType
    private let lastSyncDate: Date?

    init(context: SyncContext, sessionManager: SessionManager, syncType: SyncType, lastSyncDate: Date?) {
        self.context = context
        self.sessionManager = sessionManager
        self.syncType = syncType
        self.lastSyncDate = lastSyncDate
        super.init()
    }
    
    override func execute() {
        guard let token = context.data["token"] as? String else {
            preconditionFailure("No token")
        }

        let url = syncType.endpoint.url(baseURL: context.baseURL)
        let now = Date()
        sessionManager.request(token: token, url: url, from: lastSyncDate, to: now, page: 1) { [weak self] (result: Result<[DownSyncChange<T>], NetworkError>) in
            guard let context = self?.context, let intermediatesKey = self?.syncType.rawValue else {
                return
            }

            switch result {
            case .success(let changes):
                context.data[intermediatesKey] = DownSyncNetworkResult(changes: changes, syncDate: now)
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
    let syncDate: Date
}

// MARK: Private helpers

fileprivate extension SessionManager {

    func request<T: JSONDecodable>(token: String, url: URL, from: Date?, to: Date, page: Int, accumulator: [DownSyncChange<T>] = [], completion: @escaping (Result<[DownSyncChange<T>], NetworkError>) -> Void) {
        let urlRequest = URLRequest.downSyncRequest(url: url, token: token, from: from, to: to, page: page)
        request(urlRequest, parser: DownSyncResultParser<T>.parse) { [weak self] (result) in
            switch result {
            case .success(let value):
                let changes = accumulator + value.items
                if page >= value.maxPages {
                    completion(.success(changes))
                } else {
                    let page = page + 1
                    self?.request(token: token, url: url, from: from, to: to, page: page, accumulator: changes, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
