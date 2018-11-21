//
//  RemoteLog.swift
//  QOT
//
//  Created by Lee Arromba on 11/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import SwiftyBeaver
import Alamofire
import RealmSwift

final class RemoteLogDestination: BaseDestination {
    private enum ErrorType: Error {
        case serialization
    }

    private let session: URLSession
    private let remoteURL: URL?
    private let headers: [String: String]
    private let dateFormatter: DateFormatter
    private let realmProvider: RealmProvider
    private var userID: Int? {
        let realm = try? realmProvider.realm()
        return realm?.objects(User.self).first?.remoteID.value
    }
    private let reachabilityManager: Alamofire.NetworkReachabilityManager?
    private var reachabilityStatus: String {
        if reachabilityManager?.isReachableOnEthernetOrWiFi ?? false {
            return "wifi"
        }
        if reachabilityManager?.isReachableOnWWAN ?? false {
            return "wwan"
        }
        return "other"
    }
    override public var asynchronously: Bool {
        get {
            return false
        }
        set {
            return
        }
    }

    override init() {
        session = URLSession(configuration: .default)
        reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
        #if DEBUG
            remoteURL = URL(string: "https://esb.tignum.com/personal/p/qot/log")
        #else
            remoteURL = URL(string: "https://esb.tignum.com/personal/p/qot/log")
        #endif
        headers = [HTTPHeader.contentType.rawValue: "application/json"]
        dateFormatter = DateFormatter()
        realmProvider = RealmProvider()

        super.init()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        reachabilityManager?.startListening()
    }

    override public func send(_ level: SwiftyBeaver.Level,
                              msg: String,
                              thread: String,
                              file: String,
                              function: String,
                              line: Int,
                              context: Any? = nil) -> String? {
        guard level.rawValue >= minLevel.rawValue else {
            return nil
        }
        let logInfo = LogInfo(
            userId: userID,
            deviceId: deviceID,
            deviceModel: UIDevice.current.modelName,
            iosVersion: UIDevice.current.systemVersion,
            qotVersion: Bundle.main.versionNumber,
            connectivity: reachabilityStatus,
            timestamp: dateFormatter.string(from: Date()),
            logLevel: level.rawValue,
            thread: Thread.current.description,
            file: file,
            message: msg,
            function: function,
            line: line
        )
        send(logInfo)
        return logInfo.jsonString
    }

    // MARK: - private

    private func send(_ logInfo: LogInfo) {
        guard let remoteURL = remoteURL else { return }
        Alamofire.request(remoteURL, method: .put,
                          parameters: logInfo.json,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON { response in
            if let error = response.result.error {
                print(error)
            }
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Response: \(utf8Text)")
//            }
        }
    }
}
