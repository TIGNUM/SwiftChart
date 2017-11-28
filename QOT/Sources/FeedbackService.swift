//
//  FeedbackService.swift
//  QOT
//
//  Created by Lee Arromba on 28/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class FeedbackService {

    private let mainRealm: Realm
    private let realmProvider: RealmProvider
    
    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }
    
    @discardableResult func recordFeedback(message: String) throws -> UserFeedback {
        let feedback = UserFeedback(message: message)
        try mainRealm.write {
            mainRealm.add(feedback)
        }
        return feedback
    }
}
