//
//  ContentService.swift
//  QOT
//
//  Created by Sam Wyndham on 24.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

protocol Predicatable {
    var predicate: NSPredicate { get }
}

final class ContentService {

    enum Tags: String, CaseIterable, Predicatable {
        case tbvGeneratorAlertNotSavedTitle = "tbv_generator_alert_not_saved_title"
        case tbvGeneratorAlertNotSavedMessage = "tbv_generator_alert_not_saved_message"
        case tbvGeneratorAlertNotSavedButtonTitleCancel = "tbv_generator_alert_not_saved_button_title_cancel"
        case tbvGeneratorAlertNotSavedButtonTitleDefault = "tbv_generator_alert_not_saved_button_title_default"
        case tbvGeneratorAlertNotSavedButtonTitleDestructive = "tbv_generator_alert_not_saved_button_title_destructive"
        case tbvSharing = "tbv_sharing"
        case siriExplanation = "siri_explanation_header"
        case siriToBeVisionTitle = "siri_title_tobevision"
        case siriUpcomingEventTitle = "siri_title_upcomingevent"
        case siriDailyPrepTitle = "siri_title_dailyprep"
        case siriWhatsHotTitle = "siri_title_whatshot"
        case siriToBeVisionSuggestionPhrase = "siri_suggestionphrase_tobevision"
        case siriUpcomingEventSuggestionPhrase = "siri_suggestionphrase_upcomingevent"
        case siriDailyPrepSuggestionPhrase = "siri_suggestionphrase_dailyprep"
        case siriWhatsHotSuggestionPhrase = "siri_suggestionphrase_whatshot"
        case searchSuggestionSelfImage = "search_suggestion_self_image"
        case searchSuggestionDailyPrep = "search_suggestion_daily_prep"
        case searchSuggestionNoExcuse = "search_suggestion_no_excuse"
        case searchSuggestionBuildCapacity = "search_suggestion_build_capacity"
        case searchSuggestionSleepRitual = "search_suggestion_sleep_ritual"
        case searchSuggestionPowerNap = "search_suggestion_power_nap"
        case searchSuggestionMindsetShifter = "search_suggestion_mindset_shifter"
        case searchSuggestionReframe = "search_suggestion_reframe"
        case searchSuggestionBreathing = "search_suggestion_breathing"
        case searchSuggestionHPSnacks = "search_suggestion_hp_snacks"
        case searchSuggestionBrainPerformance = "search_suggestion_brain_performance"
        case searchSuggestionWorkToHome = "search_suggestion_work_to_home"
        case searchSuggestionTravel = "search_suggestion_travel"
        case searchSuggestionHeader = "search_header_suggestion"

        struct Navigation {
            enum FirstLevel: String, CaseIterable, Predicatable {
                case knowPageTitle = "know-feed-level-01-page-title"
                case knowSectionTitleStrategies = "know-feed-level-01-section-title-strategies"
                case knowSectionSubtitleStrategies = "know-feed-level-01-section-subtitle-strategies"
                case knowSectionTitleWhatsHot = "know-feed-level-01-section-title-whats-hot"
                case knowSectionSubtitleWhatsHot = "know-feed-level-01-section-subtitle-whats-hot"

                var predicate: NSPredicate {
                    return NSPredicate(tag: rawValue)
                }
            }
        }

        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }

    // MARK: - Properties

    private let mainRealm: Realm
    private let realmProvider: RealmProvider

    // MARK: - Init

    init(mainRealm: Realm, realmProvider: RealmProvider) {
        self.mainRealm = mainRealm
        self.realmProvider = realmProvider
    }

    // MARK: - Categories

    func eraseData() {
        do {
            try mainRealm.write {
                mainRealm.delete(libraryCategories())
                mainRealm.delete(learnContentCategories())
                mainRealm.delete(whatsHotArticles())
                mainRealm.delete(tools())
            }
        } catch {
            assertionFailure("Failed to delete content with error: \(error)")
        }
    }

    func searchContentCollections() -> Results<ContentCollection> {
        let library = Database.Section.library.rawValue
        let tools = Database.Section.tools.rawValue
        let learnStrategy = Database.Section.learnStrategy.rawValue
        let whatsHot = Database.Section.learnWhatsHot.rawValue
        let predicate = NSPredicate(format: "section == %@ || section == %@ || section == %@ || section == %@", library, tools, learnStrategy, whatsHot)
        return mainRealm.objects(ContentCollection.self).filter(predicate)
    }

