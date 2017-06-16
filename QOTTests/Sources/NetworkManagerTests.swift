//
//  NetworkManagerTests.swift
//  QOT
//
//  Created by Moucheg Mouradian on 06/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import XCTest
@testable import QOT
@testable import Freddy
@testable import Alamofire

class NetworkManagerTests: XCTestCase {
    
    private let timeout: TimeInterval = 1
    private var networkManager: NetworkManager!

    
    private let username = "someRandomUsername"
    private let password = "someRandomPassword"
    private let token = Mocks.mockedToken
    
    func setup() {
        
        MockingURLProtocol.returnedHttpCode = .success
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        
        let sessionManager = SessionManager(configuration: configuration)
        let credentialsManager = CredentialsManager()
        credentialsManager.credential = Credential(username: username, password: password, token: token)
        let requestBuilder = URLRequestBuilder(baseURL: URL(string: "http://localhost")!, deviceID: "Some ID")
        
        networkManager = NetworkManager(sessionManager: sessionManager, credentialsManager: credentialsManager, requestBuilder: requestBuilder)
    }
    
    func setupCredentialsTest(_ httpCodeToReturn: ReturnedHttpCode) {
        
        MockingURLProtocol.returnedHttpCode = httpCodeToReturn
        
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockingURLProtocol.self]
            return configuration
        }()
        
        let sessionManager = SessionManager(configuration: configuration)
        let credentialsManager = CredentialsManager()
        credentialsManager.credential = Credential(username: username, password: password, token: nil)
        let requestBuilder = URLRequestBuilder(baseURL: URL(string: "http://localhost")!, deviceID: "Some ID")
        
        networkManager = NetworkManager(sessionManager: sessionManager, credentialsManager: credentialsManager, requestBuilder: requestBuilder)
    }
    
    //Mark: Tests
    
    func test_networkRequest_badToken() {
        
        setup()
        
        let token = "someRandomValueAsToken"
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(_):
                XCTAssert(true)
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_networkRequest_correctToken() {
        
        setup()
        
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error.type {
                case .unauthenticated:
                    XCTAssert(false)
                default:
                    XCTAssert(true)
                }
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_networkRequest_authenticationFail() {
        
        setupCredentialsTest(.unauthorized)
        
        let token = "someRandomValueAsToken"
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error.type {
                case .unauthenticated:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_networkRequest_authenticationSuccess() {
        
        setupCredentialsTest(.success)
        
        let token = "someRandomValueAsToken"
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(true)
            case .failure(let error):
                switch error.type {
                case .unauthenticated:
                    XCTAssert(false)
                default:
                    XCTAssert(true)
                }
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func test_networkRequest_failedToParseData() {
        
        setup()
        
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error.type {
                case .failedToParseData(_):
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

    func test_networkRequest_cancelledRequest() {
        
        setupCredentialsTest(.success)
        
        let page = 1
        let endPoint: Endpoint = .startSync
        let accumulator: [DownSyncChange<ContentCategoryData>] = []
        
        let expectation = self.expectation(description: "")
        
        let request = networkManager.request(token: token, endpoint: endPoint, page: page, accumulator: accumulator, completion: { result in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                switch error.type {
                case .cancelled:
                    XCTAssert(true)
                default:
                    XCTAssert(false)
                }
            }
            
            expectation.fulfill()
        })
        
        request.cancel()
        
        waitForExpectations(timeout: timeout, handler: nil)
    }

}
