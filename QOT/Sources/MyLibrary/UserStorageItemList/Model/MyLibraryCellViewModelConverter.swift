//
//  MyLibraryCellViewModelConverter.swift
//  QOT
//
//  Created by Sanggeon Park on 07.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class MyLibraryCellViewModelConverter {
    lazy var personalNote: String = {
        return AppTextService.get(.my_qot_my_library_notes_section_item_label_personal_notes)
    }()

    lazy var downloading: String = {
        return AppTextService.get(.my_qot_my_library_downloads_section_item_label_downloading)
    }()

    lazy var waitingForDownload: String = {
        return AppTextService.get(.my_qot_my_library_downloads_section_item_label_waiting)
    }()

    lazy var read: String = {
        return AppTextService.get(.my_qot_my_library_labels_title_read)
    }()

    lazy var watch: String = {
        return AppTextService.get(.my_qot_my_library_labels_title_watch)
    }()

    lazy var listen: String = {
        return AppTextService.get(.my_qot_my_library_labels_title_listen)
    }()

    func viewModel(from item: QDMUserStorage,
                   team: QDMTeam?,
                   downloadStatus: QDMDownloadStatus?) -> MyLibraryCellViewModel? {
        var viewModel: MyLibraryCellViewModel?
        let creationInfoTextTemplate = AppTextService.get(.daily_brief_section_team_news_feed_creation_info)
        let dateString = DateFormatter.ddMMM.string(from: item.createdAt ?? Date())
        let ownerName = item.owner?.email?.components(separatedBy: "@").first
        let creationInfo = creationInfoTextTemplate
            .replacingOccurrences(of: "${CREATOR ACCOUNT}", with: ownerName ?? "")
            .replacingOccurrences(of: "${CREATION DATE}", with: dateString)
        switch item.userStorageType {
        case .DOWNLOAD:
            viewModel = downloadViewModel(from: item,
                                          creationInfo: team == nil ? nil : creationInfo,
                                          downloadStatus: downloadStatus)
        case .BOOKMARK:
            viewModel = bookmarkViewModel(from: item, creationInfo: team == nil ? nil : creationInfo)
        case .NOTE:
            viewModel = noteViewModel(from: item, creationInfo: team == nil ? nil : creationInfo)
        case .EXTERNAL_LINK:
            viewModel = linkViewModel(from: item, creationInfo: team == nil ? nil : creationInfo)
        case .UNKOWN:
            return nil
        }
        if let team = team {
            viewModel?.removable = ((item.isMine != nil ? item.isMine! : true) || team.thisUserIsOwner)
        }
        return viewModel
    }

    private func downloadViewModel(from item: QDMUserStorage, creationInfo: String?,
                                   downloadStatus: QDMDownloadStatus?) -> MyLibraryCellViewModel {
        let cellStatus: MyLibraryCellViewModel.DownloadStatus
        let description: String
        var fullDuration = ""
        let cellType: MyLibraryCellViewModel.CellType
        let status = (downloadStatus?.status ?? .NONE)
        switch status {
        case .NONE:
            cellType = .DOWNLOAD
            cellStatus = .waiting
            description = ""
        case .WAITING:
            cellType = .DOWNLOAD
            cellStatus = .waiting
            description = waitingForDownload
        case .DOWNLOADING:
            cellType = .DOWNLOAD
            cellStatus = .downloading
            description = downloading
        case .DOWNLOADED:
            cellType = self.cellType(for: item)
            cellStatus = .downloaded
            let duration = mediaDuration(for: item)
            description = duration.simple
            fullDuration = duration.full
        }
        var model = MyLibraryCellViewModel(cellType: cellType,
                                           title: item.title ?? "",
                                           description: description,
                                           duration: fullDuration,
                                           icon: mediaIcon(for: item),
                                           previewURL: URL(string: item.previewImageUrl ?? ""),
                                           type: item.userStorageType,
                                           mediaType: item.mediaType ?? .UNKOWN,
                                           downloadStatus: cellStatus,
                                           identifier: item.qotId ?? "",
                                           remoteId: Int(item.contentId ?? "0") ?? 0,
                                           mediaURL: URL(string: item.mediaPath() ?? ""))
        model.storageUpdateInfo = creationInfo
        return model
    }

    private func noteViewModel(from item: QDMUserStorage, creationInfo: String?) -> MyLibraryCellViewModel {
        var descriptionExtension: String = ""
        if let date = item.createdAt {
            descriptionExtension = " | \(DateFormatter.ddMMM.string(from: date))"
        }
        let description = personalNote + descriptionExtension
        return MyLibraryCellViewModel(cellType: .NOTE,
                                      title: item.note ?? "",
                                      description: creationInfo ?? description,
                                      duration: "",
                                      icon: R.image.my_library_note_light(),
                                      previewURL: nil,
                                      type: item.userStorageType,
                                      mediaType: item.mediaType ?? .UNKOWN,
                                      downloadStatus: .none,
                                      identifier: item.qotId ?? "",
                                      remoteId: Int(item.contentId ?? "0") ?? 0,
                                      mediaURL: URL(string: item.mediaPath() ?? ""))
    }

    private func linkViewModel(from item: QDMUserStorage, creationInfo: String?) -> MyLibraryCellViewModel {
        var description: String = ""
        if let urllString = item.url, let url = URL(string: urllString), let host = url.host {
            description = host.replacingOccurrences(of: "www.", with: "")
        }
        var model = MyLibraryCellViewModel(cellType: .ARTICLE,
                                           title: item.title ?? "",
                                           description: description,
                                           duration: "",
                                           icon: R.image.my_library_link(),
                                           previewURL: URL(string: item.previewImageUrl ?? item.note ?? ""),
                                           type: item.userStorageType,
                                           mediaType: item.mediaType ?? .UNKOWN,
                                           downloadStatus: .none,
                                           identifier: item.qotId ?? "",
                                           remoteId: Int(item.contentId ?? "0") ?? 0,
                                           mediaURL: URL(string: item.mediaPath() ?? ""))
        model.storageUpdateInfo = creationInfo
        return model
    }

    private func bookmarkViewModel(from item: QDMUserStorage, creationInfo: String?) -> MyLibraryCellViewModel {
        let durations = mediaDuration(for: item)
        var model = MyLibraryCellViewModel(cellType: cellType(for: item),
                                           title: item.title ?? "",
                                           description: durations.simple,
                                           duration: durations.full,
                                           icon: mediaIcon(for: item),
                                           previewURL: URL(string: item.previewImageUrl ?? ""),
                                           type: item.userStorageType,
                                           mediaType: item.mediaType ?? .UNKOWN,
                                           downloadStatus: .none,
                                           identifier: item.qotId ?? "",
                                           remoteId: Int(item.contentId ?? "0") ?? 0,
                                           mediaURL: URL(string: item.mediaPath() ?? ""))
        model.storageUpdateInfo = creationInfo
        return model
    }

    // MARK: Presentation helper methods
    private func mediaIcon(for item: QDMUserStorage) -> UIImage? {
        switch item.mediaType ?? .UNKOWN {
        case .VIDEO:
            return R.image.my_library_camera()
        case .AUDIO:
            return R.image.my_library_listen()
        case .PDF, .UNKOWN:
            return R.image.my_library_read()
        }
    }

    private func mediaDuration(for item: QDMUserStorage) -> (full: String, simple: String) {
        var durationMinute = (item.durationInSeconds ?? 0)/60
        let durationSeconds = (item.durationInSeconds ?? 0)%60
        let fullDuration = String(format: "%d:%02d", durationMinute, durationSeconds)

        var postfix = read
        switch item.mediaType ?? .UNKOWN {
        case .VIDEO:
            postfix = watch
        case .AUDIO:
            postfix = listen
        default:
            break
        }
        var simpleDuration = ""
        if durationSeconds > 30 {
            durationMinute += 1
        }
        if  durationMinute > 0 {
            simpleDuration = "\(durationMinute) min \(postfix)"
        } else if durationSeconds > 0 {
            simpleDuration = fullDuration
        }

        return (fullDuration, simpleDuration)
    }

    private func cellType(for item: QDMUserStorage) -> MyLibraryCellViewModel.CellType {
        let cellType: MyLibraryCellViewModel.CellType
        switch item.contentType {
        case .CONTENT_ITEM:
            switch item.mediaType ?? .UNKOWN {
            case .VIDEO:
                cellType = .VIDEO
            case .AUDIO:
                cellType = .AUDIO
            default:
                cellType = .ARTICLE
            }
        default:
            cellType = .ARTICLE
        }
        return cellType
    }
}
