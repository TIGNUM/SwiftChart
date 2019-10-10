//
//  QDMUserEventTracking+Ext.swift
//  QOT
//
//  Created by karmic on 19.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMUserEventTracking.Name {
    static let YES_LEAVE = "YES_LEAVE"
    static let AUDIO_SEEK = "AUDIO_SEEK"
    static let MARK_AS_READ = "MARK_AS_READ"
    static let MARK_AS_UNREAD = "MARK_AS_UNREAD"
    static let SEARCH = "SEARCH"
    static let SAVE = "SAVE"
    static let START = "START"
    static let CONTINUE = "CONTINUE"
    static let SKIP = "SKIP"
    static let ALLOW = "ALLOW"
    static let LOG_IN = "LOG_IN"
    static let NEW_USER = "NEW_USER"
    static let VERIFY_EMAIL = "VERIFY_EMAIL"
    static let SEND_CODE = "SEND_CODE"
    static let GET_HELP = "GET_HELP"
    static let CREATE_ACCOUNT = "CREATE_ACCOUNT"
    static let DISMISS_LEFT_TO_RIGHT = "DISMISS_LEFT_TO_RIGHT"
    static let BACK = "BACK"
    static let CHECK_TERMS_PRIVACY = "CHECK_TERMS_PRIVACY"
    static let RESEND_CODE = "RESEND_CODE"
    static let FAST_TRACK = "FAST_TRACK"
    static let GUIDED_TRACK = "GUIDED_TRACK"
    static let GOT_IT = "GOT_IT"
}

public extension QDMUserEventTracking.ValueType {
    static let ASK_PERMISSION_NOTIFICATIONS = "ASK_PERMISSION_NOTIFICATIONS"
    static let SHOW_PRIVACY_POLICY = "SHOW_PRIVACY_POLICY"
    static let SHOW_TERMS_OF_USE = "SHOW_TERMS_OF_USE"
    static let USER_BIRTH_YEAR = "USER_BIRTH_YEAR"
}
