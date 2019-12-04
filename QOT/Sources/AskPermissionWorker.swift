//
//  AskPermissionWorker.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class AskPermissionWorker {

    // MARK: - Properties
    private let contentService: ContentService

    // MARK: - Init
    init(contentService: ContentService) {
        self.contentService = contentService
    }
}

// MARK: Read DataBase
extension AskPermissionWorker {
    func getPermissionContent(permissionType: AskPermission.Kind,
                              _ completion: @escaping (QDMContentCollection?) -> Void) {
        contentService.getContentCollectionById(permissionType.contentId) { (contentCollection) in
            completion(contentCollection)
        }
    }
}
