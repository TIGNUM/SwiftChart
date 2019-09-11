//
//  AskPermissionModel.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct AskPermission {
    enum Kind: String {
        case location
        case notification
        case notificationOpenSettings
        case calendar
        case calendarOpenSettings

        var contentId: Int {
            switch self {
            case .location:
                return 102076
            case .notification:
                return 102038
            case .notificationOpenSettings:
                return 102107
            case .calendar:
                return 102039
            case .calendarOpenSettings:
                return 102041
            }
        }

        var titleTag: String {
            return self.rawValue + "_permission_title"
        }

        var bodyTag: String {
            return self.rawValue + "_permission_body"
        }

        var buttonConfirmTag: String {
            return self.rawValue + "_permission_button_confirm"
        }

        var buttonCancelTag: String {
            return self.rawValue + "_permission_button_cancel"
        }
    }

    struct ViewModel {
        let title: String?
        let description: String?
        let imageURL: URL?
        let buttonTitleCancel: String?
        let buttonTitleConfirm: String?
    }
}
