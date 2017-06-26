//
//  Answer+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 23.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

extension Answer {

    enum Next {
        case question(id: Int)
        case content(id: Int)

        init?(type: String, id: Int) {
            switch type {
            case "QUESTION":
                self = .question(id: id)
            case "PREPARE_CONTENT":
                self = .content(id: id)
            default:
                return nil
            }
        }
    }

    var next: Next? {
        guard let type = nextType, let id = nextID else {
            return nil
        }
        return Next(type: type, id: id)
    }
}
