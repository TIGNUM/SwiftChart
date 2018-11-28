//
//  GuideItemFactory.swift
//  QOT
//
//  Created by Sam Wyndham on 23/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Rswift

struct GuideItemFactory: GuideItemFactoryProtocol {
    enum contentID: Int {
        case whyDPMCollectionID = 101167
        case performanceFoundationCategoryID = 100006
        case QOTBenefitContentID = 100101
        case QOTBenefitsBodyID = 104167
    }

    let services: Services

    func makeItem(with item: GuideDailyPrepResult) -> Guide.Item? {
        guard let item = item as? DailyPrepResultObject else { return nil }
        return guideItem(with: item)
    }

    func makeItem(with item: GuideLearnItem) -> Guide.Item? {
        guard let item = item as? RealmGuideItemLearn else { return nil }
        return guideItem(with: item)
    }

    func makeItem(with item: GuideNotificationItem) -> Guide.Item? {
        guard let item = item as? RealmGuideItemNotification else { return nil }
        return guideItem(with: item)
    }

    func makeItem(with item: GuideNotificationConfiguration, date: ISODate) -> Guide.Item? {
        guard let item = item as? NotificationConfigurationObject else { return nil }
        return guideItem(with: item, isoDate: date)
    }

    func makeMessageText(with greeting: Guide.Message) -> String {
        return services.contentService.defaultMessage(greeting.rawValue)
    }

    func userName() -> String? {
        return services.mainRealm.objects(User.self).first?.givenName
    }

    func makePreparationItem(status: Guide.Item.Status,
                             representsMultiple: Bool,
                             startsTomorrow: Bool,
                             preparationLocalID: String?) -> Guide.Item? {
        guard let (title, content) = preparationItemStrings(status: status,
                                                            representsMultiple: representsMultiple,
                                                            startsTomorrow: startsTomorrow,
                                                            preparationLocalID: preparationLocalID) else { return nil }
        let link: URL?
        if let localID = preparationLocalID {
            link = URL(string: "qot://preparation#\(localID)")
        } else {
            link = URL(string: "qot://prepare-my-preps")
        }
        return Guide.Item(status: status,
                          title: title,
                          content: .preparation(title: title, body: content),
                          subtitle: R.string.localized.guideCardPreparationSubtitle(),
                          isDailyPrep: false,
                          isLearningPlan: true,
                          isWhatsHot: false,
                          isToBeVision: false,
                          isPreparation: true,
                          link: link,
                          featureLink: nil,
                          featureButton: nil,
                          identifier: "",
                          affectsTabBarBadge: false)
    }

    func makeWhatsHotItem() -> [(Date, Guide.Item)] {
        let whatsHotArticles = services.contentService.whatsHotArticles()
        var whatsHotItems: [(Date, Guide.Item)] = []
        for article in whatsHotArticles {
            if
                let collectionId = article.remoteID.value,
                let body = services.contentService.contentItems(contentCollectionID: collectionId).first?.valueText {
                let link = URL(string: String(format: "qot://feature-explainer?contentID=%d", collectionId))
                let content = Guide.Item.Content.whatsHotArticle(title: article.title,
                                                                 body: body,
                                                                 image: article.thumbnailURL)
                whatsHotItems.append((article.editedAt, Guide.Item(status: article.viewed == true ? .done : .todo,
                                                                   title: "",
                                                                   content: content,
                                                                   subtitle: "",
                                                                   isDailyPrep: false,
                                                                   isLearningPlan: false,
                                                                   isWhatsHot: true,
                                                                   isToBeVision: false,
                                                                   isPreparation: false,
                                                                   link: link,
                                                                   featureLink: nil,
                                                                   featureButton: nil,
                                                                   identifier: article.localID,
                                                                   affectsTabBarBadge: true)))
            }
        }
        return whatsHotItems
    }

    func makeToBeVisionItem() -> Guide.Item {
        let myToBeVision = services.userService.myToBeVision()
        var isToBeVisionDone: Bool = (myToBeVision?.needsToRemind == false)
        var title = myToBeVision?.headline?.uppercased()
        var body = myToBeVision?.text
        if  title == nil ||
            body == nil ||
            title?.isTrimmedTextEmpty == true ||
			body?.isTrimmedTextEmpty == true ||
			body == services.contentService.toBeVisionMessagePlaceholder() {
                title = R.string.localized.guideToBeVisionNotFisishedTitle()
                body = R.string.localized.guideToBeVisionNotFisishedMessage()
                isToBeVisionDone = false
        }

        return Guide.Item(status: isToBeVisionDone == true ? .done : .todo,
                          title: "",
                          content: .toBeVision(title: title ?? "", body: body ?? "", image: myToBeVision?.imageURL),
                          subtitle: "",
                          isDailyPrep: false,
                          isLearningPlan: false,
                          isWhatsHot: false,
                          isToBeVision: true,
                          isPreparation: false,
                          link: URL(string: "qot://to-be-vision"),
                          featureLink: nil,
                          featureButton: nil,
                          identifier: "",
                          affectsTabBarBadge: true)
    }
}

private extension GuideItemFactory {

