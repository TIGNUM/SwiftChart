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

final class Partner: Object, PartnerWireframe, UpSyncableWithLocalAndRemoteIDs {

    // MARK: Public Properties

    static var endpoint: Endpoint {
        return .partner
    }

    let remoteID = RealmOptional<Int>(nil)

    dynamic var createdAt: Date = Date()

    dynamic var modifiedAt: Date = Date()
    
    private(set) dynamic var localID: String = UUID().uuidString
    
    dynamic var name: String?

    dynamic var surname: String?
    
    dynamic var relationship: String?
    
    dynamic var email: String?

    dynamic var profileImageURL: String?

    dynamic var deleted: Bool = false

    dynamic var localChangeID: String? = UUID().uuidString
    
    // MARK: Functions
    
    convenience init(localID: String, name: String?, surname: String?, relationship: String?, email: String?, profileImageURL: String?) {
        self.init()
        self.localID = localID
        self.name = name
        self.surname = surname
        self.relationship = relationship
        self.email = email
        self.profileImageURL = profileImageURL

        dirty = true
    }
    
    override class func primaryKey() -> String? {
        return "localID"
    }
}

extension Partner: DownSyncable {

    static func make(remoteID: Int, createdAt: Date) -> Partner {
        let partner = Partner()
        partner.remoteID.value = remoteID
        partner.createdAt = createdAt
        return partner
    }

    func setData(_ data: PartnerIntermediary, objectStore: ObjectStore) throws {
        name = data.name
        surname = data.surname
        relationship = data.relationship
        email = data.email
        // FIXME: We need to do something with remoteProfileImageURL
    }
}

extension Partner {

    func json() -> JSON? {
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

    static var jsonEncoder: (Partner) -> JSON? {
        return { (partner) in
            return partner.json()
        }
    }
}
