//
//  Partner.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class Partner: Object {
    
    // MARK: Private Properties
    
    private let _remoteID = RealmOptional<Int>(nil)
    
    // MARK: Public Properties
    
    private(set) dynamic var localID: String = UUID().uuidString
    
    dynamic var name: String?

    dynamic var surname: String?
    
    dynamic var relationship: String?
    
    dynamic var email: String?
    
    dynamic var profileImageURL: String?
    
    // MARK: Functions
    
    convenience init(localID: String, name: String?, surname: String?, relationship: String?, email: String?, profileImageURL: String?) {
        self.init()
        self.localID = localID
        self.name = name
        self.surname = surname
        self.relationship = relationship
        self.email = email
        self.profileImageURL = profileImageURL
    }
    
    override class func primaryKey() -> String? {
        return "localID"
    }
}
