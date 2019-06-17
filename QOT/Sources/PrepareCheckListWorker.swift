//
//  PrepareCheckListWorker.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListWorker {

    // MARK: - Properties

    private let services: Services
    private let contentID: Int
    private let relatedStrategyID: Int?
    private let checkListType: PrepareCheckListType
    private let event: CalendarEvent?
    private let eventType: String?
    private var benefits: String?
    private var items: [Int: [PrepareCheckListItem]] = [:]
    private var selectedAnswers: [DecisionTreeModel.SelectedAnswer] = []

    private lazy var content: ContentCollection? = {
        return services.contentService.contentCollection(id: contentID)
    }()

    private lazy var relatedStrategiesDefault: [PrepareCheckListItem] = {
        guard let relatedStrategyID = relatedStrategyID else { return [] }
        var relatedStrategies = [PrepareCheckListItem]()
        let relatedStrategy = services.contentService.contentCollection(id: relatedStrategyID)
        relatedStrategy?.relatedDefaultContentIDs.forEach {
            let content = services.contentService.contentCollection(id: $0)
            relatedStrategies.append(PrepareCheckListItem.strategy(title: content?.title ?? "",
                                                                   durationString: content?.durationString ?? "",
                                                                   readMoreID: $0))
        }
        return relatedStrategies
    }()

    private lazy var relatedStrategiesPrepare: [ContentCollection] = {
        guard let relatedStrategyID = relatedStrategyID else { return [] }
        let relatedStrategy = services.contentService.contentCollection(id: relatedStrategyID)
        return Array(services.contentService.contentCollections(ids: relatedStrategy?.relatedContentIDsPrepare ?? []))
    }()

    private lazy var onTheGoItems: [Int: [PrepareCheckListItem]] = {
        var items = [Int: [PrepareCheckListItem]]()
        var contentItems = [PrepareCheckListItem]()
        content?.items.forEach {
            contentItems.append(.contentItem(itemFormat: ContentItemFormat(rawValue: $0.format), title: $0.valueText))
        }
        items[0] = contentItems
        return items
    }()

    private lazy var dailyItems: [Int: [PrepareCheckListItem]] = {
        var items = [Int: [PrepareCheckListItem]]()
        var contentItems = [PrepareCheckListItem]()
        var headerItems = [PrepareCheckListItem]()
        var intentionItems = [PrepareCheckListItem]()
        content?.items.filter { $0.format == "text.h1" || $0.format == "text.h2"}.forEach {
            headerItems.append(.contentItem(itemFormat: ContentItemFormat(rawValue: $0.format), title: $0.valueText))
        }
        content?.items.filter { $0.format == "title" }.forEach {
            intentionItems.append(.contentItem(itemFormat: ContentItemFormat(rawValue: $0.format), title: $0.valueText))
        }
        let eventItems = [PrepareCheckListItem.eventItem(title: event?.title ?? "",
                                                         date: event?.startDate ?? Date(),
                                                         type: eventType ?? "")]
        let strategies = relatedStrategiesDefault
        let reminders = reminderItems()
        items[0] = headerItems
        items[1] = [.contentItem(itemFormat: ContentItemFormat.list, title: "EVENTS")]
        items[2] = eventItems
        items[3] = [.contentItem(itemFormat: ContentItemFormat.list, title: "INTENTIONS")]
        items[4] = intentionItems
        items[5] = [.contentItem(itemFormat: ContentItemFormat.list, title: "SUGGESTED STRATEGIES")]
        items[6] = strategies
        items[7] = [.contentItem(itemFormat: ContentItemFormat.list, title: "REMINDERS")]
        items[8] = reminders
        return items
    }()

    private lazy var criticalItems: [Int: [PrepareCheckListItem]] = {
        let filter = answerFilter()
        var items = [Int: [PrepareCheckListItem]]()
        var contentItems = [PrepareCheckListItem]()
        var headerItems = [PrepareCheckListItem]()
        var intentionTitleItems = [PrepareCheckListItem]()
        var intentionItemsPerceived = [PrepareCheckListItem]()
        var intentionItemsKnow = [PrepareCheckListItem]()
        var intentionItemsFeel = [PrepareCheckListItem]()
        var benefitTitleItems = [PrepareCheckListItem]()
        content?.items.filter { $0.format == "text.h1" || $0.format == "text.h2"}.forEach {
            headerItems.append(.contentItem(itemFormat: ContentItemFormat(rawValue: $0.format), title: $0.valueText))
        }
        content?.items.filter { $0.format == "title" }.forEach {
            if $0.searchTags.contains(PrepareCheckListTag.benefitsTitle.rawValue) {
                benefitTitleItems.append(.benefitContentItem(itemFormat: ContentItemFormat(rawValue: $0.format),
                                                             title: $0.valueText,
                                                             benefits: benefits,
                                                             questionID: PrepareCheckListTag.questionID(for: $0)))
            } else {
                intentionTitleItems.append(.intentionContentItem(itemFormat: ContentItemFormat(rawValue: $0.format),
                                                                 title: $0.valueText,
                                                                 selectedAnswers: selectedAnswers,
                                                                 answerFilter: filter,
                                                                 questionID: PrepareCheckListTag.questionID(for: $0)))
            }
        }
        selectedAnswers(for: PrepareCheckListTag.perceived.questionID).forEach {
            intentionItemsPerceived.append(.intentionItem(selectedAnswer: $0, answerFilter: filter ?? ""))
        }
        selectedAnswers(for: PrepareCheckListTag.know.questionID).forEach {
            intentionItemsKnow.append(.intentionItem(selectedAnswer: $0, answerFilter: filter ?? ""))
        }
        selectedAnswers(for: PrepareCheckListTag.feel.questionID).forEach {
            intentionItemsFeel.append(.intentionItem(selectedAnswer: $0, answerFilter: filter ?? ""))
        }
        let eventItems = [PrepareCheckListItem.eventItem(title: event?.title ?? "",
                                                         date: event?.startDate ?? Date(),
                                                         type: eventType ?? "")]
        let strategies = relatedStrategiesDefault
        let reminders = reminderItems()
        items[0] = headerItems
        items[1] = [.contentItem(itemFormat: ContentItemFormat.list, title: "EVENTS")]
        items[2] = eventItems
        items[3] = [.contentItem(itemFormat: ContentItemFormat.list, title: "INTENTIONS")]
        items[4] = [intentionTitleItems[0]]
        items[5] = intentionItemsPerceived
        items[6] = [intentionTitleItems[1]]
        items[7] = intentionItemsKnow
        items[8] = [intentionTitleItems[2]]
        items[9] = intentionItemsFeel
        items[10] = [.contentItem(itemFormat: ContentItemFormat.list, title: "BENEFITS")]
        items[11] = [benefitTitleItems[0]]
        items[12] = [.benefitItem(benefits: benefits)]
        items[13] = [.contentItem(itemFormat: ContentItemFormat.list, title: "SUGGESTED STRATEGIES")]
        items[14] = strategies
        items[15] = [.contentItem(itemFormat: ContentItemFormat.list, title: "REMINDERS")]
        items[16] = reminders
        return items
    }()

    func oldPPItems() {
        var items = [Int: [PrepareCheckListItem]]()
        var contentItems = [PrepareCheckListItem]()
        content?.items.forEach {
            contentItems.append(.contentItem(itemFormat: ContentItemFormat(rawValue: $0.format), title: $0.valueText))
        }
        items[0] = contentItems
    }

    // MARK: - Init

    init(services: Services,
         contentID: Int,
         relatedStrategyID: Int?,
         checkListType: PrepareCheckListType,
         event: CalendarEvent?,
         eventType: String?,
         selectedAnswers: [DecisionTreeModel.SelectedAnswer],
         benefits: String?) {
        self.services = services
        self.contentID = contentID
        self.checkListType = checkListType
        self.event = event
        self.eventType = eventType
        self.relatedStrategyID = relatedStrategyID
        self.selectedAnswers = selectedAnswers
        self.benefits = benefits
        makeItems()
    }
}

