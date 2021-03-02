//
//  ArticleWorker.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct WhatsHotShareable {
    let message: String?
    let imageURL: URL?
    let shareableLink: String?
}

final class ArticleWorker {

    // MARK: - Properties

    weak var interactor: ArticleInteractorInterface?
    private var selectedID: Int

    private var content: QDMContentCollection?

    private var relatedContent = [QDMContentCollection]()

    private var articleAudioItem: QDMContentItem?

    var articleHeader: Article.Header = Article.Header()

    var relatedArticlesWhatsHot = [Article.RelatedArticleWhatsHot]()

    var relatedArticlesStrategy = [Article.Item]()

    var audioArticleItem: Article.Item?

    var bookmarks: [QDMUserStorage]?

    var section: ContentSection {
        return content?.section ?? .Unknown
    }

    var alwaysHideTopBar: Bool {
         return shouldAlwaysHideTopBar()
    }

    var categoryTitle: String {
        return content?.contentCategoryTitle ?? String.empty
    }

    var title: String {
        return content?.title ?? String.empty
    }

    var remoteID: Int {
        return content?.remoteID ?? .zero
    }

    var audioURL: URL? {
        if let download = articleAudioItem?.userStorages?.filter({ (storage) -> Bool in
            storage.userStorageType == .DOWNLOAD
        }).first, let downloadURL = URL(string: download.mediaPath() ?? String.empty) {
            return downloadURL
        }
        return URL(string: articleAudioItem?.valueMediaURL ?? "")
    }

    var isShareable: Bool {
        return content?.shareableLink != nil
    }

    var whatsHotShareable: WhatsHotShareable {
        return WhatsHotShareable(message: content?.title ?? String.empty,
                                 imageURL: URL(string: content?.thumbnailURLString ?? String.empty),
                                 shareableLink: content?.shareableLink)
    }

    var nextUp: Article.Item?

    var nextWhatsHotContent: QDMContentCollection?

    var isTopBarHidden: Bool = false

    var isBookmarkItemHidden: Bool = false

    // TODO Create items for LEARN_STRATEGIES; Figure how NEXT UP should work, what about videos,
    private var whatsHotArticleItems = [Article.Item]()
    private var whatsHotItems = [Article.Item]()
    private var learnStrategyItems = [Article.Item]()
    private var learnStrategyRelatedItems = [Article.Item]()
    private var learnStrategyNextItems = [Article.Item]()
    var contactSupportItems = [Article.Item]()

    // MARK: - Init

    init(selectedID: Int) {
        self.selectedID = selectedID

        ContentService.main.getContentCollectionById(selectedID, { [weak self] (content) in
            self?.content = content
            self?.setup()
        })
    }

