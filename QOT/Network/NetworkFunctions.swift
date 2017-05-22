//
//  NetworkFunctions.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

@discardableResult func request<T>(_ urlRequest: URLRequestConvertible, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
    return Alamofire.request(urlRequest)
        .validate(statusCode: 200..<300)
        .responseData { response in
            let result: Result<T, NetworkError>
            switch response.result {
            case .success(let data):
                do {
                    result = .success(try parser(data))
                } catch let error {
                     result = .failure(.failedToParseData(data, error: error))
                }
            case .failure(let error):
                let networkError = NetworkError(error: error as NSError, statusCode: response.response?.statusCode)
                result = .failure(networkError)
            }
            completion(result)
    }
}

enum DownSyncRequestResult<T: JSONDecodable> {
    case success(items: [DownSyncNetworkItem<T>], nextSyncToken: String)
    case failure(NetworkError)
}

@discardableResult func requestDownSyncItems<T: JSONDecodable>(_ urlRequest: URLRequestConvertible, completion: @escaping (DownSyncRequestResult<T>) -> Void) -> DataRequest {
    // FIXME: Implement request handling paged results
    return Alamofire.request(urlRequest)
}

