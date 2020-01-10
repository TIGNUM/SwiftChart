//
//  MyQOTAdminEditSprintsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminEditSprintsWorker {

    var datasource: [QDMSprint] = []

    // MARK: - Init
    init() {

    }

    func getSprints(completion: @escaping () -> Void) {
        UserService.main.getSprints { [weak self] (sprints, _, _) in
            self?.datasource = sprints ?? []
            completion()
        }
    }
}
