//
//  JSONKey.swift
//  QOT
//
//  Created by Sam Wyndham on 20.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum JsonKey: String {

    case `default`
    case answer
    case answerId
    case answers
    case answerType
    case associatedValueId
    case associatedValueType
    case attendees
    case attitude
    case availability
    case base64Data
    case birthdate
    case block
    case body
    case boolValue
    case calendarId
    case calendarItemExternalId
    case calendarName
    case categoryIds
    case city
    case colorState
    case company
    case component
    case completed
    case completedAt
    case contentCategoryId
    case contentId
    case contentItemId
    case contentRelationType
    case coordinates
    case country
    case covered
    case createdAt
    case dataAverage
    case dataPoints
    case day
    case dailyPrepResults
    case dayOfTheWeek
    case daysOfTheMonth
    case daysOfTheWeek
    case daysOfTheYear
    case decisions
    case description
    case deviceId
    case displayName
    case displayTime
    case displayType
    case duration
    case email
    case employment
    case end
    case endDate
    case esbDomain
    case eventId
    case feature
    case featureButton
    case featureLink
    case feedback
    case fitbitState
    case firstDayOfTheWeek
    case firstName
    case floor
    case format
    case frequency
    case fromDate
    case greeting
    case gender
    case guideItemType
    case height
    case heightUnit
    case heightUnits
    case horizontalAccuracy
    case hour
    case id
    case idOfRelatedEntity
    case images
    case imageURL
    case increment
    case interval
    case isAllDay
    case isCurrentUser
    case isDetached
    case isodate
    case issueDate
    case jobTitle
    case key
    case keypathID
    case lastName
    case lastVisitedDate
    case latestVersion
    case latitude
    case layoutInfo
    case learnItems
    case link
    case location
    case longitude
    case longValue
    case lowerThreshold
    case max
    case maximum
    case maxPages
    case maxResults
    case mediaEntity
    case mediaFormat
    case mediaId
    case mediaURL
    case mediaUrl
    case memberSince
    case message
    case min
    case minute
    case modifiedAt
    case monthsOfTheYear
    case multiplier
    case name
    case nano
    case nextSyncToken
    case note
    case notes
    case notificationId
    case notificationItems
    case occurrenceCount
    case occurrenceDate
    case occurrenceValue
    case organizer
    case ownText
    case page
    case pageId
    case pageIds
    case pageSize
    case periods
    case permissionState
    case planItemID
    case publicHolidays
    case preparationId
    case priority
    case qotId
    case qotPartnerUserId
    case question
    case questionId
    case questionDescription
    case questionGroupId
    case questionGroups
    case questionTitle
    case radius
    case recurranceEnd
    case recurrenceRules
    case referrerAssociatedValueId
    case referrerAssociatedValueType
    case referrerPageId
    case relatedContent
    case relatedContentIds
    case relationship
    case reminderTime
    case resultList
    case role
    case searchTags
    case secondsRequired
    case section
    case seconds
    case serverPush
    case setPositions
    case settingBoolValue
    case settingBoolValueDtos
    case settingId
    case settingImageValueDtos
    case settingLongValue
    case settingLongValueDtos
    case settingOccurrenceValue
    case settingOccurrenceValueDtos
    case settingsIds
    case settingTextValue
    case settingTextValueDtos
    case shortDescription
    case sortOrder
    case sound
    case start
    case startDate
    case status
    case street
    case streetNumber
    case subject
    case subtitle
    case syncEnabled
    case syncStatus
    case syncTime
    case syncTokenHeaderKey
    case tabs
    case targetGroupId
    case targetGroupName
    case targetType
    case targetTypeId
    case teamAverage
    case telephone
    case telephoneNumber
    case text
    case textValue
    case thumbnail
    case thresholds
    case timestamp
    case timeZone
    case timeZoneId
    case title
    case totalUsageTime
    case type
    case unit
    case universe
    case untilDate
    case updateUrl
    case upperThreshold
    case urbanAirshipTags
    case url
    case userAnswer
    case userAnswers
    case userAverage
    case userId
    case userImageURL
    case userInfo
    case userPreparationId
    case vacation
    case validFrom
    case validUntil
    case value
    case verticalAccuracy
    case viewed
    case visited
    case waveformData
    case weekend
    case weekNumber
    case weeksOfTheYear
    case weight
    case weightUnit
    case weightUnits
    case workingDays
    case yearMonthDay
    case zip
    case zone
    case maxValueOf
    case decimalPlaces

    var value: String {
        return rawValue
    }
}
