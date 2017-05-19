//
//  NetworkFunctions.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

@discardableResult func request<T>(_ urlRequest: URLRequestConvertible, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
    return request(urlRequest)
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
                // FIXME: Determine network error
                let networkError = NetworkError(error: error as NSError, statusCode: response.response?.statusCode)
                result = .failure(networkError)
            }
            completion(result)
    }
}
