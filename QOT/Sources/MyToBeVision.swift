//
//  MyToBeVision.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

final class MyToBeVision: Object, MyToBeVisionWireframe {
    
    // MARK: Private Properties
    
    private let _remoteID = RealmOptional<Int>(nil)
    
    // MARK: Public Properties
    
    private(set) dynamic var localID: String = UUID().uuidString
    
    dynamic var headline: String?
    
    dynamic var subHeadline: String?
    
    dynamic var text: String?
    
    dynamic var profileImageURL: String?
    
    dynamic var date: Date?
    
    // MARK: Functions
    
    convenience init(localID: String, headline: String?, subHeadline: String?, text: String?, profileImageURL: String?, date: Date?) {
        self.init()
        self.localID = localID
        self.headline = headline
        self.subHeadline = subHeadline
        self.text = text
        self.profileImageURL = profileImageURL
        self.date = date
    }
    
    override class func primaryKey() -> String? {
        return "localID"
    }
}
