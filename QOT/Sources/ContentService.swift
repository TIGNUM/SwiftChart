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
        case myQotProfileSectionTitle = "myqot_profile_section_title"
        case myQotLibrarySectionTitle = "myqot_library_section_title"
        case myQotPrepsSectionTitle = "myqot_preps_section_title"
        case myQotSprintsSectionTitle = "myqot_sprints_section_title"
        case myQotDataSectionTitle = "myqot_data_section_title"
        case myQotToBeVisionSectionTitle = "myqot_tobevision_section_title"
        case toolsHeaderTitle = "tools_header_title"
        case toolsHeaderSubtitle = "tools_header_subtitle"
        case toolsMindsetSectionTitle = "tools_mindset_section_title"
        case toolsNutritionSectionTitle = "tools_nutrition_section_title"
        case toolsMovementSectionTitle = "tools_movement_section_title"
        case toolsRecoverySectionTitle = "tools_recovery_section_title"
        case toolsHabituationSectionTitle = "tools_habituation_section_title"
        case coachHeaderTitle = "coach_header_title"
        case coachHeaderSubtitle = "coach_header_subtitle"
        case coachSearchSectionTitle = "coach_search_section_title"
        case coachApplyToolsSectionTitle = "coach_apply_tools_section_title"
        case coachPlanSprintSectionTitle = "coach_plan_sprint_section_title"
        case coachPrepareEventSectionTitle = "coach_prepare_event_section_title"
        case coachSolveChallengeSectionTitle = "coach_solve_challenge_section_title"
        case coachSearchSectionSubtitle = "coach_search_section_subtitle"
        case coachApplyToolsSectionSubtitle = "coach_apply_tools_section_subtitle"
        case coachPlanSprintSectionSubtitle = "coach_plan_sprint_section_subtitle"
        case coachPrepareEventSectionSubtitle = "coach_prepare_event_section_subtitle"
        case coachSolveChallengeSectionSubtitle = "coach_solve_challenge_section_subtitle"
        case paymentHeaderTitle = "payment_header_title"
        case paymentHeaderSubtitle = "payment_header_subtitle"
        case paymentPrepareSectionTitle = "payment_prepared_section_title"
        case paymentImpactSectionTitle = "payment_impact_section_title"
        case paymentGrowSectionTitle = "payment_grow_section_title"
        case paymentDataSectionTitle = "payment_data_section_title"
        case paymentPrepareSectionSubtitle = "payment_prepared_section_subtitle"
        case paymentImpactSectionSubtitle = "payment_impact_section_subtitle"
        case paymentGrowSectionSubtitle = "payment_grow_section_subtitle"
        case paymentDataSectionSubtitle = "payment_data_section_subtitle"
        case tbvGeneratorAlertNotSavedTitle = "tbv_generator_alert_not_saved_title"
        case tbvGeneratorAlertNotSavedMessage = "tbv_generator_alert_not_saved_message"
        case tbvGeneratorAlertNotSavedButtonTitleCancel = "tbv_generator_alert_not_saved_button_title_cancel"
        case tbvGeneratorAlertNotSavedButtonTitleDefault = "tbv_generator_alert_not_saved_button_title_default"
        case tbvGeneratorAlertNotSavedButtonTitleDestructive = "tbv_generator_alert_not_saved_button_title_destructive"
        case tbvSharing = "tbv_sharing"
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
        case learnStrategiesFoundation = "learn_strategies_foundation"

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

        enum ConfirmationView: String, Predicatable {
            case mindsetShifterTitle = "confirmationview-title-mindsetshifter"
            case mindsetShifterDescription = "confirmationview-subtitle-mindsetshifter"
            case mindsetShifterButtonYes = "confirmationview-button-yes-mindsetshifter"
            case mindsetShifterButtonNo = "confirmationview-button-no-mindsetshifter"
            case solveTitle = "confirmationview-title-solve"
            case solveDescription = "confirmationview-subtitle-solve"
            case solveButtonYes = "confirmationview-button-yes-solve"
            case solveButtonNo = "confirmationview-button-no-solve"

            var predicate: NSPredicate {
                return NSPredicate(tag: rawValue)
            }
        }

        enum MindsetShifterCheclist: String, Predicatable {
            case headerTitle = "mindset-shifter-checklist-header-title"
            case headerSubtitle = "mindset-shifter-checklist-header-subtitle"
            case triggerTitle = "mindset-shifter-checklist-trigger-title"
            case reactionsTitle = "mindset-shifter-checklist-reactions-title"
            case negativeToPositiveTitle = "mindset-shifter-checklist-negativeToPositive-title"
            case negativeToPositiveLowTitle = "mindset-shifter-checklist-negativeToPositive-lowTitle"
            case negativeToPositiveHighTitle = "mindset-shifter-checklist-negativeToPositive-highTitle"
            case visionTitle = "mindset-shifter-checklist-vision-Title"
            case buttonText = "mindset-shifter-checklist-save-button-text"

            var predicate: NSPredicate {
                return NSPredicate(tag: rawValue)
            }
        }

        var predicate: NSPredicate {
            switch self {
            case .learnStrategiesFoundation: return NSPredicate(searchTag: rawValue)
            default: return NSPredicate(tag: rawValue)
            }
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

    func learnStrategiesFoundation() -> [ContentCollection] {
        let predicate = Tags.learnStrategiesFoundation.predicate
        return Array(mainRealm.objects(ContentCollection.self).filter(predicate))
    }

    func contentItem(for predicate: NSPredicate) -> ContentItem? {
        return mainRealm.objects(ContentItem.self).filter(predicate).first
    }

    func localizedString(for predicate: NSPredicate) -> String? {
        return contentItem(for: predicate)?.valueText
    }

    func libraryCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .library)
    }

    func toolsCategories() -> AnyRealmCollection<ContentCategory> {
        let library = Database.Section.library.rawValue
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@ AND remoteID != %d", library, 100037)
        return AnyRealmCollection(mainRealm.objects(ContentCategory.self).filter(predicate))
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

    func isDefaultPrepareContentRelation(contentCollectionID: Int) -> Bool {
        let predicate = NSPredicate(format: "contentID == %d AND type == %@", contentCollectionID, "PREPARE_DEFAULT")
        return mainRealm.objects(ContentRelation.self).filter(predicate).isEmpty == false
    }

    func relatedContentList(for articleCollection: ContentCollection) -> [ContentCollection] {
        let relatedContents = Array(articleCollection.relatedContentList).filter { $0.type != "NEXT_UP" }
        let remoteIDs = relatedContents.compactMap { $0.contentID }
        let predicate = NSPredicate(remoteIDs: remoteIDs)
        let results = mainRealm.objects(ContentCollection.self).sorted(by: [.sortOrder()]).filter(predicate)
        return Array(AnyRealmCollection<ContentCollection>(results))
    }

    func nextUp(for content: ContentCollection?) -> ContentCollection? {
        guard
            let content = content,
            let contentID = (content.relatedContentList.filter { $0.type == "NEXT_UP" }).first?.contentID else { return nil }
        return contentCollection(id: contentID)
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

    func setContentViewed(remoteID: Int) {
        do {
            let realm = try self.realmProvider.realm()
            try realm.write {
                if let content = self.contentCollection(id: remoteID) {
                    if let contentRead = content.contentRead {
                        contentRead.viewedAt = Date()
                    } else {
                        content.contentRead = ContentRead(contentCollection: content)
                    }
                }
            }
        } catch let error {
            assertionFailure("UpdateViewedAt, contentId: \(remoteID), error: \(error)")
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

// MARK: - My Qot

extension ContentService {

    func myQotSectionTitles(for myQotItem: MyQotSection) -> String? {
        switch myQotItem {
        case .profile:
             return contentItem(for: ContentService.Tags.myQotProfileSectionTitle.predicate)?.valueText
        case .library:
            return contentItem(for: ContentService.Tags.myQotLibrarySectionTitle.predicate)?.valueText
        case .preps:
            return contentItem(for: ContentService.Tags.myQotPrepsSectionTitle.predicate)?.valueText
        case .sprints:
            return contentItem(for: ContentService.Tags.myQotSprintsSectionTitle.predicate)?.valueText
        case .data:
            return contentItem(for: ContentService.Tags.myQotDataSectionTitle.predicate)?.valueText
        case .toBeVision:
            return contentItem(for: ContentService.Tags.myQotToBeVisionSectionTitle.predicate)?.valueText
        }
    }
}

// MARK: - Payment

extension ContentService {

    func paymentSectionTitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return contentItem(for: ContentService.Tags.paymentPrepareSectionTitle.predicate)?.valueText
        case .impact:
            return contentItem(for: ContentService.Tags.paymentImpactSectionTitle.predicate)?.valueText
        case .grow:
            return contentItem(for: ContentService.Tags.paymentGrowSectionTitle.predicate)?.valueText
        case .data:
            return contentItem(for: ContentService.Tags.paymentDataSectionTitle.predicate)?.valueText
        }
    }

    func paymentSectionSubtitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return contentItem(for: ContentService.Tags.paymentPrepareSectionSubtitle.predicate)?.valueText
        case .impact:
            return contentItem(for: ContentService.Tags.paymentImpactSectionSubtitle.predicate)?.valueText
        case .grow:
            return contentItem(for: ContentService.Tags.paymentGrowSectionSubtitle.predicate)?.valueText
        case .data:
            return contentItem(for: ContentService.Tags.paymentDataSectionSubtitle.predicate)?.valueText
        }
    }

    func paymentHeaderTitle() -> String? {
        return contentItem(for: ContentService.Tags.paymentHeaderTitle.predicate)?.valueText
    }

    func paymentHeaderSubtitle() -> String? {
        return contentItem(for: ContentService.Tags.paymentHeaderSubtitle.predicate)?.valueText
    }
}

