//
//  ContentService+Ext.swift
//  QOT
//
//  Created by karmic on 18.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension qot_dal.ContentService {
    func getRelatedStrategiesPrepareDefault(_ contentCollectionId: Int,
                                            _ completion: @escaping ([QDMContentCollection]?) -> Void) {
        getContentCollectionById(contentCollectionId) { [weak self] item in
            self?.getContentCollectionsByIds(item?.relatedContentIDsPrepareDefault ?? [], completion)
        }
    }

    func questionId(_ contentItem: QDMContentItem) -> Int {
        if contentItem.valueText.contains(PrepareResult.Key.perceived.tag) {
            return PrepareResult.Key.perceived.questionID
        }
        if contentItem.valueText.contains(PrepareResult.Key.feel.tag) {
            return PrepareResult.Key.feel.questionID
        }
        if contentItem.valueText.contains(PrepareResult.Key.know.tag) {
            return PrepareResult.Key.know.questionID
        }
        if contentItem.valueText.contains(PrepareResult.Key.benefits.tag) {
            return PrepareResult.Key.benefits.questionID
        }
        return 0
    }
}
