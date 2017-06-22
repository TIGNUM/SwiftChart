//
//  JSONKey.swift
//  QOT
//
//  Created by Sam Wyndham on 20.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum JsonKey: String {
    case associatedValueId
    case associatedValueType
    case attendees
    case availability
    case birthdate
    case calendarId
    case calendarItemExternalId
    case calendarName
    case categoryIds
    case city
    case company
    case contentId
    case coordinates
    case country
    case createdAt
    case dayOfTheWeek
    case daysOfTheMonth
    case daysOfTheWeek
    case daysOfTheYear
    case description
    case displayName
    case duration
    case email
    case employment
    case endDate
    case firstDayOfTheWeek
    case firstName
    case format
    case frequency
    case gender
    case height
    case heightUnit
    case heightUnits
    case id
    case imageURL
    case increment
    case interval
    case isAllDay
    case isCurrentUser
    case isDetached
    case jobTitle
    case keypathID
    case lastName
    case latitude
    case layoutInfo
    case location
    case qotId
    case longitude
    case maxPages
    case maxResults
    case mediaURL
    case memberSince
    case modifiedAt
    case monthsOfTheYear
    case name
    case nextSyncToken
    case notes
    case occurrenceCount
    case occurrenceDate
    case organizer
    case page
    case pageId
    case pageSize
    case radius
    case recurranceEnd
    case recurrenceRules
    case referrerAssociatedValueId
    case referrerAssociatedValueType
    case referrerPageId
    case relatedContentIds
    case resultList
    case role
    case searchTags
    case secondsRequired
    case section
    case setPositions
    case settingsIds
    case sortOrder
    case startDate
    case status
    case street
    case streetNumber
    case subtitle
    case syncStatus
    case syncTime
    case syncTokenHeaderKey
    case tabs
    case telephone
    case text
    case thumbnail
    case timestamp
    case timeZoneId
    case title
    case type
    case url
    case userImageURL
    case userInfo
    case value
    case viewed
    case waveformData
    case weekNumber
    case weeksOfTheYear
    case weight
    case weightUnit
    case weightUnits
    case zip
    case zone

    var value: String {
        return rawValue
    }
}
