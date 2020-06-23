//
//  CreateTeamWorker.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CreateTeamWorker {

    func createTeam(_ name: String, _ completion: @escaping (QDMTeam?, Bool?, Error?) -> Void) {
        TeamService.main.createTeam(name: name, completion)
    }
}