// MARK: - Coach

extension ContentService {

    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return contentItem(for: ContentService.Tags.coachSearchSectionTitle.predicate)?.valueText
        case .tools:
            return contentItem(for: ContentService.Tags.coachApplyToolsSectionTitle.predicate)?.valueText
        case .sprint:
            return contentItem(for: ContentService.Tags.coachPlanSprintSectionTitle.predicate)?.valueText
        case .event:
            return contentItem(for: ContentService.Tags.coachPrepareEventSectionTitle.predicate)?.valueText
        case .challenge:
            return contentItem(for: ContentService.Tags.coachSolveChallengeSectionTitle.predicate)?.valueText
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return contentItem(for: ContentService.Tags.coachSearchSectionSubtitle.predicate)?.valueText
        case .tools:
            return contentItem(for: ContentService.Tags.coachApplyToolsSectionSubtitle.predicate)?.valueText
        case .sprint:
            return contentItem(for: ContentService.Tags.coachPlanSprintSectionSubtitle.predicate)?.valueText
        case .event:
            return contentItem(for: ContentService.Tags.coachPrepareEventSectionSubtitle.predicate)?.valueText
        case .challenge:
            return contentItem(for: ContentService.Tags.coachSolveChallengeSectionSubtitle.predicate)?.valueText
        }
    }

   func coachHeaderTitle() -> String? {
        return contentItem(for: ContentService.Tags.coachHeaderTitle.predicate)?.valueText
    }

    func coachHeaderSubtitle() -> String? {
        return contentItem(for: ContentService.Tags.coachHeaderSubtitle.predicate)?.valueText
    }
}