    private func setup() {
        guard let content = self.content else {
            return
        }
        bookmarks = content.userStorages?.filter({ (storage) -> Bool in
            storage.userStorageType == .BOOKMARK
        })
        let audioAvailableSections: [ContentSection] = [.WhatsHot, .LearnStrategies, .QOTLibrary, .Tools]
        if audioAvailableSections.contains(obj: content.section) {
            articleAudioItem = content.contentItems.filter({ (item) -> Bool in
                item.format == .audio && item.tabs.contains(obj: "AUDIO")
            }).first
        }
        articleHeader = Article.Header(categoryTitle: content.contentCategoryTitle?.uppercased() ?? String.empty,
                                       title: content.title,
                                       author: content.author,
                                       publishDate: content.publishedDate,
                                       timeToRead: content.minutesToRead,
                                       imageURL: content.thumbnailURLString)
        relatedContent = [QDMContentCollection]()
        nextUp = nil
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        ContentService.main.getLatestUnreadWhatsHotArticle(exclude: content.remoteID ?? .zero) { [weak self] (next) in
            if let nextWhatsHot = next {
                self?.nextWhatsHotContent = nextWhatsHot
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        ContentService.main.getRelatedContentCollectionsFromContentCollection(content) { [weak self] (relatedContens) in
            self?.relatedContent = relatedContens?.filter { !$0.contentItems.isEmpty } ?? []
            if let nextUpContentRelation = self?.content?.relatedContentList.filter({ (relation) -> Bool in
                relation.type == "NEXT_UP"
            }).first, let nextUpId = nextUpContentRelation.contentID {
                if let nextCollection = self?.relatedContent.filter({ (contentCollection) -> Bool in
                    contentCollection.remoteID == nextUpId
                }).first {
                    self?.nextUp = Article.Item(type: ContentItemValue.articleNextUp(title: nextCollection.title,
                                                                                     description: nextCollection.durationString,
                                                                                     itemID: nextCollection.remoteID ?? .zero))
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.setupRelatedArticlesWhatsHot()
            self?.setupWhatsHotArticleItems()
            self?.setupWhatsHotItems()
            self?.setupLearnStragyItems()
            self?.setupRelatedArticlesStrtegy()
            self?.setupAudioArticleItem()
            self?.isTopBarHidden = self?.shouldHideTopBar() ?? true
            self?.isBookmarkItemHidden = self?.shouldHideBookmarkButton() ?? false
            self?.interactor?.dataUpdated()
        }
    }

    private func setupLearnStragyItems() {
        var items = [Article.Item]()
        var itemsNextUp = [Article.Item]()
        var itemsRelated = [Article.Item]()
        var contactSupport = [Article.Item]()

        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        content?.contentItems.filter { $0.tabs.first == "BULLETS" }.forEach { (bulletItem) in
            items.append(Article.Item(type: ContentItemValue(item: bulletItem), content: bulletItem.valueText))
        }
        content?.contentItems.filter { $0.tabs.first == "FULL" && $0.format != .pdf }.forEach { item in
            items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
        }
        content?.contentItems.filter {
            $0.tabs.isEmpty
                && content?.section == .ExclusiveRecoveryContent
                || (content?.section == .FAQ_TEAM && $0.format != .subtitle)
                && $0.remoteID != self.articleAudioItem?.remoteID
                && $0.format != .pdf
                && $0.format != .video
                && $0.format != .title }.forEach { item in
                    items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
        }
        if MyQotAboutUsModel.Item.allKeys.contains(selectedID) == false && shouldHideMarkAsReadButton() == false {
            items.append(Article.Item(type: ContentItemValue.button(selected: content?.viewedAt != nil), content: "BUTTON"))
        }
        let infoArticleSections: [ContentSection] = [.About, .FAQ_3_0, .FAQ_TEAM, .USING_QOT]
        if infoArticleSections.contains(obj: content?.section ?? .Unknown) {
            content?.contentItems.forEach({ (item) in
                if item.searchTags.contains("FAQ_SUPPORT_EMAIL") {
                    contactSupport.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
                } else {
                    items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
                }
            })
        }

        content?.relatedContentItems.filter { $0.format == .pdf && $0.format != .video }.forEach { item in
            if let pdfURL = URL(string: item.valueMediaURL ?? String.empty) {
                itemsRelated.append(Article.Item(type: ContentItemValue.pdf(title: item.valueText,
                                                                            description: item.durationString,
                                                                            pdfURL: pdfURL,
                                                                            itemID: item.remoteID ?? .zero)))
            }
        }
        content?.relatedContentItems.filter { $0.tabs.first == "FULL" && $0.format == .video }.forEach { item in
            if let videoURL = URL(string: item.valueMediaURL ?? String.empty) {
            itemsRelated.append(Article.Item(type: ContentItemValue.video(remoteId: item.remoteID ?? .zero,
                                                                              title: item.valueText,
                                                                              description: item.durationString,
                                                                              placeholderURL: URL(string: item.valueImageURL ?? String.empty),
                                                                              videoURL: videoURL,
                                                                              duration: item.valueDuration ?? .zero)))
            }
        }
        content?.relatedContentItems.filter { $0.format == .audio }.forEach { item in
            if let audioURL = URL(string: item.valueMediaURL ?? String.empty) {
            itemsRelated.append(Article.Item(type: ContentItemValue.audio(remoteId: item.remoteID ?? .zero,
                                                                              title: item.valueText,
                                                                              description: item.durationString,
                                                                              placeholderURL: URL(string: item.valueImageURL ?? String.empty),
                                                                              audioURL: audioURL,
                                                                              duration: item.valueDuration ?? .zero,
                                                                              waveformData: [])))
            }
        }
        let nextUpContentIds = content?.relatedContentList.filter({$0.type.uppercased() == "NEXT_UP"}).compactMap({ $0.contentID }) ?? []
        relatedContent.forEach { content in
            guard let contentId = content.remoteID, nextUpContentIds.contains(obj: contentId) != true else { return }
            itemsRelated.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: content.title,
                                                                                       description: content.durationString,
                                                                                       itemID: content.remoteID ?? .zero)))
        }
        if let nextUp = self.nextUp {
            itemsNextUp.append(nextUp)
        }
        learnStrategyItems = items.unique
        learnStrategyNextItems = itemsNextUp
        learnStrategyRelatedItems = itemsRelated
        contactSupportItems = contactSupport.unique
    }

    private func setupWhatsHotArticleItems() {
        var items = [Article.Item]()
        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        items.append(Article.Item(type: ContentItemValue.headerImage(imageURLString: articleHeader.imageURL)))
        content?.contentItems.forEach { item in
            guard item.remoteID != self.articleAudioItem?.remoteID else { return }
            items.append(Article.Item(remoteID: item.remoteID ?? .zero,
                                      type: ContentItemValue(item: item),
                                      content: item.valueText,
                                      format: item.format.rawValue,
                                      bundledAudioURL: nil,
                                      thumbnailURL: item.valueImageURL))
        }
        whatsHotArticleItems = items
    }

    private func setupWhatsHotItems() {
        var items = [Article.Item]()
        relatedArticlesWhatsHot.forEach { relatedArticle in
            items.append(Article.Item(type: ContentItemValue.articleRelatedWhatsHot(relatedArticle: relatedArticle)))
        }
        whatsHotItems = items
    }

    private func setupAudioArticleItem() {
        guard
            let audioItem = articleAudioItem,
            let audioURL = URL(string: audioItem.valueMediaURL ?? String.empty) else {
                articleAudioItem = nil
                return
        }
        audioArticleItem = Article.Item(remoteID: audioItem.remoteID ?? .zero,
                                        type: ContentItemValue.audio(remoteId: audioItem.remoteID ?? .zero,
                                                                     title: audioItem.valueText,
                                                                     description: audioItem.valueDescription,
                                                                     placeholderURL: URL(string: audioItem.valueImageURL ?? String.empty),
                                                                     audioURL: audioURL,
                                                                     duration: audioItem.valueDuration ?? .zero,
                                                                     waveformData: []))
    }

    private func setupRelatedArticlesWhatsHot() {
        var articles = [Article.RelatedArticleWhatsHot]()
        relatedContent.forEach { content in
            if content.isWhatsHot == true {
                let imageURL = URL(string: content.thumbnailURLString ?? String.empty)
                articles.append(Article.RelatedArticleWhatsHot(remoteID: content.remoteID ?? .zero,
                                                               title: content.title,
                                                               publishDate: content.publishedDate,
                                                               author: content.author,
                                                               timeToRead: content.durationString,
                                                               imageURL: imageURL,
                                                               isNew: false))
            }
        }
        if relatedContent.isEmpty {
            let imageURL = URL(string: nextWhatsHotContent?.thumbnailURLString ?? String.empty)
            articles.append(Article.RelatedArticleWhatsHot(remoteID: nextWhatsHotContent?.remoteID ?? .zero,
                                                           title: nextWhatsHotContent?.title ?? String.empty,
                                                           publishDate: nextWhatsHotContent?.publishedDate,
                                                           author: nextWhatsHotContent?.author,
                                                           timeToRead: nextWhatsHotContent?.durationString ?? String.empty,
                                                           imageURL: imageURL,
                                                           isNew: false))

        }
        relatedArticlesWhatsHot = articles
    }

    private func setupRelatedArticlesStrtegy() {
        var articles = [Article.Item]()
        relatedContent.forEach { content in
            articles.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: content.title,
                                                                                       description: content.durationString,
                                                                                       itemID: content.remoteID ?? .zero)))
        }
        relatedArticlesStrategy = articles
    }

    var sectionCount: Int {
        guard let content = content else { return 1 }
        switch content.section {
        case .WhatsHot:
            return relatedArticlesWhatsHot.isEmpty ? 1 : 2
        case .About,
             .ExclusiveRecoveryContent:
            return 1
        case .FAQ_3_0,
             .FAQ_TEAM,
             .USING_QOT:
            return 2
        default:
            return 3
        }
    }

    var sectionHeaderHeight: CGFloat {
        switch content?.section {
        case .WhatsHot?:
            return 60
        default:
            return 40
        }
    }

    var sectionNeedsLine: Bool {
        switch content?.section {
        case .WhatsHot?:
            return true
        default:
            return false
        }
    }

    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot? {
        if relatedArticlesWhatsHot.count > indexPath.item {
            return relatedArticlesWhatsHot[indexPath.item]
        }
        return nil
    }

    func articleItem(at indexPath: IndexPath) -> Article.Item? {
        switch content?.section {
        case .WhatsHot?:
            return indexPath.section == .zero ? whatsHotArticleItems.at(index: indexPath.item) : whatsHotItems.at(index: indexPath.item)
        case .FAQ_3_0?,
            .FAQ_TEAM?,
            .USING_QOT?:
            return indexPath.section == .zero ? learnStrategyItems.at(index: indexPath.item) : contactSupportItems.at(index: indexPath.item)
        default:
            switch indexPath.section {
            case 0:
                return learnStrategyItems.at(index: indexPath.item)
            case 1:
                return learnStrategyRelatedItems.at(index: indexPath.item)
            default:
                return learnStrategyNextItems.at(index: indexPath.item)
            }
        }
    }

    func isSectionSupport() -> Bool {
        switch content?.section {
        case .FAQ_3_0,
             .FAQ_TEAM,
             .USING_QOT: return true
        default: return false
        }
    }

    func contactSupportAttributtedString() -> NSAttributedString {
        let contactSupport = NSMutableAttributedString(attributedString:
            ThemeText.articleContactSupportInfoTitle.attributedString(AppTextService.get(.my_qot_my_profile_support_faq_section_contact_support_title) + "\n"))
        // Contact support
        guard let emailAddress = contactSupportItems.first?.content else {
            return contactSupport
        }
        let supportEmail = AppTextService.get(.my_qot_my_profile_support_section_contact_support_email)
        let attrString = ThemeText.articleContactSupportLink(emailAddress).attributedString(supportEmail)
        contactSupport.append(attrString)

        return contactSupport
    }

    func markArticleAsRead(_ read: Bool, completion: @escaping () -> Void) {
        guard let content = content else { return }
        ContentService.main.markContentCollectionAs(read: read, content) { (_) in
            completion()
        }
    }

    func isRead(completion:@escaping (_ read: Bool) -> Void) {
        ContentService.main.getContentCollectionById(selectedID) { (content) in
            let read = content?.viewedAt != nil
            completion(read)
        }
    }

    func itemCount(in section: Int) -> Int {
        guard let content = content else { return 1 }
        switch content.section {
        case .WhatsHot:
            return section == .zero ? whatsHotArticleItems.count : whatsHotItems.count
        case .FAQ_3_0, .FAQ_TEAM, .USING_QOT:
            return section == .zero ? learnStrategyItems.count : contactSupportItems.count
        default:
            switch section {
            case 0:
                return learnStrategyItems.count
            case 1:
                return learnStrategyRelatedItems.count
            default:
                return learnStrategyNextItems.count
            }
        }
    }

    func headerTitle(for section: Int) -> String? {
        guard let content = content else { return nil }
        switch content.section {
        case .WhatsHot:
            return section == .zero ? nil : AppTextService.get(.know_wh_article_section_read_more_title)
        default:
            return section != 1 ? nil : AppTextService.get(.know_strategy_list_strategy_section_related_content_title)
        }
    }

    func toggleBookmark(_ completion: @escaping (Bool) -> Void) {
        if let bookmark = bookmarks?.first {
            // remove
            UserStorageService.main.deleteUserStorage(bookmark) { [weak self] (_) in
                self?.bookmarks = nil
                completion(self?.bookmarks?.first != nil)
            }
        } else if let content = self.content {
            // add
            UserStorageService.main.addBookmarkContentCollection(content) { [weak self] (bookmark, _) in
                self?.bookmarks = bookmark != nil ? [bookmark!] : nil
                completion(self?.bookmarks?.first != nil)
            }
        } else {
            bookmarks = nil
            DispatchQueue.main.async { completion(false) }
        }
    }

    func updateBookmarkStatus(_ completion: @escaping (Bool) -> Void) {
        ContentService.main.getContentCollectionById(remoteID) { [weak self] (collection) in
            self?.bookmarks = collection?.userStorages?.filter({ $0.userStorageType == .BOOKMARK })
            completion(self?.bookmarks?.first != nil)
        }
    }
}

private extension ArticleWorker {

    func shouldHideTopBar() -> Bool {
        // Handle most frequent case
        guard let content = content else { return true }

        switch content.section {
        case .Generic, .LearnStrategies, .WhatsHot, .ExclusiveRecoveryContent: return false
        default: break
        }
        return true
    }

    func shouldAlwaysHideTopBar() -> Bool {
        guard let content = content else { return true }

        switch content.section {
        case .Generic, .LearnStrategies, .WhatsHot, .ExclusiveRecoveryContent: return false
        default: break
        }
        return true
    }

    func shouldHideMarkAsReadButton() -> Bool {
        // Handle most frequent case
        guard let content = content, content.section != .Generic else { return false }

        switch content.section {
        case .Tools, .QOTLibrary, .About, .FAQ_3_0, .FAQ_TEAM, .USING_QOT, .ExclusiveRecoveryContent: return true
        default: return false
        }
    }

    func shouldHideBookmarkButton() -> Bool {
        return content?.section == .ExclusiveRecoveryContent
    }
}