    func guideItem(with result: DailyPrepResultObject) -> Guide.Item? {
        let items = dailyPrepItems(answers: Array(result.answers))
        let content: Guide.Item.Content = .dailyPrep(items: items, feedback: result.feedback,
                                                     whyDPMTitle: nil, whyDPMDescription: nil)
        return Guide.Item(status: .done,
                          title: result.title,
                          content: content,
                          subtitle: "",
                          isDailyPrep: true,
                          isLearningPlan: false,
                          isWhatsHot: false,
                          isToBeVision: false,
                          isPreparation: false,
                          link: nil,
                          featureLink: nil,
                          featureButton: nil,
                          identifier: "Not important",
                          affectsTabBarBadge: true)
    }

    func guideItem(with item: NotificationConfigurationObject, isoDate: ISODate) -> Guide.Item? {
        guard isoDate.date?.isToday == true else { return nil }
        let questions = item.questionsFor(services: services)
        let items = dailyPrepItems(questions: questions, notification: item, services: services)
        let contentCollection = services.contentService.contentCollection(id: contentID.whyDPMCollectionID.rawValue)
        let contentItem = contentCollection?.contentItems.first
        let whyDPMTitle = contentCollection?.title ?? R.string.localized.guideDailyPrepNotFinishedWhyDPM()
        let whyDPMDescription = contentItem?.valueText ?? R.string.localized.guideDailyPrepNotFinishedFeedback()
        let content: Guide.Item.Content = .dailyPrep(items: items, feedback: nil,
                                                     whyDPMTitle: whyDPMTitle,
                                                     whyDPMDescription: whyDPMDescription)
        return Guide.Item(status: .todo,
                          title: item.title,
                          content: content,
                          subtitle: "",
                          isDailyPrep: true,
                          isLearningPlan: false,
                          isWhatsHot: false,
                          isToBeVision: false,
                          isPreparation: false,
                          link: URL(string: item.link),
                          featureLink: nil,
                          featureButton: nil,
                          identifier: NotificationID.dailyPrep(date: isoDate).string,
                          affectsTabBarBadge: true)
    }

    func guideItem(with item: RealmGuideItemLearn) -> Guide.Item? {
        let isStrategy = item.type.caseInsensitiveCompare(RealmGuideItemLearn.ItemType.strategy.rawValue) == .orderedSame
        let foundationLink = "qot://content-category?collectionID=" + String(contentID.performanceFoundationCategoryID.rawValue)
        let isFoundation = item.link == foundationLink && item.title.lowercased() == "performance foundation"
        let isBenefits = item.contentID == contentID.QOTBenefitContentID.rawValue
        let benefitsBody = services.contentService.contentItem(id: contentID.QOTBenefitsBodyID.rawValue)?.valueText ?? ""
        let displayType = (isFoundation || isBenefits) ? nil : item.displayType
        let title = isFoundation ? R.string.localized.guideCardFoundationSubtitle() : item.title
        let strategiesCompleted = isStrategy == true
            && isFoundation == false
            && isBenefits == false
            && item.block <= Defaults.totalNumberOfStrategies ? item.block : nil
        return Guide.Item(status: item.completedAt == nil ? .todo : .done,
                          title: title,
                          content: .learningPlan(text: isBenefits ? benefitsBody : item.body,
                                                 strategiesCompleted: strategiesCompleted),
                          subtitle: displayType ?? "",
                          isDailyPrep: false,
                          isLearningPlan: true,
                          isWhatsHot: false,
                          isToBeVision: false,
                          isPreparation: false,
                          link: URL(string: item.link),
                          featureLink: item.featureLink.flatMap { URL(string: $0) },
                          featureButton: item.featureButton,
                          identifier: GuideItemID(item: item).stringRepresentation,
                          affectsTabBarBadge: true)
    }

    func notificationButtonInfo(notification: RealmGuideItemNotification) -> (String, URL)? {
        if
            let contentCollectionID = Int(notification.link.suffix(6)),
            let contentCollection = services.contentService.contentCollection(id: contentCollectionID) {
            if contentCollection.section == "GUIDE" {
                let item = contentCollection.contentItems.filter { $0.format == "guide.feature.button" }.first
                guard
                    let buttonText = item?.valueText,
                    let link = item?.link,
                    let url = URL(string: link) else { return nil }
                return (buttonText, url)
            }
        }
        return nil
    }

    func guideItem(with notification: RealmGuideItemNotification) -> Guide.Item? {
        let buttonInfo = notificationButtonInfo(notification: notification)
        let isDailyPrep = RealmGuideItemNotification.ItemType.morningInterview.rawValue == notification.type ||
            RealmGuideItemNotification.ItemType.weeklyInterview.rawValue == notification.type
        let content: Guide.Item.Content
        if isDailyPrep {
            let questions = notification.questionsFor(services: services)
            let items = dailyPrepItems(questions: questions, notification: notification, services: services)
            content = .dailyPrep(items: items, feedback: notification.dailyPrepFeedback,
                                 whyDPMTitle: nil, whyDPMDescription: nil)
        } else {
            content = .learningPlan(text: notification.body, strategiesCompleted: nil)
        }

        return Guide.Item(status: notification.completedAt == nil ? .todo : .done,
                          title: notification.title ?? "",
                          content: content,
                          subtitle: notification.displayType,
                          isDailyPrep: isDailyPrep,
                          isLearningPlan: isDailyPrep == false ? true : false,
                          isWhatsHot: false,
                          isToBeVision: false,
                          isPreparation: false,
                          link: URL(string: notification.link),
                          featureLink: buttonInfo?.1,
                          featureButton: buttonInfo?.1 == nil ? nil : buttonInfo?.0,
                          identifier: GuideItemID(item: notification).stringRepresentation,
                          affectsTabBarBadge: true)
    }

