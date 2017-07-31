//
//  MyToBeWireframe.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionWireframe {
    var headline: String? { get set }
    var subHeadline: String? { get set }
    var text: String? { get set }
    var profileImageURL: String? { get set }
    var date: Date { get set }
}

extension MyToBeVisionWireframe {
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

    func shouldUpdate(with new: MyToBeVisionWireframe) -> Bool {
        return headline != new.headline ||
            subHeadline != new.subHeadline ||
            text != new.text ||
            profileImageURL != new.profileImageURL
    }
}
