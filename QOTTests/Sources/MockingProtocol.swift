//
//  MockingProtocol.swift
//  QOT
//
//  Created by Moucheg Mouradian on 06/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire


enum ReturnedHttpCode: Int {
    case success = 200
    case unauthorized = 401
}

class MockingURLProtocol: URLProtocol {
    
    static var returnedHttpCode: ReturnedHttpCode?
    
    private let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    // MARK: Properties
    private struct PropertyKeys {
        static let handledByForwarderURLProtocol = "HandledByProxyURLProtocol"
    }
    
    lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.ephemeral
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            return configuration
        }()
        let session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return session
    }()
    
    // MARK: Class Request Methods
    override class func canInit(with request: URLRequest) -> Bool {
        return URLProtocol.property(forKey: PropertyKeys.handledByForwarderURLProtocol, in: request) == nil
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard let headers = request.allHTTPHeaderFields else { return request }
        do {
            return try URLEncoding.default.encode(request, with: headers)
        } catch {
            return request
        }
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    // MARK: Loading Methods
    override func startLoading() {
        guard let statusCode = MockingURLProtocol.returnedHttpCode else { return }
        
        if let data = Mocks.find(request),
            let url = request.url,
            let response = HTTPURLResponse(url: url, statusCode: statusCode.rawValue, httpVersion: "HTTP/1.1", headerFields: cannedHeaders) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}

// MARK: NSURLSessionDelegate extension

extension MockingURLProtocol: URLSessionDelegate {
    func URLSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func URLSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let response = task.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}
