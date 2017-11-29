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

    @objc dynamic var profileImageResource: MediaResource? = MediaResource()

    @objc dynamic var headline: String?

    @objc dynamic var subHeadline: String?

    @objc dynamic var text: String?

    @objc dynamic var date: Date = Date.distantPast // We need distantPast so that setData works correctly

    @objc dynamic var changeStamp: String? = UUID().uuidString

    override func didSetRemoteID() {
        profileImageResource?.relatedEntityID.value = remoteID.value
    }
}

extension MyToBeVision: TwoWaySyncableUniqueObject {

    func setData(_ data: MyToBeVisionIntermediary, objectStore: ObjectStore) throws {
        /*
         FIXME: HACK!!!! API accepts a dictionary of MyToBeVision properties for upload but returns an array of all
         previous my to be visions on download rather than the most recent version. So we will only set the data if the
         data is later then the current data. DISCUSS WITH BACKEND
         */
        guard data.validFrom > date else {
            return
        }

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