extension PrepareCheckListWorker {
    var getSelectedIDs: [Int] {
        var readMoreIDs = [Int]()
        relatedStrategiesDefault.forEach { item in
            switch item {
            case .strategy(_, _, let readMoreID): readMoreIDs.append(readMoreID)
            default: break
            }
        }
        return readMoreIDs
    }

    var getRelatedContent: [ContentCollection] {
        return relatedStrategiesPrepare
    }

    var getServices: Services {
        return services
    }

    var type: PrepareCheckListType {
        return checkListType
    }

    var sectionCount: Int {
        return items.count
    }

    func rowCount(in section: Int) -> Int {
        return items[section]?.count ?? 0
    }

    func item(at indexPath: IndexPath) -> PrepareCheckListItem? {
        return items[indexPath.section]?[indexPath.row]
    }

    func attributedText(title: String?, itemFormat: ContentItemFormat?) -> NSAttributedString? {
        guard let title = title, let itemFormat = itemFormat else { return nil }
        switch itemFormat {
        case .textH1: return attributed(text: title, font: .sfProDisplayLight(ofSize: 24), textColor: .carbon)
        case .textH2,
             .listItem: return attributed(text: title, font: .sfProtextLight(ofSize: 16), textColor: UIColor.carbon.withAlphaComponent(0.7))
        case .list: return attributed(text: "\n\n"+title, font: .sfProtextMedium(ofSize: 14), textColor: UIColor.carbon.withAlphaComponent(0.4))
        case .title: return attributed(text: title, font: .sfProtextLight(ofSize: 16), textColor: .carbon)
        default: return nil
        }
    }

    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        guard let format = itemFormat(at: indexPath) else { return 95 }
        switch format {
        case .textH1: return 68
        case .textH2: return 20
        case .list: return 80
        case .title: return 64
        case .listItem: return 48
        default: return 95
        }
    }

    func hasListMark(at indexPath: IndexPath) -> Bool {
        guard let format = itemFormat(at: indexPath) else { return false }
        switch format {
        case .listItem: return true
        default: return false
        }
    }

    func hasBottomSeperator(at indexPath: IndexPath) -> Bool {
        guard let format = itemFormat(at: indexPath) else { return false }
        switch format {
        case .title: return checkListType == .peakPerformance ? false : true
        default: return false
        }
    }

    func hasHeaderMark(at indexPath: IndexPath) -> Bool {
        guard let format = itemFormat(at: indexPath) else { return false }
        switch format {
        case .textH1: return true
        default: return false
        }
    }

    func hasEditImage(at indexPath: IndexPath) -> Bool {
        guard let format = itemFormat(at: indexPath) else { return false }
        switch format {
        case .title: return checkListType == .peakPerformance
        default: return false
        }
    }
}

