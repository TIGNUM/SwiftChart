//
//  Answer+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Answer {

    enum Target {
        case question(id: Int, group: String)
        case content(id: Int, group: String)

        init?(type: String, id: Int, group: String) {
            switch type {
            case "QUESTION":
                self = .question(id: id, group: group)
            case "PREPARE_CONTENT":
                self = .content(id: id, group: group)
            default:
                return nil
            }
        }
    }

    var target: Target? {
        guard let type = targetType, let id = targetID, let group = targetGroup else {
            return nil
        }
        return Target(type: type, id: id, group: group)
    }
}
