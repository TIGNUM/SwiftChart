//
//  DailyBriefWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefWorker {

    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        qot_dal.ContentService.main.getContentCollectionBySection(.WhatsHot, { (items) in
            completion(items?.last?.remoteID)
        })
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        latestWhatsHotCollectionID(completion: { (collectionID) in
            qot_dal.ContentService.main.getContentItemsByCollectionId(collectionID ?? 0, { (item) in
                completion(item?.first)
            })
        })
    }

    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        latestWhatsHotCollectionID(completion: { (collectionID) in
            qot_dal.ContentService.main.getContentCollectionById(collectionID ?? 0, completion)
        })
    }

    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void) {
        latestWhatsHotContent(completion: { [weak self] (item) in
            self?.getContentCollection(completion: { (collection) in
                if let collection = collection {
                    completion(WhatsHotLatestCellViewModel(title: collection.title, image: URL(string: collection.thumbnailURLString ?? ""), author: collection.author, publisheDate: item?.createdAt, timeToRead: collection.secondsRequired, isNew: self?.isNew(collection) ?? false, remoteID: collection.remoteID, domainModel: nil))
                }
            })
        })
    }

    func isNew(_ collection: QDMContentCollection) -> Bool {
        var isNewArticle = collection.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = collection.viewedAt == nil && collection.modifiedAt ?? collection.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }

    func randomQuestionModel(completion: @escaping ((QuestionCellViewModel)?) -> Void) {
        qot_dal.ContentService.main.getContentCategory(.QuestionWithoutAnswer, { (category) in
            completion(QuestionCellViewModel(text: category?.contentCollections.first?.contentItems.randomElement()?.valueText, domainModel: nil))
        })
    }

    func createThoughtsModel(completion: @escaping ((ThoughtsCellViewModel)?) -> Void) {
        var model: [ThoughtsCellViewModel] = []
        qot_dal.ContentService.main.getContentCategory(.ThoughtsToPonder, { ( category) in
            category?.contentCollections.forEach { (collection) in
                model.append(ThoughtsCellViewModel(thought: collection.contentItems.first?.valueText, author: collection.author, domainModel: nil))
            }
            completion(model.randomElement())
        })
    }

    func createFactsModel(completion: @escaping ((GoodToKnowCellViewModel)?) -> Void) {
        var model: [GoodToKnowCellViewModel] = []
        qot_dal.ContentService.main.getContentCategory(.GoodToKnow, { ( category) in
            category?.contentCollections.forEach { (collection) in
                model.append(GoodToKnowCellViewModel(fact: collection.contentItems.first?.valueText, image: URL(string: (collection.thumbnailURLString ?? "")), domainModel: nil))
            }
            completion(model.randomElement())
        })
    }

    func lastMessage(completion: @escaping ((FromTignumCellViewModel)?) -> Void) {
        var model: [FromTignumCellViewModel]? = []
        qot_dal.ContentService.main.getContentCategory(.FromTignum, { (category) in
            category?.contentCollections.forEach { (collection) in
                model?.append(FromTignumCellViewModel(text: collection.contentItems.first?.valueText, domainModel: nil))
            }
            completion(model?.last)
        })
    }

    func getFeastModel(completion: @escaping ((FeastCellViewModel)?) -> Void) {
        var model: [FeastCellViewModel]? = []
        qot_dal.ContentService.main.getContentCategory(.FeastForEyes, { (category) in
            category?.contentCollections.first?.contentItems.forEach { (item) in
                model?.append(FeastCellViewModel(image: item.valueMediaURL ?? "", remoteID: item.remoteID, domainModel: nil))
            }
            completion(model?.randomElement())
        })
    }

    func getDepartureModel(completion: @escaping ((DepartureInfoCellViewModel)?) -> Void) {
        var model: [DepartureInfoCellViewModel]? = []
        qot_dal.ContentService.main.getContentCollectionBySection(.Departure, { (collections) in
            collections?.forEach { (collection) in
                model?.append(DepartureInfoCellViewModel(text: collection.contentItems.first?.valueText, image: collection.thumbnailURLString ?? "", link: collection.shareableLink, domainModel: nil))
            }
            completion(model?.randomElement())
        })
    }
}