    func searchReadContentCollections() -> Results<ContentCollection> {
        let library = Database.Section.library.rawValue
        let learnStrategy = Database.Section.learnStrategy.rawValue
        let whatsHot = Database.Section.learnWhatsHot.rawValue
        let predicate = NSPredicate(format: "section == %@ || section == %@ || section == %@",
                                    library,
                                    learnStrategy,
                                    whatsHot)
        return mainRealm.objects(ContentCollection.self).filter(predicate)
    }

    func contentItemsAudio() -> Results<ContentItem> {
        let audioFormat = "audio"
        return mainRealm.objects(ContentItem.self).filter(NSPredicate(format: "format == %@", audioFormat))
    }

    func contentItemsVideo() -> Results<ContentItem> {
        let videoFormat = "video"
        return mainRealm.objects(ContentItem.self).filter(NSPredicate(format: "format == %@", videoFormat))
    }

    func contentItemsPDF() -> Results<ContentItem> {
        let pdfFormat = "pdf"
        return mainRealm.objects(ContentItem.self).filter(NSPredicate(format: "format == %@", pdfFormat))
    }

    func contentItemsRead() -> Results<ContentItem> {
        let pdfFormat = "pdf"
        let textFormat = "text.paragraph"
        return mainRealm.objects(ContentItem.self).filter(NSPredicate(format: "format == %@ || format == %@",
                                                                      pdfFormat,
                                                                      textFormat))
    }

    func contentItem(for predicate: NSPredicate) -> ContentItem? {
        return mainRealm.objects(ContentItem.self).filter(predicate).first
    }

