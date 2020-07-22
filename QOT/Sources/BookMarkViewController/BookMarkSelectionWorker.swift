//
//  BookMarkSelectionWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BookMarkSelectionWorker {

    // MARK: - Properties
    private var contentCategory: QDMContentCategory?
    private var content: QDMContentCollection?
    private var contentItem: QDMContentItem?
    // MARK: - Init

    init() {}

    public func viewModels(for type: UserStorageContentType, contentId: Int,
                           _ completion: @escaping ([BookMarkSelectionModel]) -> Void) {
        var viewModels = [BookMarkSelectionModel]()
        var bookMarks = [QDMUserStorage]()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        switch type {
        case .CONTENT_ITEM:
            ContentService.main.getContentItemById(contentId) { [weak self] (contentItem) in
                self?.contentItem = contentItem
                bookMarks = contentItem?.userStorages ?? []
                dispatchGroup.leave()
            }
        case .CONTENT:
            ContentService.main.getContentCollectionById(contentId) { [weak self] (contentCollection) in
                self?.content = contentCollection
                bookMarks = contentCollection?.userStorages ?? []
                dispatchGroup.leave()
            }
        case .CONTENT_CATEGORY:
            ContentService.main.getContentCategoryById(contentId) { [weak self] (contentCategory) in
                self?.contentCategory = contentCategory
                bookMarks = contentCategory?.userStorages ?? []
                dispatchGroup.leave()
            }
        default:
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            // add private
            let existingPrivateBookmark = bookMarks.filter({ $0.teamQotId == nil }).first
            let viewModel = BookMarkSelectionModel(nil, existingPrivateBookmark)
            viewModel.isSelected = existingPrivateBookmark != nil
            viewModels.append(viewModel)

            TeamService.main.getTeams { (teams, _, _) in
                for team in teams ?? [] {
                    let existingTeamBookmark = bookMarks.filter({ $0.teamQotId == team.qotId }).first
                    let viewModel = BookMarkSelectionModel(team, existingTeamBookmark)
                    viewModel.isSelected = existingTeamBookmark != nil
                    viewModels.append(viewModel)
                }
                completion(viewModels)
            }
        }
    }

    public func update(viewModels: [BookMarkSelectionModel],
                       _ completion: @escaping (Bool) -> Void) {
        let dispatchGroup = DispatchGroup()
        var isChanged = false
        dispatchGroup.enter()
        for viewModel in viewModels {
            if viewModel.storage == nil, viewModel.isSelected {
                isChanged = true
                if let team = viewModel.team {
                    if let contentCategory = self.contentCategory {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentCategory(contentCategory, in: team) { (_, _) in
                            dispatchGroup.leave()
                        }
                    } else if let content = self.content {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentCollection(content, in: team) { (_, _) in
                            dispatchGroup.leave()
                        }
                    } else if let contentItem = self.contentItem {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentItem(contentItem, in: team) { (_, _) in
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    if let contentCategory = self.contentCategory {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentCategory(contentCategory) { (_, _) in
                            dispatchGroup.leave()
                        }
                    } else if let content = self.content {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentCollection(content) { (_, _) in
                            dispatchGroup.leave()
                        }
                    } else if let contentItem = self.contentItem {
                        dispatchGroup.enter()
                        UserStorageService.main.addBookmarkContentItem(contentItem) { (_, _) in
                            dispatchGroup.leave()
                        }
                    }
                }
            } else if viewModel.isSelected == false, let storage = viewModel.storage, storage.isMine == true {
                isChanged = true
                dispatchGroup.enter()
                UserStorageService.main.deleteUserStorage(storage) { (_) in
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.leave()
        dispatchGroup.notify(queue: .main) {
            completion(isChanged)
        }
    }
}
