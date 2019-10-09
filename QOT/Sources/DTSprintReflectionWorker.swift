//
//  DTSprintReflectionWorker.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTSprintReflectionWorker: DTWorker {
    func updateSprint(sprint: QDMSprint?) {
        if let sprint = sprint {
            UserService.main.updateSprint(sprint) { (sprint, error) in
                if let error = error {
                    log("Error updateSprint \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}
