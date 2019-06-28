//
//  WhatsHotLatestWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class WhatsHotLatestWorker {

    // MARK: - Functions

    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        qot_dal.ContentService.main.getContentCollectionBySection(.WhatsHot, { (items) in
            completion(items?.last?.remoteID)
        })
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        latestWhatsHotCollectionID(completion: { [weak self] (collectionID) in
            qot_dal.ContentService.main.getContentItemsByCollectionId(collectionID ?? 0, { (item) in
                completion(item?.first)
            })
        })
    }

    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        latestWhatsHotCollectionID(completion: { [weak self] (collectionID) in
            qot_dal.ContentService.main.getContentCollectionById(collectionID ?? 0, {(item) in
                completion(item)
                })
        })
    }
}
