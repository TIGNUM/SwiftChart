//
//  AppDelegate+ShareExtension.swift
//  QOT
//
//  Created by Sanggeon Park on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension AppDelegate {
    func importShareExtensionLink() {
        if ExtensionUserDefaults.isSignedIn,
            let data: ShareExtentionData? = ExtensionUserDefaults.object(for: .share, key: .saveLink),
            let title = data?.title,
            let url = data?.url {
            UserStorageService.main.addLink(title: title, url: url) { (_, _) in
                //
            }
            ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
        }
    }
}
