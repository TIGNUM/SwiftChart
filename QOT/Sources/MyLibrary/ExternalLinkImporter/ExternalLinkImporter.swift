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
        _ = NotificationCenter.default.addObserver(forName: .userLogout,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.onLogout(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .automaticLogout,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.onLogout(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .userLogin,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.load(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.load(notification)
        }
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
            externalLinks.count > .zero else {
                updateLinkTitleAndThumbnail()
                return
        }
        ExtensionUserDefaults.removeObject(for: .share, key: .saveLink)
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        TeamService.main.getTeams { (teams, _, _) in
            for externalLink in externalLinks {
                var team: QDMTeam?
                if let teamQotId = externalLink.teamQotId {
                    team = teams?.filter({$0.qotId == teamQotId}).first
                }

                if let url = externalLink.url {
                    dispatchGroup.enter()
                    if let team = team {
                        UserStorageService.main.addLink(title: "", url: url, in: team) { (_, _) in dispatchGroup.leave() }
                    } else {
                        UserStorageService.main.addLink(title: "", url: url) { (_, _) in dispatchGroup.leave() }
                    }
                } else if externalLink.type == UserStorageType.NOTE.rawValue, let note = externalLink.description {
                    dispatchGroup.enter()
                    if let team = team {
                        UserStorageService.main.addNote(note, in: team) { (_, _) in dispatchGroup.leave() }
                    } else {
                        UserStorageService.main.addNote(note) { (_, _) in dispatchGroup.leave() }
                    }
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { self.updateLinkTitleAndThumbnail() }
    }

    func updateLinkTitleAndThumbnail() {
        let dispatchGroup = DispatchGroup()
        var storages = [QDMUserStorage]()
        dispatchGroup.enter()
        UserStorageService.main.getUserStorages(for: .EXTERNAL_LINK) { (links, _, _) in
            storages.append(contentsOf: links ?? [])
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        UserStorageService.main.getTeamStorages { (teamStorages, _, _) in
            storages.append(contentsOf: (teamStorages ?? []).filter({
                $0.userStorageType == .EXTERNAL_LINK && $0.isMine == true
            }))
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            for link in storages where (link.previewImageUrl ?? "").isEmpty == true {
                var link = link
                let parser = OpenGraphMetaDataParser(with: URL(string: link.url ?? ""))
                dispatchGroup.enter()
                parser.parseMeta { (meta, error) in
                    guard error == nil, meta != nil else {
                        dispatchGroup.leave()
                        return
                    }

                    link.title = meta?.content(for: .title)
                    link.previewImageUrl = meta?.content(for: .image)
                    dispatchGroup.enter()
                    UserStorageService.main.updateUserStorage(link) { (_, _) in
                        dispatchGroup.leave()
                    }
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.leave()
            dispatchGroup.notify(queue: .main) {
                NotificationCenter.default.post(name: .didUpdateMyLibraryData, object: nil)
            }
        }
    }
}