// MARK: - Tools

extension ContentService {

    func toolSectionTitles(for toolItem: ToolSection) -> String? {
        switch toolItem {
        case .mindset:
            return contentItem(for: ContentService.Tags.toolsMindsetSectionTitle.predicate)?.valueText
        case .nutrition:
            return contentItem(for: ContentService.Tags.toolsNutritionSectionTitle.predicate)?.valueText
        case .movement:
            return contentItem(for: ContentService.Tags.toolsMovementSectionTitle.predicate)?.valueText
        case .recovery:
            return contentItem(for: ContentService.Tags.toolsRecoverySectionTitle.predicate)?.valueText
        case .habituation:
            return contentItem(for: ContentService.Tags.toolsHabituationSectionTitle.predicate)?.valueText
        }
    }

    func toolsHeaderTitle() -> String? {
        return contentItem(for: ContentService.Tags.toolsHeaderTitle.predicate)?.valueText
    }

    func toolsHeaderSubtitle() -> String? {
        return contentItem(for: ContentService.Tags.toolsHeaderSubtitle.predicate)?.valueText
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

// MARK: - ConfirmationView Mindset Shifter

extension ContentService {

    var mindsetShifterConfirmationTitle: String {
        return contentItem(for: Tags.ConfirmationView.mindsetShifterTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterConfirmationDescription: String {
        return contentItem(for: Tags.ConfirmationView.mindsetShifterDescription.predicate)?.valueText ?? ""
    }

    var mindsetShifterConfirmationYes: String {
        return contentItem(for: Tags.ConfirmationView.mindsetShifterButtonYes.predicate)?.valueText ?? ""
    }

    var mindsetShifterConfirmationNo: String {
        return contentItem(for: Tags.ConfirmationView.mindsetShifterButtonNo.predicate)?.valueText ?? ""
    }
}

// MARK: - ConfirmationView Solve

extension ContentService {

    var solveConfirmationTitle: String {
        return contentItem(for: Tags.ConfirmationView.solveTitle.predicate)?.valueText ?? ""
    }

    var solveConfirmationDescription: String {
        return contentItem(for: Tags.ConfirmationView.solveDescription.predicate)?.valueText ?? ""
    }

    var solveConfirmationYes: String {
        return contentItem(for: Tags.ConfirmationView.solveButtonYes.predicate)?.valueText ?? ""
    }

    var solveConfirmationNo: String {
        return contentItem(for: Tags.ConfirmationView.solveButtonNo.predicate)?.valueText ?? ""
    }
}

// MARK: - Mindset Shifter Checklist

extension ContentService {

    var mindsetShifterHeaderTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.headerTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterHeaderSubtitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.headerSubtitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterTriggerTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.triggerTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterReactionsTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.reactionsTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterNegativeToPositiveTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.negativeToPositiveTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterNegativeToPositiveLowTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.negativeToPositiveLowTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterNegativeToPositiveHighTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.negativeToPositiveHighTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterVisionTitle: String {
        return contentItem(for: Tags.MindsetShifterCheclist.visionTitle.predicate)?.valueText ?? ""
    }

    var mindsetShifterSaveButtonText: String {
        return contentItem(for: Tags.MindsetShifterCheclist.buttonText.predicate)?.valueText ?? ""
    }
}
