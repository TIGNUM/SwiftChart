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
        return AppTextService.get(.my_qot_my_library_section_header_new_team_title_template)
    }()

    func loadData(in team: QDMTeam?, _ completion: @escaping (_ initiated: Bool, _ categories: [MyLibraryCategoryListModel]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var storages: [QDMUserStorage]?
        var newItemFeeds: [QDMTeamNewsFeed]?
        var initiated = false
        dispatchGroup.enter()
        if let team = team {
            service.getTeamStorages(in: team) { (teamStorages, initialized, error) in
                storages = teamStorages
                initiated = initialized
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            TeamService.main.teamNewsFeeds(for: team, type: .STORAGE_ADDED, onlyUnread: true) { (feeds, _, _) in
                newItemFeeds = feeds
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
            let isTeam = (team != nil)
            var userStorages = [MyLibraryCategoryListModel]()
            let removedDuplications = isTeam ? self.removeDuplicates(from: storages ?? []) : storages ?? []
            let sorted = removedDuplications.sorted(by: { (first, second) -> Bool in
                first.modifiedAt?.timeIntervalSince1970 ?? 0 > second.modifiedAt?.timeIntervalSince1970 ?? 0
            })

            let bookmarks = sorted.compactMap { $0.userStorageType == .BOOKMARK ? $0 : nil }
            let downloads = sorted.compactMap { $0.userStorageType == .DOWNLOAD ? $0 : nil }
            let notes = sorted.compactMap { $0.userStorageType == .NOTE ? $0 : nil }
            let links = sorted.compactMap { $0.userStorageType == .EXTERNAL_LINK ? $0 : nil }

            var newBookmarkCount = 0, newNoteCount = 0, newLinkCount = 0, downloadCount = 0
            if isTeam {
                newBookmarkCount = newItemFeeds?.filter({ $0.teamStorage?.userStorageType == .BOOKMARK }).count ?? 0
                newNoteCount = newItemFeeds?.filter({ $0.teamStorage?.userStorageType == .NOTE }).count ?? 0
                newLinkCount = newItemFeeds?.filter({ $0.teamStorage?.userStorageType == .EXTERNAL_LINK }).count ?? 0
            }
            if !isTeam {
                downloadCount = newItemFeeds?.filter({ $0.teamStorage?.userStorageType == .DOWNLOAD }).count ?? 0
            }

            let allCounts = newBookmarkCount + newNoteCount + newLinkCount + downloadCount

            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_all_title),
                                                   items: sorted,
                                                   icon: R.image.my_library_group(),
                                                   type: .ALL,
                                                   newItemCount: allCounts))
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_bookmarks_title),
                                                   items: bookmarks,
                                                   icon: R.image.my_library_bookmark(),
                                                   type: .BOOKMARK,
                                                   newItemCount: newBookmarkCount))
            if !isTeam {
                let title = AppTextService.get(.my_qot_my_library_section_downloads_title)
                userStorages.append(self.viewModelWith(title: title, items: downloads,
                                                       icon: R.image.my_library_download(), type: .DOWNLOAD,
                                                       newItemCount: 0))
            }
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_links_title),
                                                   items: links,
                                                   icon: R.image.my_library_link(),
                                                   type: .EXTERNAL_LINK,
                                                   newItemCount: newLinkCount))
            userStorages.append(self.viewModelWith(title: AppTextService.get(.my_qot_my_library_section_notes_title),
                                                   items: notes,
                                                   icon: R.image.my_library_note_light(),
                                                   type: .NOTE,
                                                   newItemCount: newNoteCount))
            completion(initiated, userStorages)
        }
    }

    func viewModelWith(title: String,
                       items: [QDMUserStorage]?,
                       icon: UIImage?,
                       type: MyLibraryCategoryType,
                       newItemCount: Int) -> MyLibraryCategoryListModel {
        return MyLibraryCategoryListModel(title: title,
                                          itemCount: items?.count ?? 0,
                                          lastUpdated: items?.first?.modifiedAt,
                                          icon: icon,
                                          type: type,
                                          newItemCount: newItemCount)
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
