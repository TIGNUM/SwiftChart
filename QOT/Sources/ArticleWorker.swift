//
//  ArticleWorker.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ArticleWorker {

    // MARK: - Properties

    weak var interactor: ArticleInteractorInterface?
    private var selectedID: Int

    private var content: QDMContentCollection?

    private var relatedContent = [QDMContentCollection]()

    private var articleAudioItem: QDMContentItem?

    var articleHeader: Article.Header = Article.Header()

    var relatedArticlesWhatsHot = [Article.RelatedArticleWhatsHot]()

    var relatedArticlesStrategy = [Article.RelatedArticleStrategy]()

    var audioArticleItem: Article.Item?

    var bookmark: QDMUserStorage?

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

    // TODO Create items for LEARN_STRATEGIES; Figure how NEXT UP should work, what about videos,
    private var whatsHotArticleItems = [Article.Item]()
    private var whatsHotItems = [Article.Item]()

    private var learnStrategyItems = [Article.Item]()

    // MARK: - Init

    init(selectedID: Int) {
        self.selectedID = selectedID

        qot_dal.ContentService.main.getContentCollectionById(selectedID, { [weak self] (content) in
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
        articleAudioItem = content.contentItems.filter({ (item) -> Bool in
            item.format == .audio && item.tabs.contains(obj: "AUDIO")
        }).first
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
            self?.setupRelatedArticlesStrtegy()
            self?.setupLearnStragyItems()
            self?.setupAudioArticleItem()
            self?.interactor?.dataUpdated()
        }

        qot_dal.ContentService.main.getRelatedContentCollectionsFromContentCollection(content) { [weak self] (relatedContens) in
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
                }
            }

            setupSynchronousSteps()
        }
    }

    private func setupLearnStragyItems() {
        var items = [Article.Item]()
        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        content?.contentItems.filter { $0.tabs.first == "BULLETS" }.forEach { (bulletItem) in
            items.append(Article.Item(type: ContentItemValue(item: bulletItem), content: bulletItem.valueText))
        }
        content?.contentItems.filter { $0.tabs.first == "FULL" && $0.format != .pdf && $0.format != .video }.forEach { item in
            items.append(Article.Item(type: ContentItemValue(item: item), content: item.valueText))
        }
        items.append(Article.Item(type: ContentItemValue.button(selected: content?.viewedAt != nil), content: ""))
        content?.contentItems.filter { $0.tabs.first == "FULL" && $0.format == .pdf && $0.format != .video }.forEach { item in
            if let pdfURL = URL(string: item.valueMediaURL ?? "") {
                let date = Date().addingTimeInterval(TimeInterval(item.valueDuration ?? 0))
                var timeToReadText = ""
                if let timeString = DateComponentsFormatter.timeIntervalToString(date.timeIntervalSinceNow, isShort: true) {
                    timeToReadText = "PDF | \(timeString)  \(R.string.localized.learnContentItemToRead())"
                }
                items.append(Article.Item(type: ContentItemValue.pdf(title: item.valueText,
                                                                     description: timeToReadText,
                                                                     pdfURL: pdfURL,
                                                                     itemID: item.remoteID ?? 0)))
            }
        }
        content?.contentItems.filter { $0.tabs.first == "FULL" && $0.format == .video }.forEach { item in
            if let videoURL = URL(string: item.valueMediaURL ?? "") {
                items.append(Article.Item(type: ContentItemValue.video(remoteId: item.remoteID ?? 0,
                                                                       title: item.valueText,
                                                                       description: item.valueDescription,
                                                                       placeholderURL: URL(string: item.valueImageURL ?? ""),
                                                                       videoURL: videoURL,
                                                                       duration: item.valueDuration ?? 0)))
            }
        }
        if let nextUp = self.nextUp {
            items.append(nextUp)
        }
//        relatedArticlesStrategy.forEach { relatedArticle in
//            items.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: relatedArticle.title,
//                                                                                    description: relatedArticle.durationString,
//                                                                                    itemID: relatedArticle.remoteID)))
//        }
        learnStrategyItems = items

    }

    private func setupWhatsHotArticleItems() {
        var items = [Article.Item]()
        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        items.append(Article.Item(type: ContentItemValue.headerImage(imageURLString: articleHeader.imageURL)))
        content?.contentItems.forEach { item in
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
        relatedArticlesWhatsHot.forEach { relatedArticle in
            items.append(Article.Item(type: ContentItemValue.articleRelatedWhatsHot(relatedArticle: relatedArticle)))
        }
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
        relatedContent.forEach { content in
            if content.isWhatsHot == true {
                let imageURL = URL(string: content.thumbnailURLString ?? "")
                articles.append(Article.RelatedArticleWhatsHot(remoteID: content.remoteID ?? 0,
                                                               title: content.title,
                                                               publishDate: content.publishedDate,
                                                               author: content.author,
                                                               timeToRead: content.durationString,
                                                               imageURL: imageURL,
                                                               isNew: false))
            }
        }
        relatedArticlesWhatsHot = articles
    }

    private func setupRelatedArticlesStrtegy() {
        var articles = [Article.RelatedArticleStrategy]()
        relatedContent.forEach { content in
            articles.append(Article.RelatedArticleStrategy(title: content.title,
                                                           durationString: content.durationString,
                                                           remoteID: content.remoteID ?? 0))
        }
        relatedArticlesStrategy = articles
    }

    var sectionCount: Int {
        if content?.isWhatsHot ?? false {
            return relatedArticlesWhatsHot.isEmpty ? 1 : 2
        }
        return 1
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
            return indexPath.section == 0 ? whatsHotArticleItems.at(index: indexPath.item) : whatsHotItems.at(index: indexPath.item)
        default:
            return learnStrategyItems.at(index: indexPath.item)
        }
    }

    func markArticleAsRead() {
//        services.contentService.setContentViewed(remoteID: selectedID)
    }

    func itemCount(in section: Int) -> Int {
        switch content?.section {
        case .WhatsHot?:
            return section == 0 ? whatsHotArticleItems.count : whatsHotItems.count
        default:
            return learnStrategyItems.count
        }
    }

    func updateSelectedContent(selectedID: Int) {
        self.selectedID = selectedID
    }

    func toggleBookmark() -> Bool {
        var hasBookmark = (self.bookmark != nil)
        if hasBookmark {
            // remove
            qot_dal.UserStorageService.main.deleteUserStorage(self.bookmark!) { (error) in
                self.bookmark = nil
            }
            hasBookmark = false
        } else if let content = self.content {
            // add
            qot_dal.UserStorageService.main.addBookmarkContentCollection(content) { (bookmark, error) in
                self.bookmark = bookmark
            }
            hasBookmark = true
        } else {
            bookmark = nil
            hasBookmark = false
        }
        return hasBookmark
    }
}
