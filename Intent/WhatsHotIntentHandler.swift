//
//  WhatsHotIntentHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 12.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import Intents

final class WhatsHotIntentHandler: NSObject, WhatsHotIntentHandling {

    func handle(intent: WhatsHotIntent, completion: @escaping (WhatsHotIntentResponse) -> Void) {
        if let articles: ArticleCollectionViewData = ExtensionUserDefaults.object(for: .siri, key: .whatsHot) {
            let unReadArticles = articles.items.filter { $0.newArticle == true }
            if unReadArticles.count == 1 {
                let articleID = unReadArticles[0].contentCollectionID.description
                let userActivity = NSUserActivity.activity(for: .whatsHotArticle, arguments: [articleID])
                let author = unReadArticles[0].author.displayableAuthor()
                let title = unReadArticles[0].description
                let response = WhatsHotIntentResponse.successOneArticle(firstArticleAuthor: author,
                                                                        firstArticleTitle: title)
                response.firstArticleImageURL = unReadArticles.first?.previewImageURL
                response.firstArticleDuration = unReadArticles.first?.duration
                response.userActivity = userActivity
                completion(response)
            } else if unReadArticles.count > 1 {
                let userActivity = NSUserActivity.activity(for: .whatsHotArticlesList)
                let firstAuthor = unReadArticles[0].author.displayableAuthor()
                let firstTitle = unReadArticles[0].description
                let secondAuthor = unReadArticles[1].author.displayableAuthor()
                let secondTitle = unReadArticles[1].description
                let response = WhatsHotIntentResponse.successTwoArticles(firstArticleAuthor: firstAuthor,
                                                                         firstArticleTitle: firstTitle,
                                                                         secondArticleAuthor: secondAuthor,
                                                                         secondArticleTitle: secondTitle)
                response.firstArticleDuration = unReadArticles[0].duration
                response.firstArticleImageURL = unReadArticles[0].previewImageURL
                response.secondArticleDuration = unReadArticles[1].duration
                response.secondArticleImageURL = unReadArticles[1].previewImageURL
                response.userActivity = userActivity
                completion(response)
            } else {
                let userActivity = NSUserActivity.activity(for: .whatsHotArticlesList)
                let response = WhatsHotIntentResponse(code: .noNewArticles, userActivity: userActivity)
                completion(response)
            }
            return
        }
        completion(WhatsHotIntentResponse(code: .failure, userActivity: nil))
    }
}

// MARK: - String

fileprivate extension String {
    
    func displayableAuthor() -> String {
        let authorPlaceholder: String = "TEAM TIGNUM"
        let author: String = replacingOccurrences(of: "by ", with: "")
        return author == "" ? authorPlaceholder : author
    }
}
