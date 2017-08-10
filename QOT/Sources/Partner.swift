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
    
    dynamic var name: String?

    dynamic var surname: String?
    
    dynamic var relationship: String?
    
    dynamic var email: String?

    dynamic var profileImageResource: MediaResource?

    dynamic var deleted: Bool = false

    dynamic var changeStamp: String? = UUID().uuidString
    
    // MARK: Functions
    
    convenience init(localID: String, name: String?, surname: String?, relationship: String?, email: String?, profileImageResource: MediaResource) {
        self.init()
        self.localID = localID
        self.name = name
        self.surname = surname
        self.relationship = relationship
        self.email = email
        self.profileImageResource = profileImageResource

        dirty = true
    }
    
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
            .email: email.toJSONEncodable,
            .firstName: name.toJSONEncodable,
            .lastName: surname.toJSONEncodable,
            .relationship: relationship.toJSONEncodable
        ]
        return .dictionary(dict.mapKeyValues({ ($0.rawValue, $1.toJSON()) }))
    }
}

extension Partner {
    var initials: String {
        var initials = ""
        if let initial = name?.characters.first {
            initials += String(initial)
        }
        if let initial = surname?.characters.first {
            initials += String(initial)
        }
        return initials
    }
}
