//
//  PartnerIntermediary.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

struct PartnerIntermediary {
    let localID: String
    var profileImage: UIImage?
    var profileImageURL: String?
    var name: String
    var surname: String
    var initials: String
    var relationship: String
    var email: String
}

extension PartnerIntermediary {
    // TODO: refactor repeated code. @see repetition in Partner
    func generateInitials() -> String {
        var initials = ""
        if let initial = name.characters.first {
            initials += String(initial)
        }
        if let initial = surname.characters.first {
            initials += String(initial)
        }
        return initials
    }
}