private extension PrepareCheckListWorker {
    func reminderItems() -> [PrepareCheckListItem] {
        return [PrepareCheckListItem.reminder(title: "SET REMINDER",
                                              subbtitle: "To help you remember planned events",
                                              active: false),
                PrepareCheckListItem.reminder(title: "SAVE TO ICAL",
                                              subbtitle: "Save in your calendar events",
                                              active: false)]
    }

    func itemFormat(at indexPath: IndexPath) -> ContentItemFormat? {
        guard let item = item(at: indexPath) else { return nil }
        switch item {
        case .contentItem(let itemFormat, _): return itemFormat
        case .benefitItem,
             .intentionItem: return .listItem
        case .intentionContentItem(let itemFormat, _, _, _, _): return itemFormat
        case .benefitContentItem(let itemFormat, _, _, _): return itemFormat
        default: return nil
        }
    }

    func attributed(text: String, font: UIFont, textColor: UIColor) -> NSAttributedString? {
        return NSAttributedString(string: text,
                                  font: font,
                                  textColor: textColor,
                                  alignment: .left)
    }

    func makeItems() {
        switch checkListType {
        case .daily: items = dailyItems
        case .onTheGo: items = onTheGoItems
        case .peakPerformance: items = criticalItems
        }
    }

    func selectedAnswers(for questionID: Int) -> [DecisionTreeModel.SelectedAnswer] {
        return selectedAnswers.filter { $0.questionID == questionID }
    }

    func answerFilter() -> String? {
        return selectedAnswers(for: PrepareCheckListTag.eventType.questionID).first?.answer.keys.filter { $0.contains("_relationship_") }.first
    }
}
