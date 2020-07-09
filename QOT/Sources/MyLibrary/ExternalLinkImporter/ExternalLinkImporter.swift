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
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(_:)),
                                               name: .userLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLogout(_:)),
                                               name: .automaticLogout, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(load(_:)),
                                               name: .userLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(load(_:)),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc func onLogout(_ notification: Notification) {
        ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
    }

    @objc func load(_ notification: Notification) {
        importLink()
    }

    func importLink() {
        guard SessionService.main.getCurrentSession() != nil,
            let externalLinks: [ShareExtentionData] = ExtensionUserDefaults.object(for: .share, key: .saveLink),
            externalLinks.count > 0 else {
                updateLinkTitleAndThumbnail()
                return
        }
        ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
        let dispatchGroup = DispatchGroup()
        for externalLink in externalLinks {
            print(externalLink)
            if let teamQotId = externalLink.teamQotId {
                TeamService.main.getTeams {(teams, _, error) in
                    guard let team = teams?.filter ({$0.qotId == teamQotId}).first else { return }
                    if let url = externalLink.url {
                        dispatchGroup.enter()
                        UserStorageService.main.addLink(title: "", url: url, in: team) { (_, _) in
                            dispatchGroup.leave()
                        }
                    } else if externalLink.type == UserStorageType.NOTE.rawValue, let note = externalLink.description {
                        dispatchGroup.enter()
                        UserStorageService.main.addNote(note, in: team) { (_, _) in
                            dispatchGroup.leave()
                        }
                    }
                }
            } else {
                if let url = externalLink.url {
                    dispatchGroup.enter()
                    UserStorageService.main.addLink(title: "", url: url) { (_, _) in
                        dispatchGroup.leave()
                    }

                } else if externalLink.type == UserStorageType.NOTE.rawValue, let note = externalLink.description {
                    dispatchGroup.enter()
                    UserStorageService.main.addNote(note) { (_, _) in
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.updateLinkTitleAndThumbnail()
        }
    }

    func updateLinkTitleAndThumbnail() {
        let dispatchGroup = DispatchGroup()
        UserStorageService.main.getUserStorages(for: .EXTERNAL_LINK) { (links, _, error) in
            for link in links ?? [] where (link.title ?? "").isEmpty == true {
                var link = link
                let parser = OpenGraphMetaDataParser(with: URL(string: link.url ?? ""))
                dispatchGroup.enter()
                parser.parseMeta { (meta, error) in
                    guard error == nil, meta != nil else {
                        dispatchGroup.leave()
                        return
                    }

                    link.title = meta?.content(for: .title)
                    link.note = meta?.content(for: .image)
                    dispatchGroup.enter()
                    UserStorageService.main.updateUserStorage(link) { (_, _) in
                        dispatchGroup.leave()
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            NotificationCenter.default.post(name: .didUpdateMyLibraryData, object: nil)
        }
    }
}
