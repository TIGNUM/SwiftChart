//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import LoremIpsum

struct PrepareItem {
    var id: Int
    var title: String
    var subTitle: String
    var readMoreID: Int?

    init(id: Int, title: String, subTitle: String, readMoreID: Int?) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.readMoreID = readMoreID
    }
}

final class PrepareContentViewModel {

    enum DisplayMode {
        case normal
        case checkbox
    }

    struct Video {
        let url: URL
        let placeholderURL: URL?
    }
    
    // MARK: - Properties

    fileprivate var headerToggleState: [Bool] = []

    let updates = PublishSubject<CollectionUpdate, NoError>()

    var displayMode: DisplayMode
    var checkedIDs: [Int: Date]

    var title: String = ""
    var subTitle: String = ""
    var contentText: String = ""
    var videoPlaceholder: URL?
    var video: URL?
    
    var items: [PrepareContentItemType] = []

    // TODO: Implement following methods

    // 1. Implement following init method for prepare list... See: https://zpl.io/Z1pglQ8 & https://zpl.io/ZW59tm & https://zpl.io/ZdIaoX

//    init(title: String, subtitle: String, video: Video?, description: String, items: [PrepareItem]) {
//
//    }

    // 2. Implement following init method for prepare check list. See: https://zpl.io/9yv39
    // 
    // Note that the subtitle is now dyncamic and shows the number of items checked.
    // `checkedIDs` has the id of checked PrepareItems and when they were checked. 

//    init(title: String, video: Video?, description: String, items: [PrepareItem], checkedIDs: [Int: Date]) {
//    
//    }

    // 3. Add id to `PrepareItem` field

    // 4. Use followin to track which items are checked. This dictionary should remain public

    //    var checkedIDs: [Int: Date]

    // 5. Delete the existing init method. Pass in mock data using above init methods

    // MARK: - Initialisation

    init(title: String, subtitle: String, video: Video?, description: String, items: [PrepareItem]) {
        self.title = title
        self.subTitle = subtitle
        self.video = video?.url
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description

        self.checkedIDs = [:]
        self.displayMode = .normal

        makeItems(items)
    }

    init(title: String, video: Video?, description: String, items: [PrepareItem], checkedIDs: [Int: Date]) {
        self.title = title
        self.video = video?.url
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description

        self.checkedIDs = checkedIDs
        self.displayMode = .checkbox

        makeItems(items)

        if displayMode == .checkbox {
            setSubtitle()
        }
    }

    fileprivate func setSubtitle() {
        subTitle = String(format: "%2d/%2d ", checkedIDs.count, items.count - 1) + R.string.localized.prepareContentTasks()
        items.remove(at: 0)
        items.insert(.titleItem(title: title, subTitle: subTitle, contentText: contentText, placeholderURL: videoPlaceholder, videoURL: video), at: 0)
    }

    // MARK: - Public

    func isChecked(id: Int) -> Bool {
        if displayMode != .checkbox {
            return false
        }
        return checkedIDs.index(forKey: id) != nil
    }

    func didTapCheckbox(id: Int) {
        if displayMode != .checkbox {
            return
        }
        if checkedIDs.index(forKey: id) != nil {
            checkedIDs.removeValue(forKey: id)
        } else {
            checkedIDs[id] = Date()
        }
        setSubtitle()

        var indexPaths = [IndexPath(row: 0, section: 0)]
        for i in 1..<items.count {
            switch items[i] {
            case .item(let itemID, _, _, _):
                if id == itemID {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
            default:
                break
            }
        }

        let update = CollectionUpdate.update(deletions: [], insertions: [], modifications: indexPaths)
        updates.next(update)
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(index: Int) {
        headerToggleState[index] = !headerToggleState[index]
//        updates.next(.reload)
    }
    
    func isCellExpanded(at: Int) -> Bool {
        return headerToggleState[at]
    }
}

// MARK: - Private

private extension PrepareContentViewModel {
    
    func fillHeaderStatus() {
        for _ in 0...items.count {
            headerToggleState.append(false)
        }
    }

    func makeItems(_ items: [PrepareItem]) {
        
        self.items.append(.titleItem(title: title, subTitle: subTitle, contentText: contentText, placeholderURL: videoPlaceholder, videoURL: video))
        
        for element in items {
            self.items.append(.item(id: element.id, title: element.title, subTitle: element.subTitle, readMoreID: element.readMoreID))
        }

        if displayMode == .normal {
            self.items.append(.tableFooter(preparationID: 1)) //TODO: we need to set the actual ID
        }
        
        fillHeaderStatus()
    }
}

enum PrepareContentItemType {
    case titleItem(title: String, subTitle: String, contentText: String, placeholderURL: URL?, videoURL: URL?)
    case item(id: Int, title: String, subTitle: String, readMoreID: Int?)
    case tableFooter(preparationID: Int)
}
