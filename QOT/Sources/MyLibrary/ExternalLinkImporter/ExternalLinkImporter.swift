//
//  ExternalLinkImporter.swift
//  QOT
//
//  Created by Sanggeon Park on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ExternalLinkImporter {
    static private var _main: ExternalLinkImporter?
    static public var main: ExternalLinkImporter {
        if _main == nil {
            _main = ExternalLinkImporter()
        }
        return _main!
    }

    init() {
        // add Listener
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(_:)), name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(_:)), name: .automaticLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(load(_:)), name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(load(_:)),
                                               name: .UIApplicationDidBecomeActive, object: nil)
    }

    @objc func onLogout(_ notification: Notification) {
        ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
    }

    @objc func load(_ notification: Notification) {
        importLink()
    }

    func importLink() {
        guard qot_dal.SessionService.main.getCurrentSession() != nil,
            let externalLink: ShareExtentionData = ExtensionUserDefaults.object(for: .share, key: .saveLink),
            let title = externalLink.title, let url = externalLink.url else {
                return
        }
        ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
        UserStorageService.main.addLink(title: title, url: url) { (storage, error) in
        }
    }
}
