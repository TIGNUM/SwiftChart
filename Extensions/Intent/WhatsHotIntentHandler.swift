//
//  WhatsHotIntentHandler.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 12.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import Intents

@available(iOSApplicationExtension 12.0, *)
final class WhatsHotIntentHandler: NSObject, WhatsHotIntentHandling {

    func handle(intent: WhatsHotIntent, completion: @escaping (WhatsHotIntentResponse) -> Void) {
        guard ExtensionUserDefaults.isSignedIn == true else {
            let response = WhatsHotIntentResponse(code: .signedOut, userActivity: nil)
            completion(response)
            return
        }
        track(intent)
        if let articles: ArticleCollectionViewData = ExtensionUserDefaults.object(for: .siri, key: .whatsHot) {
            let unReadArticles = articles.items.filter { $0.newArticle == true }
            if unReadArticles.count == 1 {
                let articleID = unReadArticles[.zero].contentCollectionID.description
                let userActivity = NSUserActivity.activity(for: .whatsHotArticle, arguments: [articleID])
                let author = unReadArticles[.zero].author.displayableAuthor()
                let title = unReadArticles[.zero].description
                let response = WhatsHotIntentResponse.successOneArticle(firstArticleAuthor: author,
                                                                        firstArticleTitle: title)
                response.firstArticleImageURL = unReadArticles.first?.previewImageURL
                response.firstArticleDuration = unReadArticles.first?.duration
                response.userActivity = userActivity
                completion(response)
            } else if unReadArticles.count > 1 {
                let userActivity = NSUserActivity.activity(for: .whatsHotArticlesList)
                let firstAuthor = unReadArticles[.zero].author.displayableAuthor()
                let firstTitle = unReadArticles[.zero].description
                let secondAuthor = unReadArticles[1].author.displayableAuthor()
                let secondTitle = unReadArticles[1].description
                let response = WhatsHotIntentResponse.successTwoArticles(firstArticleAuthor: firstAuthor,
                                                                         firstArticleTitle: firstTitle,
                                                                         secondArticleAuthor: secondAuthor,
                                                                         secondArticleTitle: secondTitle)
                response.firstArticleImageURL = unReadArticles[.zero].previewImageURL
                response.firstArticleDuration = unReadArticles[.zero].duration
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
        let author: String = replacingOccurrences(of: "BY ", with: "")
        return author == "" ? authorPlaceholder : author
    }
}
