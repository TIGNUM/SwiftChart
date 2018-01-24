//
//  GuideItemFactory.swift
//  QOT
//
//  Created by Sam Wyndham on 23/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

struct GuideItemFactory: GuideItemFactoryProtocol {

    let services: Services

    func makeItem(with item: GuideLearnItem) -> Guide.Item? {
        guard let item = item as? RealmGuideItemLearn else { return nil }

        return guideItem(with: item)
    }

    func makeItem(with item: GuideNotificationItem) -> Guide.Item? {
        guard let item = item as? RealmGuideItemNotification else { return nil }

        return guideItem(with: item)
    }

    func makeMessageText(with greeting: Guide.Message) -> String {
        return services.contentService.defaultMessage(greeting.rawValue)
    }

    func userName() -> String? {
        return services.mainRealm.objects(User.self).first?.givenName
    }
}

private extension GuideItemFactory {

    func guideItem(with item: RealmGuideItemLearn) -> Guide.Item? {
        return Guide.Item(status: item.completedAt == nil ? .todo : .done,
                          title: item.title,
                          content: .text(item.body),
                          subtitle: item.displayType ?? "",
                          type: item.type,
                          link: URL(string: item.link),
                          featureLink: item.featureLink.flatMap { URL(string: $0) },
                          featureButton: item.featureButton,
                          identifier: GuideItemID(item: item).stringRepresentation,
                          greeting: item.greeting,
                          createdAt: item.createdAt)
    }

    func guideItem(with notification: RealmGuideItemNotification) -> Guide.Item? {
        let isDailyPrep = RealmGuideItemNotification.ItemType.morningInterview.rawValue == notification.type ||
            RealmGuideItemNotification.ItemType.weeklyInterview.rawValue == notification.type
        let content: Guide.Item.Content
        if isDailyPrep {
            let questions = notification.questionsFor(services: services)
            let results = notification.myPrepResults()
            let items = dailyPrepItems(questions: questions, results: results, services: services)
            let feedback = notification.interviewResult?.feedback
            content = .dailyPrep(items: items, feedback: feedback)
        } else {
            content = .text(notification.body)
        }

        return Guide.Item(status: notification.completedAt == nil ? .todo : .done,
                          title: notification.title ?? "",
                          content: content,
                          subtitle: notification.displayType,
                          type: notification.type,
                          link: URL(string: notification.link),
                          featureLink: nil,
                          featureButton: nil,
                          identifier: GuideItemID(item: notification).stringRepresentation,
                          greeting: notification.greeting,
                          createdAt: notification.createdAt)
    }

    func dailyPrepItems(questions: [Question], results: [Int], services: Services) -> [Guide.DailyPrepItem] {
        var items: [Guide.DailyPrepItem] = []
        for (index, question) in questions.enumerated() {
            let result: Int? = index < results.count ? results[index] : nil
            let color = resultColor(question: question, resultValue: result, services: services)
            let title = question.dailyPrepTitle.replacingOccurrences(of: "#", with: "\n")
            let item = Guide.DailyPrepItem(result: result, resultColor: color, title: title)
            items.append(item)
        }
        return items
    }

    func resultColor(question: Question, resultValue: Int?, services: Services) -> UIColor {
        guard let key = question.key,
            let statistics = services.statisticsService.chart(key: key),
            let resultValue = resultValue
            else { return .white }
        let color = statistics.color(value: Double(resultValue) * 0.1)

        return color == .gray ? .white90 : color
    }
}

private extension RealmGuideItemNotification {

    func myPrepResults() -> [Int] {
        guard let interviewResults = interviewResult else {
            return []
        }
        return interviewResults.results.map { $0.value }
    }

    func questionsFor(services: Services) -> [Question] {
        guard let groupID = URL(string: link)?.groupID else { return [] }
        let questions = services.questionsService.morningInterviewQuestions(questionGroupID: groupID)
        return Array(questions)
    }
}
