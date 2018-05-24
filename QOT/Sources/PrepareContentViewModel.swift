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
    case reviewNotesHeader(title: String)
    case reviewNotesItem(title: String, reviewNotesType: PrepareContentReviewNotesTableViewCell.ReviewNotesType)
    case checkItemsHeader(title: String)
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
    var notes: String = ""
    var notesDictionary: [Int: String] = [:]
    var relatedPrepareStrategies = [ContentCollection]()
    private let prepareItems: [PrepareItem]
    private let services: Services

    var checkedCount: Int {
        return checkedIDs.reduce(0) { (result: Int, check: (key: Int, value: Date?)) -> Int in
            return (check.value == nil) ? result : result + 1
        }
    }

    // MARK: - Initialisation

    init(title: String,
         subtitle: String,
         video: Video?,
         description: String,
         items: [PrepareItem],
         services: Services) {
        self.prepareItems = items
        self.title = title
        self.subTitle = subtitle
        self.video = video?.url
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description
        self.checkedIDs = [:]
        self.displayMode = .normal
        self.services = services
        makeItems(items)
    }

    init(title: String,
         video: Video?,
         description: String,
         items: [PrepareItem],
         checkedIDs: [Int: Date?],
         preparationID: String,
         contentCollectionTitle: String,
         notes: String,
         notesDictionary: [Int: String],
         services: Services) {
        self.prepareItems = items
        self.title = title
        self.video = video?.url
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description
        self.checkedIDs = checkedIDs
        self.displayMode = .checkbox
        self.preparationID = preparationID
        self.notes = notes
        self.notesDictionary = notesDictionary
        self.services = services

        makeItems(items)

        if displayMode == .checkbox {
            relatedPrepareStrategies = relatedStrategies(for: contentCollectionTitle)
            setSubtitle()
        }
    }
}

// MARK: - Public

extension PrepareContentViewModel {

    var selectedIDs: [Int] {
        return prepareItems.compactMap { $0.readMoreID }
    }

    var itemCount: Int {
        return items.count
    }

    var hasIntentionItems: Bool {
        let results = (prepareItems.map { $0.title }).filter {
            $0.contains("Set clear intentions (create event To Be Vision)")
        }
        return results.isEmpty == false
    }

    var hasRefelctionItems: Bool {
        let results = (prepareItems.map { $0.title }).filter { $0.contains("Mentally visualize success") }
        return results.isEmpty == false
    }

    func notesHeadline(with contentItemID: Int) -> String? {
        return services.contentService.contentItem(id: contentItemID)?.valueText
    }

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

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(index: Int) {
        headerToggleState[index] = !headerToggleState[index]
    }

    func isCellExpanded(at: Int) -> Bool {
        return headerToggleState[at]
    }

    func hasContent(noteType: PrepareContentReviewNotesTableViewCell.ReviewNotesType) -> Bool {
        let content: [String]
        switch noteType {
        case .intentions: content = [notesDictionary[103432] ?? "",
                                     notesDictionary[103433] ?? "",
                                     notesDictionary[103434] ?? ""]
        case .reflection: content = [notesDictionary[103435] ?? "",
                                     notesDictionary[103436] ?? ""]
        }
        return content.joined().isEmpty == false
    }

    func relatedStrategies(for contentCollectionTitle: String) -> [ContentCollection] {
        return services.contentService.relatedPrepareStrategies(contentCollectionTitle)
    }
}

// MARK: - Private

private extension PrepareContentViewModel {

    func setSubtitle() {
        subTitle = String(format: "%02d/%02d ",
                          checkedCount,
                          items.dropFirst(4).count - 1) + R.string.localized.prepareContentTasks()
        items.remove(at: 0)
        items.insert(.titleItem(title: title,
                                subTitle: subTitle,
                                contentText: contentText,
                                placeholderURL: videoPlaceholder,
                                videoURL: video), at: 0)
    }

    func dateForID(_ id: Int) -> Date? {
        guard let date: Date? = checkedIDs[id] else {
            return nil
        }
        return date
    }

    func fillHeaderStatus() {
        for _ in 0...items.count {
            headerToggleState.append(itemCount == 2)
        }
    }

    func makeItems(_ items: [PrepareItem]) {
        self.items.append(.titleItem(title: title,
                                     subTitle: subTitle,
                                     contentText: contentText,
                                     placeholderURL: videoPlaceholder,
                                     videoURL: video))

        if displayMode == .checkbox {
            if hasIntentionItems == true || hasRefelctionItems == true {
                self.items.append(.reviewNotesHeader(title: "BEFORE AND AFTER"))
            }

            if hasIntentionItems == true {
                self.items.append(.reviewNotesItem(title: "YOUR INTENTIONS", reviewNotesType: .intentions))
            }

            if hasRefelctionItems == true {
                self.items.append(.reviewNotesItem(title: "REFLECT ON SUCCESS", reviewNotesType: .reflection))
            }
        }

        if items.isEmpty == false {
            self.items.append(.checkItemsHeader(title: "MY EVENT CHECKLIST"))
        }

        for element in items {
            self.items.append(.item(id: element.id,
                                    title: element.title,
                                    subTitle: element.subTitle,
                                    readMoreID: element.readMoreID))
        }

        if displayMode == .normal {
            self.items.append(.tableFooter(preparationID: 1)) //TODO: we need to set the actual ID
        }

        fillHeaderStatus()
    }
}

extension PrepareContentViewModel: PrepareContentNotesViewControllerDelegate {

    func didEditText(text: String?, in viewController: PrepareContentNotesViewController) {
        guard let notesType = viewController.notesType else { return }
        let text = text ?? ""
        switch notesType {
        case .notes: notes = text
        case .intentionPerceiving: notesDictionary[notesType.contentItemID] = text
        case .intentionKnowing: notesDictionary[notesType.contentItemID] = text
        case .intentionFeeling: notesDictionary[notesType.contentItemID] = text
        case .reflectionNotes: notesDictionary[notesType.contentItemID] = text
        case .reflectionVision: notesDictionary[notesType.contentItemID] = text
        }
    }
}
