//
//  ArticleWorker.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleWorker {

    // MARK: - Properties

    let services: Services
    private var selectedID: Int

    private lazy var content: ContentCollection? = {
        return services.contentService.contentCollection(id: selectedID)
    }()

    private lazy var relatedContent: [ContentCollection] = {
        guard let content = content else { return [] }
        return services.contentService.relatedContentList(for: content)
    }()

    private lazy var isWhatsHot: Bool = {
        return content?.section == Database.Section.learnWhatsHot.value
    }()

    private lazy var articleAudioItem: ContentItem? = {
        return (content?.articleItems.filter { $0.tabs == "AUDIO" })?.first
    }()

    lazy var articleHeader: Article.Header = {
        return Article.Header(categoryTitle: content?.contentCategories.first?.title ?? "",
                              title: content?.title ?? "",
                              author: content?.author,
                              publishDate: content?.publishDate,
                              timeToRead: content?.minutesToRead,
                              imageURL: content?.thumbnailURLString)
    }()

    lazy var relatedArticlesWhatsHot: [Article.RelatedArticleWhatsHot] = {
        var articles = [Article.RelatedArticleWhatsHot]()
        relatedContent.forEach { content in
            if content.isWhatsHot == true {
                articles.append(Article.RelatedArticleWhatsHot(remoteID: content.remoteID.value ?? 0,
                                                               title: content.title,
                                                               publishDate: content.publishDate,
                                                               author: content.author,
                                                               timeToRead: content.durationString,
                                                               imageURL: content.imageURL,
                                                               isNew: false))
            }
        }
        return articles
    }()

    lazy var relatedArticlesStrategy: [Article.RelatedArticleStrategy] = {
        var articles = [Article.RelatedArticleStrategy]()
        relatedContent.forEach { content in
            articles.append(Article.RelatedArticleStrategy(title: content.title,
                                                           durationString: content.durationString,
                                                           remoteID: content.remoteID.value ?? 0))
        }
        return articles
    }()

    lazy var audioItem: Article.Item? = {
        guard
            let audioItem = articleAudioItem,
            let audioURL = URL(string: audioItem.valueMediaURL ?? "") else { return nil }
        return Article.Item(type: ContentItemValue.audio(title: audioItem.valueText ?? "",
                                                         description: audioItem.description,
                                                         placeholderURL: URL(string: audioItem.valueImageURL ?? ""),
                                                         audioURL: audioURL,
                                                         duration: Double(audioItem.secondsRequired),
                                                         waveformData: []))
    }()

    lazy var categoryTitle: String = {
        return content?.contentCategories.first?.title ?? ""
    }()

    lazy var title: String = {
        return content?.title ?? ""
    }()

    lazy var remoteID: Int = {
        return content?.remoteID.value ?? 0
    }()

    lazy var audioURL: URL? = {
        return URL(string: articleAudioItem?.valueMediaURL ?? "")
    }()

    lazy var isShareable: Bool = {
        return content?.shareableLink != nil
    }()

    lazy var whatsHotShareable: WhatsHotShareable = {
        return WhatsHotShareable(message: content?.title ?? "",
                                 imageURL: content?.thumbnailURL,
                                 shareableLink: content?.shareableLink)
    }()

    // TODO Create items for LEARN_STRATEGIES; Figure how NEXT UP should work, what about videos,
    private lazy var whatsHotItems: [Article.Item] = {
        var items = [Article.Item]()
        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        items.append(Article.Item(type: ContentItemValue.headerImage(imageURLString: articleHeader.imageURL)))
        content?.articleItems.forEach { item in
            items.append(Article.Item(remoteID: item.remoteID.value ?? 0,
                                      type: item.contentItemValue,
                                      content: item.valueText ?? "",
                                      format: item.format,
                                      bundledAudioURL: item.bundledAudioURL,
                                      thumbnailURL: item.valueImageURL))
        }
        relatedArticlesWhatsHot.forEach { relatedArticle in
            items.append(Article.Item(type: ContentItemValue.articleRelatedWhatsHot(relatedArticle: relatedArticle)))
        }
        return items
    }()

    private lazy var learnStrategyItems: [Article.Item] = {
        var items = [Article.Item]()
        items.append(Article.Item(type: ContentItemValue.headerText(header: articleHeader)))
        content?.articleItems.filter { $0.tabs == "BULLETS" }.forEach { (bulletItem) in
            items.append(Article.Item(type: bulletItem.contentItemValue, content: bulletItem.valueText ?? ""))
        }
        content?.articleItems.filter { $0.tabs == "FULL" && $0.format != "pdf" && $0.format != "video" }.forEach { item in
            items.append(Article.Item(type: item.contentItemValue, content: item.valueText ?? ""))
        }
        items.append(Article.Item(type: ContentItemValue.button(selected: content?.contentRead != nil), content: ""))
        content?.articleItems.filter { $0.tabs == "FULL" && $0.format == "pdf" && $0.format != "video" }.forEach { item in
            if let pdfURL = URL(string: item.valueMediaURL ?? "") {
                let date = Date().addingTimeInterval(TimeInterval(item.secondsRequired))
                var timeToReadText = ""
                if let timeString = DateComponentsFormatter.timeIntervalToString(date.timeIntervalSinceNow, isShort: true) {
                    timeToReadText = "PDF | \(timeString)  \(R.string.localized.learnContentItemToRead())"
                }
                items.append(Article.Item(type: ContentItemValue.pdf(title: item.valueText ?? "",
                                                                     description: timeToReadText,
                                                                     pdfURL: pdfURL,
                                                                     itemID: item.remoteID.value ?? 0)))
            }
        }
        content?.articleItems.filter { $0.tabs == "FULL" && $0.format == "video" }.forEach { item in
            if let videoURL = URL(string: item.valueMediaURL ?? "") {
                items.append(Article.Item(type: ContentItemValue.video(title: item.valueText ?? "",
                                                                       description: item.description,
                                                                       placeholderURL: URL(string: item.valueImageURL ?? ""),
                                                                       videoURL: videoURL,
                                                                       duration: Double(item.secondsRequired))))
            }
        }
        relatedArticlesStrategy.forEach { relatedArticle in
            items.append(Article.Item(type: ContentItemValue.articleRelatedStrategy(title: relatedArticle.title,
                                                                                    description: relatedArticle.durationString,
                                                                                    itemID: relatedArticle.remoteID)))
        }
        return items
    }()

    // MARK: - Init

    init(services: Services, selectedID: Int) {
        self.services = services
        self.selectedID = selectedID
    }

    var sectionCount: Int {
        return relatedArticlesWhatsHot.count > 0 ? 2 : 1
    }

    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot {
        return relatedArticlesWhatsHot[indexPath.item]
    }

    func articleItem(at indexPath: IndexPath) -> Article.Item {
        return isWhatsHot == true ? whatsHotItems[indexPath.item] : learnStrategyItems[indexPath.item]
    }

    func markArticleAsRead() {
        services.contentService.setContentViewed(remoteID: selectedID)
    }

    func itemCount(in section: Int) -> Int {
        return isWhatsHot == true ? whatsHotItems.count : learnStrategyItems.count
    }

    func updateSelectedContent(selectedID: Int) {
        self.selectedID = selectedID
    }
}
