//
//  MyToBeVision.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class MyToBeVision: SyncableObject {
    
    dynamic var headline: String?
    
    dynamic var subHeadline: String?
    
    dynamic var text: String?
    
    dynamic var profileImageResource: MediaResource?
    
    dynamic var date: Date = Date()

    dynamic var changeStamp: String? = UUID().uuidString

    // MARK: Functions
    
    convenience init(localID: String, headline: String?, subHeadline: String?, text: String?, profileImageResource: MediaResource, date: Date) {
        self.init()
        self.localID = localID
        self.headline = headline
        self.subHeadline = subHeadline
        self.text = text
        self.profileImageResource = profileImageResource
        self.date = date

        dirty = true
    }
    
    override func didSetRemoteID() {
        profileImageResource?.relatedEntityID.value = remoteID.value
    }
}

extension MyToBeVision: TwoWaySyncableUniqueObject {

    func setData(_ data: MyToBeVisionIntermediary, objectStore: ObjectStore) throws {
        headline = data.headline
        subHeadline = data.subHeadline
        text = data.text
        date = data.validFrom
        profileImageResource?.remoteURLString = data.remoteProfileImageURL
    }

    static func object(remoteID: Int, store: ObjectStore) throws -> MyToBeVision? {
        return store.objects(MyToBeVision.self).first
    }

    static var endpoint: Endpoint {
        return .myToBeVision
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else { return nil }

        let dict: [JsonKey: JSONEncodable] = [
            .syncStatus: syncStatus.rawValue,
            .title: headline.toJSONEncodable,
            .shortDescription: subHeadline.toJSONEncodable,
            .description: text.toJSONEncodable,
            .validFrom: date
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}
