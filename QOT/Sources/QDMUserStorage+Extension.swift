//
//  QDMUserStorage+Extension.swift
//  QOT
//
//  Created by Sanggeon Park on 10.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension QDMUserStorage {
    func openStorageItem() -> Bool {
        var url: URL?
        switch userStorageType {
        case .BOOKMARK:
            url = URLScheme.randomContent.launchURLWithParameterValue(contentId ?? "")
        case .DOWNLOAD:
            if downloadStaus == .DONE {
                url = URLScheme.contentItem.launchURLWithParameterValue(contentId ?? "")
            }
        case .EXTERNAL_LINK:
            url = self.url != nil ? URL(string: self.url!) : nil
        case .NOTE:
            break
        default:
            return false
        }
        guard let targetURL = url, UIApplication.shared.canOpenURL(targetURL) else { return false }
        UIApplication.shared.open(targetURL, options: [:], completionHandler: nil)
        return true
    }
}