    func dailyPrepItems(questions: [Question],
						notification: NotificationConfigurationObject,
						services: Services) -> [Guide.DailyPrepItem] {
        var items: [Guide.DailyPrepItem] = []
        for question in questions {
            let key = question.key
            let title = question.dailyPrepTitle.replacingOccurrences(of: "#", with: "\n")
            let item = Guide.DailyPrepItem(result: nil,
                                           key: key ?? "",
                                           title: title)
            items.append(item)
        }
        return items
    }

    func dailyPrepItems(answers: [DailyPrepAnswerObject]) -> [Guide.DailyPrepItem] {
        var items: [Guide.DailyPrepItem] = []
        for answer in answers {
            let title = answer.title.replacingOccurrences(of: "#", with: "\n")
            let item = Guide.DailyPrepItem(result: answer.value, key: "", title: title)
            items.append(item)
        }
        return items
    }

    func dailyPrepItems(questions: [Question],
						notification: RealmGuideItemNotification,
						services: Services) -> [Guide.DailyPrepItem] {
        var items: [Guide.DailyPrepItem] = []
        for question in questions {
            let result = question.userAnswer(notification: notification).flatMap { Int($0.userAnswer) }
            let key = question.key
            let title = question.dailyPrepTitle.replacingOccurrences(of: "#", with: "\n")
            let item = Guide.DailyPrepItem(result: result, key: key ?? "", title: title)
            items.append(item)
        }
        return items
    }

    func preparationItemStrings(status: Guide.Item.Status,
                                representsMultiple: Bool,
                                startsTomorrow: Bool,
                                preparationLocalID: String?) -> (title: String, content: String)? {
        var titleResource: StringResource
        var contentResource: String
        switch (status, representsMultiple, startsTomorrow) {
        case (.todo, false, false):
            titleResource = R.string.localized.guideCardPreparationSingleUnstartedTodayTitle
            contentResource = services.preparationService.preparation(localID: preparationLocalID ?? "")?.name ??
                R.string.localized.guideCardPreparationSingleUnstartedTodayContent()
        case (.todo, true, false):
            titleResource = R.string.localized.guideCardPreparationMultipleUnstartedTodayTitle
            contentResource = R.string.localized.guideCardPreparationMultipleUnstartedTodayContent()
        case (.todo, false, true):
            titleResource = R.string.localized.guideCardPreparationSingleUnstartedTomorrowTitle
            contentResource = services.preparationService.preparation(localID: preparationLocalID ?? "")?.name ??
                R.string.localized.guideCardPreparationSingleUnstartedTomorrowContent()
        case (.todo, true, true):
            titleResource = R.string.localized.guideCardPreparationMultipleUnstartedTomorrowTitle
            contentResource = R.string.localized.guideCardPreparationMultipleUnstartedTomorrowContent()
        case (.done, false, false):
            titleResource = R.string.localized.guideCardPreparationSingleStartedTodayTitle
            contentResource = services.preparationService.preparation(localID: preparationLocalID ?? "")?.name ??
                R.string.localized.guideCardPreparationSingleStartedTodayContent()
        case (.done, true, false):
            titleResource = R.string.localized.guideCardPreparationMultipleStartedTodayTitle
            contentResource = R.string.localized.guideCardPreparationMultipleStartedTodayContent()
        default:
            return nil
        }
        return (title: services.settingsService.string(key: titleResource.key) ?? titleResource.localized,
                content: services.settingsService.string(key: contentResource) ?? contentResource)
    }
}

private extension RealmGuideItemNotification {

    func questionsFor(services: Services) -> [Question] {
        guard let groupID = URL(string: link)?.groupID else { return [] }
        let questions = services.questionsService.morningInterviewQuestions(questionGroupID: groupID)
        return Array(questions)
    }
}

private extension NotificationConfigurationObject {

    func questionsFor(services: Services) -> [Question] {
        guard let groupID = URL(string: link)?.groupID else { return [] }
        let questions = services.questionsService.morningInterviewQuestions(questionGroupID: groupID)
        return Array(questions)
    }
}

private extension Question {

    func userAnswer(notification: RealmGuideItemNotification) -> UserAnswer? {
        guard let questionID = remoteID.value, let notificationID = notification.remoteID.value else { return nil }
        let predicate = "questionID == \(questionID) AND notificationID == \(notificationID)"
        return realm?.objects(UserAnswer.self).filter(predicate).first
    }
}
