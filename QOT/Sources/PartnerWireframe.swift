//
//  PartnerWireframe.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PartnerWireframe {
    var name: String? { get set }
    var surname: String? { get set }
    var relationship: String? { get set }
    var email: String? { get set }
    var profileImageURL: String? { get set }
}

extension PartnerWireframe {
    var initials: String {
        var initials = ""
        if let initial = name?.characters.first {
            initials += String(initial)
        }
        if let initial = surname?.characters.first {
            initials += String(initial)
        }
        return initials
    }
    
    var profileImage: UIImage? {
        guard let profileImageURL = profileImageURL, let url = URL(string: profileImageURL) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            log(error)
            return nil
        }
    }
}
