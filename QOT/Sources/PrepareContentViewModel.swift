//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

enum PrepareContentItemType {
    case titleItem(title: String, subTitle: String, contentText: String, placeholderURL: URL?, videoURL: URL?)
    case item(id: Int, title: String, subTitle: String, readMoreID: Int?)
    case tableFooter(preparationID: Int)
}

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

    private var headerToggleState: [Bool] = []
    var displayMode: DisplayMode
    var checkedIDs: [Int: Date?]
    var title: String = ""
    var subTitle: String = ""
    var contentText: String = ""
    var videoPlaceholder: URL?
    var video: URL?
    var items: [PrepareContentItemType] = []
    var preparationID: String?

    var checkedCount: Int {
        return checkedIDs.reduce(0) { (result: Int, check: (key: Int, value: Date?)) -> Int in
            return (check.value == nil) ? result : result + 1
        }
    }
    
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

    init(title: String, video: Video?, description: String, items: [PrepareItem], checkedIDs: [Int: Date?], preparationID: String) {
        self.title = title
        self.video = video?.url
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description
        self.checkedIDs = checkedIDs
        self.displayMode = .checkbox
        self.preparationID = preparationID
        makeItems(items)

        if displayMode == .checkbox {
            setSubtitle()
        }
    }

    private func setSubtitle() {
        subTitle = String(format: "%02d/%02d ", checkedCount, items.count - 1) + R.string.localized.prepareContentTasks()
        items.remove(at: 0)
        items.insert(.titleItem(title: title, subTitle: subTitle, contentText: contentText, placeholderURL: videoPlaceholder, videoURL: video), at: 0)
    }
    
    private func dateForID(_ id: Int) -> Date? {
        guard let date: Date? = checkedIDs[id] else {
            assertionFailure("date shouldnt be missing")
            return nil
        }
        return date
    }

    // MARK: - Public

    func isChecked(id: Int) -> Bool {
        if displayMode != .checkbox {
            return false
        }
        return dateForID(id) != nil
    }

    func didTapCheckbox(id: Int) {
        if displayMode != .checkbox {
            return
        }
        if dateForID(id) == nil {
            checkedIDs.updateValue(Date(), forKey: id)
        } else {
            checkedIDs.updateValue(nil, forKey: id)
        }
        setSubtitle()
    }

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(index: Int) {
        headerToggleState[index] = !headerToggleState[index]
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
