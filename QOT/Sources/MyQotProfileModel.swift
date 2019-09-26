//
//  MyQotModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MyQotProfileModel {

    struct TableViewPresentationData {
        let headingKey: String
        let heading: String
        let subHeading: String
    }

    struct HeaderViewModel {
        let user: UserProfileModel?
        let memberSinceTitle: String?

        var memberSinceContentTitle: String {
            return memberSinceTitle ?? ""
        }

        var name: String? {
            return user?.name
        }

        var memberSince: String? {
            guard let user = self.user else { return nil }
            let date = DateFormatter.memberSince.string(from: user.memberSince)
            return memberSinceContentTitle + " " + date
        }
    }
}
