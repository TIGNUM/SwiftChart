//
//  MockNetworkManager.swift
//  QOT
//
//  Created by Sam Wyndham on 09.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

class MockNetworkManager: NetworkManager {
    override func request<T>(_ urlRequest: URLRequestBuildable, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                do {
                    completion(.success(try parser(self.data(for: urlRequest))))
                } catch let error {
                    fatalError("failed to parse mock json for request: \(urlRequest), error: \(error)")
                }
            }
        }

        return SerialRequest()
    }

    private func data(for request: URLRequestBuildable) -> Data {
        let name: String
        switch request.endpoint {
        case .startSync:
            name = "MockStartSync"
        case .contentCategories:
            name = "MockContentCategoryDown"
        case .contentCollection:
            name = "MockDownSyncContentCollection"
        case .contentItems:
            name = "MockContentItemDown"
        case .downSyncConfirm:
            name = "MockDownSyncConfirm"
        case .user:
            name = "MockUserDown"
        case .page:
            name = "MockPageDown"
        default:
            fatalError("Unsupported request for MockNetworkManager")
        }

        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            fatalError("No mock json with name: \(name)")
        }

        do {
            return try Data(contentsOf: url)
        } catch let error {
            fatalError("Cannot load data at url: \(url), error: \(error)")
        }
    }
}
