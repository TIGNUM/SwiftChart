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

    func libraryCategories() -> AnyRealmCollection<ContentCategory> {
        return mainRealm.contentCategories(section: .library)
    }

    func toolsCategories() -> AnyRealmCollection<ContentCategory> {
        let library = Database.Section.library.rawValue
        let predicate = NSPredicate(format: "ANY contentCollections.section == %@ AND remoteID != %d", library, 100037)
        return AnyRealmCollection(mainRealm.objects(ContentCategory.self).filter(predicate))
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
