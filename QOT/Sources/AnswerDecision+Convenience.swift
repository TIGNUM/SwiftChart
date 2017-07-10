//
//  AnswerDecision+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension AnswerDecision {

    enum Target {
        case question(id: Int)
        case content(id: Int)

        init?(type: String, id: Int) {
            switch type {
            case "QUESTION":
                self = .question(id: id)
            case "CONTENT":
                self = .content(id: id)
            default:
                return nil
            }
        }
    }

    var target: Target? {
        guard let type = targetType, let id = targetID else {
            return nil
        }
        return Target(type: type, id: id)
    }
}
