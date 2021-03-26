//
//  SessionService+Convenience.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright © 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension SessionService {
    var isUsersVeryFirstAppStart: Bool {
        let emails = UserDefault.didShowCoachMarks.object as? [String]
        if let email = getCurrentSession()?.useremail {
            return emails?.contains(obj: email) == false
        }
        return false
    }
}