    func libraryCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .library)
    }

    func toolsCategories() -> AnyRealmCollection<ContentCategory> {
        let library = Database.Section.library.rawValue
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@ AND remoteID != %d", library, 100037)
        return AnyRealmCollection(mainRealm.objects(ContentCategory.self).filter(predicate).sorted(by: [.sortOrder()]))
//        return sortedResults(for: predicate)
    }

    func learnContentCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .learnStrategy)
    }

    func learnContentCategory(categoryTitle: String) -> ContentCategory? {
        return learnContentCategories().filter(NSPredicate(format: "title == %@", categoryTitle)).first
    }

    func contentCollection(contentTitle: String) -> ContentCollection? {
        let predicate = NSPredicate(title: contentTitle)
        return mainRealm.objects(ContentCollection.self).filter(predicate).first
    }

    func learnContentCategoriesOnBackground() throws -> AnyRealmCollection<ContentCategory> {
        return try realmProvider.realm().contentCategories(section: .learnStrategy)
    }

    func contentCategory(id: Int) -> ContentCategory? {
        return mainRealm.syncableObject(ofType: ContentCategory.self, remoteID: id)
    }

    func contentCategories(ids: [Int]) -> AnyRealmCollection<ContentCategory> {
        let predicate = NSPredicate(remoteIDs: ids)
        return AnyRealmCollection(mainRealm.objects(ContentCategory.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func visionGeneratorCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .visionGenerator)
    }

    // MARK: - Collections

    func faq() -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(format: "section == %@ AND title != %@", "FAQ", "FAQ")
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func tutorialSlideShows() -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate.slideShow()
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func tools() -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate.section(.tools)
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func whatsHotArticles() -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate.section(.learnWhatsHot)
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func whatsHotArticle(with remoteID: Int) -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(remoteID: remoteID)
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func whatsHotArticlesNew() -> Results<ContentCollection> {
        return mainRealm.objects(ContentCollection.self).filter(.newWhatsHotArticles)
    }

    func contentCollections(ids: [Int]) -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(remoteIDs: ids)
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func contentCollections(categoryID: Int) -> AnyRealmCollection<ContentCollection> {
        let predicate = NSPredicate(format: "ANY categoryIDs.value == %d", categoryID)
        return AnyRealmCollection(mainRealm.objects(ContentCollection.self).filter(predicate).sorted(by: [.sortOrder()]))
    }

    func contentCollection(id: Int) -> ContentCollection? {
        return mainRealm.syncableObject(ofType: ContentCollection.self, remoteID: id)
    }

    func contentItems(contentCollectionID: Int) -> AnyRealmCollection<ContentItem> {
        let predicate = NSPredicate(format: "collectionID == %d", contentCollectionID)
        return AnyRealmCollection(mainRealm.objects(ContentItem.self).filter(predicate))
    }

    func contentItemsOnBackground(contentCollectionID: Int) throws -> AnyRealmCollection<ContentItem> {
        let predicate = NSPredicate(format: "collectionID == %d", contentCollectionID)
        return try AnyRealmCollection(realmProvider.realm().objects(ContentItem.self).filter(predicate))
    }

    func contentItem(id: Int) -> ContentItem? {
        return mainRealm.syncableObject(ofType: ContentItem.self, remoteID: id)
    }

    func defaultMessage(_ itemID: Int) -> String {
        let welcomeMessageCollection = contentCollection(id: 100708)
        let predicate = NSPredicate(remoteID: itemID)
        return welcomeMessageCollection?.contentItems.filter(predicate).compactMap { $0.valueText }.first ?? ""
    }

    func relatedArticles(for articleCollection: ContentCollection) -> [ContentCollection] {
        let predicate = NSPredicate(remoteIDs: articleCollection.relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(by: [.sortOrder()]).filter(predicate)

        return Array(AnyRealmCollection<ContentCollection>(results))
    }

    func relatedPrepareStrategies(_ contentTitle: String) -> [ContentCollection] {
        let contentPredicate = NSPredicate(section: Database.Section.prepare.rawValue, title: contentTitle)
        guard let content = Array(mainRealm.objects(ContentCollection.self).filter(contentPredicate)).first else {
            return []
        }
        let predicate = NSPredicate(remoteIDs: content.relatedContentIDs)
        let results = mainRealm.objects(ContentCollection.self).filter(predicate)
        return Array(AnyRealmCollection<ContentCollection>(results))
    }

    func setContentCollectionViewed(localID: String) {
        DispatchQueue.global().async {
            do {
                let realm = try self.realmProvider.realm()
                try realm.write {
                    if let contentCollection = realm.syncableObject(ofType: ContentCollection.self, localID: localID) {
                        if let contentRead = contentCollection.contentRead {
                            contentRead.viewedAt = Date()
                        } else {
                            contentCollection.contentRead = ContentRead(contentCollection: contentCollection)
                        }
                    }
                }
            } catch let error {
                assertionFailure("UpdateViewedAt, contentId: \(localID), error: \(error)")
            }
        }
    }
}

// MARK: - Private

private extension Realm {

    func contentCategories(section: Database.Section) -> AnyRealmCollection<ContentCategory> {
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@", section.rawValue)
        return AnyRealmCollection(objects(ContentCategory.self).filter(predicate).sorted(by: [.sortOrder()]))
    }
}

extension SortDescriptor {

    static func sortOrder(ascending: Bool = false) -> SortDescriptor {
        return SortDescriptor(keyPath: Database.KeyPath.sortOrder.rawValue, ascending: ascending)
    }
}

private extension ContentService {

//    func sortedResults<T>(for predicate: NSPredicate) -> AnyRealmCollection<T> {
//        return AnyRealmCollection(mainRealm.objects(T.Type).filter(predicate).sorted(by: .sortOrder()))
//        return mainRealm.anyCollection(.sortOrder(), predicates: predicate)
//    }
}

// MARK: - To Be Vision Tooling

extension ContentService {

    func toBeVisionToolingHeadlinePlaceholder() -> String? {
        return contentCollection(id: 101080)?.contentItems[1].valueText
    }

    func toBeVisionHeadlinePlaceholder() -> String? {
        return contentCollection(id: 101080)?.contentItems.first?.valueText
    }

    func toBeVisionMessagePlaceholder() -> String? {
        return contentCollection(id: 101079)?.contentItems.first?.valueText
    }

    func visionGeneratorAlertModelNotSaved() -> VisionGeneratorAlertModel? {
        let title = contentItem(for: ContentService.Tags.tbvGeneratorAlertNotSavedTitle.predicate)?.valueText
        guard
            let message = contentItem(for: ContentService.Tags.tbvGeneratorAlertNotSavedMessage.predicate)?.valueText,
            let buttonTitleCancel = contentItem(for: ContentService.Tags.tbvGeneratorAlertNotSavedButtonTitleCancel.predicate)?.valueText,
            let buttonTitleDefault = contentItem(for: ContentService.Tags.tbvGeneratorAlertNotSavedButtonTitleDefault.predicate)?.valueText,
            let buttonTitleDestructive = contentItem(for: ContentService.Tags.tbvGeneratorAlertNotSavedButtonTitleDestructive.predicate)?.valueText else {
                return nil
        }
        return VisionGeneratorAlertModel(title: title,
                                         message: message,
                                         buttonTitleCancel: buttonTitleCancel,
                                         buttonTitleDefault: buttonTitleDefault,
                                         buttonTitleDestructive: buttonTitleDestructive)
    }
}

// MARK: - Siri

extension ContentService {

    func siriExplanation() -> String? {
        return contentItem(for: ContentService.Tags.siriExplanation.predicate)?.valueText
    }

    func siriTitle(for shortcut: ShortcutType) -> String? {
        switch shortcut {
        case .toBeVision:
            return contentItem(for: ContentService.Tags.siriToBeVisionTitle.predicate)?.valueText
        case .upcomingEventPrep:
            return contentItem(for: ContentService.Tags.siriUpcomingEventTitle.predicate)?.valueText
        case .whatsHot:
            return contentItem(for: ContentService.Tags.siriWhatsHotTitle.predicate)?.valueText
        case .morningInterview:
            return contentItem(for: ContentService.Tags.siriDailyPrepTitle.predicate)?.valueText
        }
    }

    func siriSuggestionPhrase(for shortcut: ShortcutType) -> String? {
        switch shortcut {
        case .toBeVision:
            return contentItem(for: ContentService.Tags.siriToBeVisionSuggestionPhrase.predicate)?.valueText
        case .upcomingEventPrep:
            return contentItem(for: ContentService.Tags.siriUpcomingEventSuggestionPhrase.predicate)?.valueText
        case .whatsHot:
            return contentItem(for: ContentService.Tags.siriWhatsHotSuggestionPhrase.predicate)?.valueText
        case .morningInterview:
            return contentItem(for: ContentService.Tags.siriDailyPrepSuggestionPhrase.predicate)?.valueText
        }
    }
}

// MARK: - Release Manager

extension ContentService {
    private func releaseManagerCategory() -> ContentCategory? {
        let feedbackMessageCategories = mainRealm.contentCategories(section: .feedbackMessage)
        return feedbackMessageCategories.filter(NSPredicate(title: "Release Manager")).first
    }

    func releaseManagerValue(for type: SirenMessagingType) -> String? {
        guard let category = releaseManagerCategory() else { return nil }
        var items = [ContentItem]()
        category.contentCollections.forEach { items.append(contentsOf: Array($0.items)) }
        return items.filter { $0.searchTags == type.rawValue }.first?.valueText
    }
}

// MARK: - iPad Advice View

extension ContentService {

    private func iPadAdviceCategory() -> ContentCategory? {
        let iPadAdviceCategories = mainRealm.contentCategories(section: .generic)
        return iPadAdviceCategories.filter(NSPredicate(title: "iPad Advice")).first
    }

    func iPadAdviceValue(for type: IPadAdviceViewType) -> String? {
        guard let category = iPadAdviceCategory() else { return nil }
        var items = [ContentItem]()
        category.contentCollections.forEach { items.append(contentsOf: Array($0.items)) }
        return items.filter { $0.searchTags == type.rawValue }.first?.valueText
    }
}

// MARK: - PARTNERS_LANDING_PAGE

extension ContentService {

    func partnersLandingPage() -> PartnersLandingPage {
        let category = mainRealm.contentCategories(section: .partnersLandingPage).first
        let items = category?.contentCollections.first?.items
        let title = items?.filter(PartnersLandingPage.ItemTypes.title.predicate).first?.valueText
        let message = items?.filter(PartnersLandingPage.ItemTypes.message.predicate).first?.valueText
        let buttonTitle = items?.filter(PartnersLandingPage.ItemTypes.buttonTitle.predicate).first?.valueText
        return PartnersLandingPage(title: title,
                                   message: message,
                                   buttonTitle: buttonTitle,
                                   defaultProfilePicture: R.image.partnerPlaceholder())
    }
}

// MARK: - Search Suggestions

extension ContentService {

    func searchSuggestionsHeader() -> String {
        return contentItem(for: Tags.searchSuggestionHeader.predicate)?.valueText ?? ""
    }

    func searchSuggestions() -> [String] {
        var suggestions: [String] = []
        for tag in Tags.allCases where tag.rawValue.contains("search_suggestion") {
            suggestions.append(contentItem(for: tag.predicate)?.valueText ?? "")
        }
        return suggestions
    }
}
