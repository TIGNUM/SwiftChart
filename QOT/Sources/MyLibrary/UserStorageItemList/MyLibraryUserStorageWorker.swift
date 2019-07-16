//
//  MyLibraryUserStorageWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import Alamofire

final class MyLibraryUserStorageWorker {
    private let service = UserStorageService.main
    private var storages = [QDMUserStorage]()
    private let type: UserStorageType
    private let reachability = NetworkReachabilityManager()

    init(type: UserStorageType) {
        self.type = type
    }

    // FIXME: Translate strings
    // MARK: Texts
    lazy var title: String = {
        let title: String
        switch type {
        case .UNKOWN:
            title = "ALL"
        case .BOOKMARK:
            title = "BOOKMARKS"
        case .DOWNLOAD:
            title = "DOWNLOADS"
        case .EXTERNAL_LINK:
            title = "LINKS"
        case .NOTE:
            title = "NOTES"
        }
        return title
    }()

    lazy var addTitle: String = {
        return "Add"
    }()

    lazy var editingTitle: String = {
        let title: String
        switch type {
        case .UNKOWN:
            title = "EDIT ALL"
        case .BOOKMARK:
            title = "EDIT BOOKMARKS"
        case .DOWNLOAD:
            title = "EDIT DOWNLOADS"
        case .EXTERNAL_LINK:
            title = "EDIT LINKS"
        case .NOTE:
            title = "EDIT NOTES"
        }
        return title
    }()

    lazy var cancelTitle: String = {
        return "Cancel"
    }()

    lazy var removeTitle: String = {
        return "Remove"
    }()

    lazy var continueTitle: String = {
        return "Yes, continue"
    }()

    lazy var showAddButton: Bool = {
        return type == .NOTE
    }()

    lazy var removeItemsAlertTitle: String = {
        return "REMOVE SELECTED ITEMS"
    }()

    lazy var removeItemsAlertMessage: NSAttributedString = {
        return NSAttributedString(string:
            "Are you sure you want to remove the selected items from your \(title.lowercased())?")
    }()

    lazy var cellullarDownloadTitle: String = {
        return "USE MOBILE DATA"
    }()

    lazy var cellullarDownloadMessage: NSAttributedString = {
        return NSAttributedString(string:
            "No wi-fi found. Are you sure you want to download the file using mobile data?")
    }()

    lazy var tapToDownload: String = {
        return "Tap to download"
    }()

    lazy var emtptyContentAlertTitle: String = {
        let title: String
        switch type {
        case .UNKOWN:
            title = "ALL ITEMS WILL APPEAR HERE"
        case .BOOKMARK:
            title = "YOUR BOOKMARKED ITEMS WILL APPEAR HERE"
        case .DOWNLOAD:
            title = "YOUR DOWNLOADED ITEMS WILL APPEAR HERE"
        case .EXTERNAL_LINK:
            title = "YOUR WEBSITE LINKS WILL APPEAR HERE"
        case .NOTE:
            title = "YOUR NOTES WILL APPEAR HERE"
        }
        return title
    }()

    lazy var contentIcon: UIImage = {
        let image: UIImage?
        switch type {
        case .UNKOWN:
            image = R.image.my_library_group()
        case .BOOKMARK:
            image = R.image.my_library_bookmark()
        case .DOWNLOAD:
            image = R.image.my_library_download()
        case .EXTERNAL_LINK:
            image = R.image.my_library_link()
        case .NOTE:
            image = R.image.my_library_note_light()
        }
        return image ?? UIImage()
    }()

