//
//  ContentService+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension ContentService {
    func getRelatedStrategiesPrepareDefault(_ contentCollectionId: Int,
                                            _ completion: @escaping ([QDMContentCollection]?) -> Void) {
        getContentCollectionById(contentCollectionId) { [weak self] item in
            self?.getContentCollectionsByIds(item?.relatedContentIDsPrepareDefault ?? [], completion)
        }
    }

    func questionId(_ contentItem: QDMContentItem) -> Int {
        if contentItem.valueText.contains(Prepare.Key.perceived.tag) {
            return Prepare.Key.perceived.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.feel.tag) {
            return Prepare.Key.feel.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.know.tag) {
            return Prepare.Key.know.questionID
        }
        if contentItem.valueText.contains(Prepare.Key.benefits.tag) {
            return Prepare.Key.benefits.questionID
        }
        return 0
    }
}
