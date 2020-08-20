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
    static let EDIT_LIBRARY = "EDIT_LIBRARY"
    static let MUTE_VIDEO = "MUTE_VIDEO"
    static let UNMUTE_VIDEO = "UNMUTE_VIDEO"
    static let READ_MORE = "READ_MORE"
    static let ORIENTATION_CHANGE = "ORIENTATION_CHANGE"
    static let GET_STARTED = "GET_STARTED"
    static let AUDIO_PLAYBACK_SPEED = "AUDIO_PLAYBACK_SPEED"
    static let CHECK_DONT_SHOW_EXPLAINER = "CHECK_DONT_SHOW_EXPLAINER"
    static let ACCEPT_TEAM_INVITATION = "ACCEPT_TEAM_INVITATION"
    static let DECLINE_TEAM_INVITATION = "DECLINE_TEAM_INVITATION"
    static let OPEN_TEAM_LIBRARY = "OPEN_TEAM_LIBRARY"
}

public extension QDMUserEventTracking.ValueType {
    static let ASK_PERMISSION_NOTIFICATIONS = "ASK_PERMISSION_NOTIFICATIONS"
    static let SHOW_PRIVACY_POLICY = "SHOW_PRIVACY_POLICY"
    static let SHOW_TERMS_OF_USE = "SHOW_TERMS_OF_USE"
    static let USER_BIRTH_YEAR = "USER_BIRTH_YEAR"
    static let LANDSCAPE = "LANDSCAPE"
    static let PORTRAIT = "PORTRAIT"
    static let FEATURE_EXPLAINER = "FEATURE_EXPLAINER"
    static let WRITE_TEAM_TBV = "WRITE_TEAM_TBV"
    static let PICK_TEAM_TBV_IMAGE = "PICK_TEAM_TBV_IMAGE"
    static let EDIT_TEAM_TBV = "EDIT_TEAM_TBV"
    static let TEAM_LIBRARY_ITEM = "TEAM_LIBRARY_ITEM"
    static let START_RATING = "START_RATING"
    static let TEAM_TO_BE_VISION_RATING = "TEAM_TO_BE_VISION_RATING"
}

public extension QDMUserEventTracking.Action {
    static let ROTATE = "ROTATE"
    static let NONE = "NONE"
    static let AUTOMATIC = "AUTOMATIC"
}
