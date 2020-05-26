//
//  FeatureExplainerWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FeatureExplainerWorker {

    // MARK: - Properties
    private let contentService: ContentService

    // MARK: - Init
    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }
}

extension FeatureExplainerWorker {

    func getExplainerContent(featureType: FeatureExplainer.Kind,
                             _ completion: @escaping (QDMContentCollection?) -> Void) {
        contentService.getContentCollectionById(featureType.contentId) { (contentCollection) in
            completion(contentCollection)
        }
    }
}
