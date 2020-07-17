//
//  Notification+Team.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

extension Notification.Name {
    // MyLibrary data was updated and the list needs to be reloaded
    static let didEditTeam = Notification.Name("didEditTeam")
    static let didEditTeamName = Notification.Name("didEditTeamName")
}
