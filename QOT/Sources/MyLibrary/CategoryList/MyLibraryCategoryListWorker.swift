//
//  MyLibraryCategoryListWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListWorker {

    private let service = UserStorageService.main

    lazy var titleText: String = {
        return AppTextService.get(.my_qot_my_library_section_header_title)
    }()

    lazy var titleTemplateForTeam: String = {
        return AppTextService.get(.my_qot_my_library_section_header_team_title_template)
    }()

    func loadData(in team: QDMTeam?, _ completion: @escaping (_ initiated: Bool, _ categories: [MyLibraryCategoryListModel]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var storages: [QDMUserStorage]?
        var initiated = false
        dispatchGroup.enter()
        if let team = team {
            service.getTeamStorages (in: team) { (teamStorages, initialized, error) in
                storages = teamStorages
                initiated = initialized
                dispatchGroup.leave()
            }
        } else {
            service.getUserStorages { (userStorages, initialized, error) in
                initiated = initialized
                storages = userStorages
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            var userStorages = [MyLibraryCategoryListModel]()
            let sorted = storages?.sorted(by: { (first, second) -> Bool in
                first.modifiedAt?.timeIntervalSince1970 ?? 0 > second.modifiedAt?.timeIntervalSince1970 ?? 0
            })

            let bookmarks = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .BOOKMARK ? storage : nil
            })

            let downloads = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .DOWNLOAD ? storage : nil
            })

            let notes = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .NOTE ? storage : nil
            })

            let links = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .EXTERNAL_LINK ? storage : nil
            })

            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_all_title),
                                                   items: self.removeDuplicates(from: sorted ?? []),
                                                   icon: R.image.my_library_group(),
                                                   type: .ALL))
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_bookmarks_title),
                                                   items: bookmarks,
                                                   icon: R.image.my_library_bookmark(),
                                                   type: .BOOKMARKS))
            if team == nil {
                let title = AppTextService.get(.my_qot_my_library_section_downloads_title)
                userStorages.append(self.viewModelWith(title: title, items: downloads,
                                                       icon: R.image.my_library_download(), type: .DOWNLOADS))
            }
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_links_title),
                                                   items: links,
                                                   icon: R.image.my_library_link(),
                                                   type: .LINKS))
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_notes_title),
                                                   items: notes,
                                                   icon: R.image.my_library_note_light(),
                                                   type: .NOTES))
            completion(initiated, userStorages)
        }
    }

    func viewModelWith(title: String, items: [QDMUserStorage]?, icon: UIImage?, type: MyLibraryCategoryType) -> MyLibraryCategoryListModel {
        return MyLibraryCategoryListModel(title: title,
                                          itemCount: items?.count ?? 0,
                                          lastUpdated: items?.first?.modifiedAt,
                                          icon: icon,
                                          type: type)
    }

    private func removeDuplicates(from results: [QDMUserStorage]) -> [QDMUserStorage] {
        var tempResults = [QDMUserStorage]()
        for result in results {
            if tempResults.contains(obj: result) == false {
                tempResults.append(result)
            }
        }
        return tempResults
    }
}

extension QDMUserStorage: Equatable {
    public static func == (lhs: QDMUserStorage, rhs: QDMUserStorage) -> Bool {
        return lhs.author == rhs.author && lhs.title == rhs.title && lhs.durationInSeconds == rhs.durationInSeconds
    }
}
