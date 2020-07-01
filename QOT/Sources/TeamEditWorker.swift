//
//  TeamEditWorker.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditWorker {

    func teamCreate(_ name: String?, _ completion: @escaping (QDMTeam?, Bool?, Error?) -> Void) {
        if let name = name {            
            TeamService.main.createTeam(name: name, teamColor: UIColor.randomTeamColor.toHexString, completion)
        } else {
            completion(nil, false, nil)
        }
    }

    func sendInvite(_ email: String?, team: QDMTeam?, _ completion: @escaping (QDMTeamMember?, Bool?, Error?) -> Void) {
        if let team = team, let email = email {
            TeamService.main.inviteTeamMember(email: email, in: team, completion)
        } else {
            completion(nil, false, nil)
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        TeamService.main.getTeamConfiguration { (config, error) in
            completion(config?.teamNameMaxLength ?? 0)
        }
    }
}
