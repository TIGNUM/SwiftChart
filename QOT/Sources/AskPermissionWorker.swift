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
    private let contentService: qot_dal.ContentService
    private var permissionType: AskPermission.Kind

    // MARK: - Init
    init(contentService: qot_dal.ContentService, permissionType: AskPermission.Kind) {
        self.contentService = contentService
        self.permissionType = permissionType
    }
}

// MARK: Get Values
extension AskPermissionWorker {
    var getPermissionType: AskPermission.Kind {
        return permissionType
    }
}

// MARK: Read DataBase
extension AskPermissionWorker {
    func getPermissionContent(_ completion: @escaping (QDMContentCollection?, AskPermission.Kind?) -> Void) {
        contentService.getContentCollectionById(permissionType.contentId) { [weak self] (contentCollection) in
            completion(contentCollection, self?.permissionType)
        }
    }
}