    lazy var emtptyContentAlertMessage: NSAttributedString = {
        var text: String
        var icon: UIImage? = contentIcon

        switch type {
        case .UNKOWN:
            text = "Access the full list of items you bookmarked, downloaded, or wrote."
            icon = nil
        case .BOOKMARK:
            text = "Look for  {icon}  across QOT and select it to access content offline."
        case .DOWNLOAD:
            text = "Look for  {icon}  across QOT and select it to access content offline."
        case .EXTERNAL_LINK:
            text = "Look for  {icon}  in the browser page and select the QOT app to save it here."
        case .NOTE:
            text = "Click on  {icon}  at the top of the page and create your own notes."
            icon = nil
        }

        let searchText = "{icon}"
        let attributedText = NSMutableAttributedString(string: text)
        guard let range = text.range(of: searchText) else {
            return attributedText
        }

        let replacementText: NSAttributedString
        if let icon = icon {
            let attachment = NSTextAttachment()
            attachment.image = icon
            replacementText = NSAttributedString(attachment: attachment)
        } else {
            replacementText = NSAttributedString(string: addTitle,
                                                 attributes: [.font: UIFont.sfProtextSemibold(ofSize: 16),
                                                              .foregroundColor: UIColor.accent])
        }
        let nsRange = NSRange(range, in: text)
        attributedText.deleteCharacters(in: nsRange)
        attributedText.insert(replacementText, at: nsRange.location)

        return attributedText
    }()

    lazy var personalNote: String = {
        return "Personal note"
    }()

    lazy var downloading: String = {
        return "Downloading..."
    }()

    lazy var waitingForDownload: String = {
        return "Waiting for download..."
    }()

    lazy var read: String = {
        return "to read"
    }()

    lazy var watch: String = {
        return "to watch"
    }()

    lazy var listen: String = {
        return "to listen"
    }()
    
    lazy var contentType: MyLibraryUserStorageContentType = {
        switch type {
        case .UNKOWN: return .all
        case .BOOKMARK: return .bookmarks
        case .DOWNLOAD: return .downloads
        case .EXTERNAL_LINK: return .links
        case .NOTE: return .notes
        }
    }()
}

// MARK: Data loading
extension MyLibraryUserStorageWorker {

    func loadData(_ completion: @escaping (_ initiated: Bool, _ items: [QDMUserStorage]) -> Void) {
        if type != .UNKOWN {
            service.getUserStorages(for: type) { [weak self] (storages, initiated, error) in
                self?.handleStorages(storages, initiated: initiated, completion: completion)
            }
        } else {
            service.getUserStorages { [weak self] (storages, initiated, error) in
                self?.handleStorages(storages, initiated: initiated, completion: completion)
            }
        }
    }

    func downloadStatus(for item: QDMUserStorage) -> QDMDownloadStatus {
        return service.downloadStatus(for: item)
    }

    func pauseDownload(for itemId: String, completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
        guard let item = storages.first(where: { $0.qotId == itemId }) else {
            completion(.NONE)
            return
        }
        service.pauseDownload(item, completion: completion)
    }

    func resumeDownload(for itemId: String, completion: @escaping (_ status: QOTDownloadStatus) -> Void) {
        guard let item = storages.first(where: { $0.qotId == itemId }) else {
            completion(.NONE)
            return
        }
        service.resumeDownload(item, completion: completion)
    }

    var isConnectedToWiFi: Bool {
        if let wifi = reachability?.isReachableOnEthernetOrWiFi {
            return wifi
        }
        return false
    }
}

// MARK: Private methods
extension MyLibraryUserStorageWorker {
    private func handleStorages(_ storages: [QDMUserStorage]?,
                        initiated: Bool,
                        completion: @escaping (_ initiated: Bool, _ items: [QDMUserStorage]) -> Void) {
        self.storages = storages ?? []
        completion(initiated, self.storages)
    }

    func deleteFor(identifiers: [String], _ update: ((_ identifier: String, _ error: Error?) -> Void)?) {
        let storagesToDelete = self.storages.compactMap { (storage) -> QDMUserStorage? in
            identifiers.contains(storage.qotId ?? "INVALID_IDENTIFIER") ? storage : nil
        }
        for storage in storagesToDelete {
            guard let identifier = storage.qotId else {
                break
            }
            service.deleteUserStorage(storage) { (error) in
                update?(identifier, error)
            }
        }
    }
}
