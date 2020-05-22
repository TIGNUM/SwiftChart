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

    var bookmark: QDMUserStorage?

    var section: ContentSection {
        return content?.section ?? .Unkown
    }

    var alwaysHideTopBar: Bool {
         return shouldAlwaysHideTopBar()
    }

    var categoryTitle: String {
        return content?.contentCategoryTitle ?? ""
    }

    var title: String {
        return content?.title ?? ""
    }

    var remoteID: Int {
        return content?.remoteID ?? 0
    }

    var audioURL: URL? {
        if let download = articleAudioItem?.userStorages?.filter({ (storage) -> Bool in
            storage.userStorageType == .DOWNLOAD
        }).first, let downloadURL = URL(string: download.mediaPath() ?? "") {
            return downloadURL
        }
        return URL(string: articleAudioItem?.valueMediaURL ?? "")
    }

    var isShareable: Bool {
        return content?.shareableLink != nil
    }

    var whatsHotShareable: WhatsHotShareable {
        return WhatsHotShareable(message: content?.title ?? "",
                                 imageURL: URL(string: content?.thumbnailURLString ?? ""),
                                 shareableLink: content?.shareableLink)
    }

    var nextUp: Article.Item?

    var nextWhatsHot: Article.RelatedArticleWhatsHot?

    var isTopBarHidden: Bool = false

    var isBookmarkItemHidden: Bool = false

    // TODO Create items for LEARN_STRATEGIES; Figure how NEXT UP should work, what about videos,
    private var whatsHotArticleItems = [Article.Item]()
    private var whatsHotItems = [Article.Item]()
    private var whatsHotNextItems = [Article.Item]()

    private var learnStrategyItems = [Article.Item]()
    private var learnStrategyRelatedItems = [Article.Item]()
    private var learnStrategyNextItems = [Article.Item]()
    private var whatsHotArticleNextItems = [Article.RelatedArticleWhatsHot]()
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
        bookmark = content.userStorages?.filter({ (storage) -> Bool in
            storage.userStorageType == .BOOKMARK
        }).first
        let audioAvailableSections: [ContentSection] = [.WhatsHot, .LearnStrategies, .QOTLibrary, .Tools]
        if audioAvailableSections.contains(obj: content.section) {
            articleAudioItem = content.contentItems.filter({ (item) -> Bool in
                item.format == .audio && item.tabs.contains(obj: "AUDIO")
            }).first
        }
        articleHeader = Article.Header(categoryTitle: content.contentCategoryTitle?.uppercased() ?? "",
                                       title: content.title,
                                       author: content.author,
                                       publishDate: content.publishedDate,
                                       timeToRead: content.minutesToRead,
                                       imageURL: content.thumbnailURLString)
        relatedContent = [QDMContentCollection]()
        nextUp = nil
        let setupSynchronousSteps: () -> Void = { [weak self] in
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

        ContentService.main.getRelatedContentCollectionsFromContentCollection(content) { [weak self] (relatedContens) in
            self?.relatedContent = relatedContens ?? []

            if let nextUpContentRelation = self?.content?.relatedContentList.filter({ (relation) -> Bool in
                relation.type == "NEXT_UP"
            }).first, let nextUpId = nextUpContentRelation.contentID {
                if let nextCollection = self?.relatedContent.filter({ (contentCollection) -> Bool in
                    contentCollection.remoteID == nextUpId
                }).first {
                    self?.nextUp = Article.Item(type: ContentItemValue.articleNextUp(title: nextCollection.title,
                                                                                     description: nextCollection.durationString,
                                                                                     itemID: nextCollection.remoteID ?? 0))
                    self?.nextWhatsHot = Article.RelatedArticleWhatsHot(remoteID: nextCollection.remoteID ?? 0,
                                                                       title: nextCollection.title,
                                                                       publishDate: nextCollection.publishedDate,
                                                                       author: nextCollection.author,
                                                                       timeToRead: nextCollection.durationString,
                                                                       imageURL: URL(string: nextCollection.thumbnailURLString ?? ""),
                                                                       isNew: nextCollection.viewedAt != nil)
                }
            }

            setupSynchronousSteps()
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
        content?.contentItems.filter { $0.tabs.first == "FULL" && $0.format != .pdf && $0.format != .video }.forEach { item in
            items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
        }
        content?.contentItems.filter {
            $0.tabs.isEmpty
                && content?.section == .ExclusiveRecoveryContent
                && $0.remoteID != self.articleAudioItem?.remoteID
                && $0.format != .pdf
                && $0.format != .video
                && $0.format != .title }.forEach { item in
                    items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
        }
        if MyQotAboutUsModel.Item.allKeys.contains(selectedID) == false && shouldHideMarkAsReadButton() == false {
            items.append(Article.Item(type: ContentItemValue.button(selected: content?.viewedAt != nil), content: "BUTTON"))
        }
        let infoArticleSections: [ContentSection] = [.About, .FAQ_3_0, .USING_QOT]
        if infoArticleSections.contains(obj: content?.section ?? .Unkown) {
            content?.contentItems.forEach({ (item) in
                if item.searchTags.contains("FAQ_SUPPORT_EMAIL") {
                    contactSupport.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
                } else {
                    items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
                }
            })
        }

        content?.relatedContentItems.filter { $0.format == .pdf && $0.format != .video }.forEach { item in
            if let pdfURL = URL(string: item.valueMediaURL ?? "") {
                itemsRelated.append(Article.Item(type: ContentItemValue.pdf(title: item.valueText,
                                                                            description: item.durationString,
                                                                            pdfURL: pdfURL,
                                                                            itemID: item.remoteID ?? 0)))
            }
        }
        content?.relatedContentItems.filter { $0.tabs.first == "FULL" && $0.format == .video }.forEach { item in
            if let videoURL = URL(string: item.valueMediaURL ?? "") {
                itemsRelated.append(Article.Item(type: ContentItemValue.video(remoteId: item.remoteID ?? 0,
                                                                              title: item.valueText,
                                                                              description: item.durationString,
                                                                              placeholderURL: URL(string: item.valueImageURL ?? ""),
                                                                              videoURL: videoURL,
                                                                              duration: item.valueDuration ?? 0)))
            }
        }
        content?.relatedContentItems.filter { $0.format == .audio }.forEach { item in
            if let audioURL = URL(string: item.valueMediaURL ?? "") {
                itemsRelated.append(Article.Item(type: ContentItemValue.audio(remoteId: item.remoteID ?? 0,
                                                                              title: item.valueText,
                                                                              description: item.durationString,
                                                                              placeholderURL: URL(string: item.valueImageURL ?? ""),
                                                                              audioURL: audioURL,
                                                                              duration: item.valueDuration ?? 0,
                                                                              waveformData: [])))
            }
        }
        let nextUpContentIds = content?.relatedContentList.filter({$0.type.uppercased() == "NEXT_UP"}).compactMap({ $0.contentID }) ?? []
        relatedContent.forEach { content in
            guard let contentId = content.remoteID, nextUpContentIds.contains(obj: contentId) != true else { return }
            itemsRelated.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: content.title,
                                                                                       description: content.durationString,
                                                                                       itemID: content.remoteID ?? 0)))
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
            items.append(Article.Item(remoteID: item.remoteID ?? 0,
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
        var nextUpItems = [Article.Item]()
        relatedArticlesWhatsHot.forEach { relatedArticle in
            items.append(Article.Item(type: ContentItemValue.articleRelatedWhatsHot(relatedArticle: relatedArticle)))
        }
        whatsHotArticleNextItems.forEach { nextWhatsHot in
            nextUpItems.append(Article.Item(type:ContentItemValue.nextWhatsHotArticle(nextWhatsHot: nextWhatsHot)))
        }
        whatsHotNextItems = nextUpItems
        whatsHotItems = items
    }

    private func setupAudioArticleItem() {
        guard
            let audioItem = articleAudioItem,
            let audioURL = URL(string: audioItem.valueMediaURL ?? "") else {
                articleAudioItem = nil
                return
        }
        audioArticleItem = Article.Item(remoteID: audioItem.remoteID ?? 0,
                                        type: ContentItemValue.audio(remoteId: audioItem.remoteID ?? 0,
                                                                     title: audioItem.valueText,
                                                                     description: audioItem.valueDescription,
                                                                     placeholderURL: URL(string: audioItem.valueImageURL ?? ""),
                                                                     audioURL: audioURL,
                                                                     duration: audioItem.valueDuration ?? 0,
                                                                     waveformData: []))
    }

    private func setupRelatedArticlesWhatsHot() {
        var articles = [Article.RelatedArticleWhatsHot]()
        var itemsNextUp = [Article.RelatedArticleWhatsHot]()
        let nextUpContentIds = content?.relatedContentList.filter({$0.type.uppercased() == "NEXT_UP"}).compactMap({ $0.contentID }) ?? []
        relatedContent.forEach { content in
            if content.isWhatsHot == true {
                if let contentId = content.remoteID, nextUpContentIds.contains(obj: contentId) != true {
                    let imageURL = URL(string: content.thumbnailURLString ?? "")
                    articles.append(Article.RelatedArticleWhatsHot(remoteID: content.remoteID ?? 0,
                                                                   title: content.title,
                                                                   publishDate: content.publishedDate,
                                                                   author: content.author,
                                                                   timeToRead: content.durationString,
                                                                   imageURL: imageURL,
                                                                   isNew: false))
                }
                if let nextUp = self.nextWhatsHot {
                    itemsNextUp.append(nextUp)
                }
            }
        }
        relatedArticlesWhatsHot = articles
        whatsHotArticleNextItems = itemsNextUp
    }

    private func setupRelatedArticlesStrtegy() {
        var articles = [Article.Item]()
        relatedContent.forEach { content in
            articles.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: content.title,
                                                                                       description: content.durationString,
                                                                                       itemID: content.remoteID ?? 0)))
        }
        relatedArticlesStrategy = articles
    }

    var sectionCount: Int {
        guard let content = content else { return 1 }
        switch content.section {
        case .WhatsHot:
            return 2
        case .About,
             .ExclusiveRecoveryContent:
            return 1
        case .FAQ_3_0,
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

//    DO SOMETHING HERE TO GET NEXT UP
    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot? {
        if relatedArticlesWhatsHot.count > indexPath.item {
            return relatedArticlesWhatsHot[indexPath.item]
        }
        return nil
    }

    func articleItem(at indexPath: IndexPath) -> Article.Item? {
        switch content?.section {
        case .WhatsHot?:
            return indexPath.section == 0 ? whatsHotArticleItems.at(index: indexPath.item) : whatsHotItems.at(index: indexPath.item)
        case .FAQ_3_0?,
             .USING_QOT?:
            return indexPath.section == 0 ? learnStrategyItems.at(index: indexPath.item) : contactSupportItems.at(index: indexPath.item)
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
        return content?.section == .FAQ_3_0 || content?.section == .USING_QOT
    }

    func contactSupportAttributtedString() -> NSAttributedString {
        let contactSupport = NSMutableAttributedString(attributedString:
            ThemeText.articleContactSupportInfoTitle.attributedString(AppTextService.get(.my_qot_my_profile_support_faq_section_contact_support_title) + "\n"))
        // Contact support
        guard let emailAddress = contactSupportItems.first?.content else {
            return contactSupport
        }
        contactSupport.append(ThemeText.articleContactSupportLink(emailAddress).attributedString(AppTextService.get(.my_qot_my_profile_support_section_contact_support_email)))

        return contactSupport
    }

    func markArticleAsRead(_ read: Bool, completion: @escaping () -> Void) {
        guard let content = content else { return }
        ContentService.main.markContentCollectionAs(read: read, content) { (error) in
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
            return section == 0 ? whatsHotArticleItems.count : whatsHotItems.count
        case .FAQ_3_0, .USING_QOT:
            return section == 0 ? learnStrategyItems.count : contactSupportItems.count
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
            return section == 0 ? nil : AppTextService.get(.know_wh_article_section_read_more_title)
        default:
            return section != 1 ? nil : AppTextService.get(.know_strategy_list_strategy_section_related_content_title)
        }
    }

    func toggleBookmark() -> Bool {
        var hasBookmark = (self.bookmark != nil)
        if hasBookmark {
            // remove
            UserStorageService.main.deleteUserStorage(self.bookmark!) { [weak self] (error) in
                self?.bookmark = nil
            }
            hasBookmark = false
        } else if let content = self.content {
            // add
            interactor?.showDestinationAlert()
            UserStorageService.main.addBookmarkContentCollection(content) { [weak self] (bookmark, error) in
                self?.bookmark = bookmark
            }
            hasBookmark = true
        } else {
            bookmark = nil
            hasBookmark = false
        }
        return hasBookmark
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
        case .Tools, .QOTLibrary, .About, .FAQ_3_0, .USING_QOT, .ExclusiveRecoveryContent: return true
        default: return false
        }
    }

    func shouldHideBookmarkButton() -> Bool {
        return content?.section == .ExclusiveRecoveryContent
    }
}
