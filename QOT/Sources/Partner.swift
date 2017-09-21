//
//  Partner.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class Partner: SyncableObject {

    // MARK: Public Properties

    static var endpoint: Endpoint {
        return .partner
    }

    @objc dynamic var profileImageResource: MediaResource? = MediaResource()
    
    @objc dynamic var name: String = ""

    @objc dynamic var surname: String = ""
    
    @objc dynamic var relationship: String?
    
    @objc dynamic var email: String = ""

    @objc dynamic var deleted: Bool = false

    @objc dynamic var changeStamp: String? = UUID().uuidString
    
    override func didSetRemoteID() {
        profileImageResource?.relatedEntityID.value = remoteID.value
    }
}

extension Partner: TwoWaySyncable {

    func setData(_ data: PartnerIntermediary, objectStore: ObjectStore) throws {
        name = data.name
        surname = data.surname
        relationship = data.relationship
        email = data.email
        profileImageResource?.remoteURLString = data.remoteProfileImageURL
    }

    func toJson() -> JSON? {
        guard syncStatus != .clean else { return nil }

        let dict: [JsonKey: JSONEncodable] = [
            .id: remoteID.value.toJSONEncodable,
            .createdAt: createdAt,
            .modifiedAt: modifiedAt,
            .syncStatus: syncStatus.rawValue,
            .qotId: localID,
            .email: email,
            .firstName: name,
            .lastName: surname,
            .relationship: relationship.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension Partner {
    var initials: String {
        var initials = ""
        if let initial = name.characters.first {
            initials += String(initial)
        }
        if let initial = surname.characters.first {
            initials += String(initial)
        }
        return initials
    }
}
