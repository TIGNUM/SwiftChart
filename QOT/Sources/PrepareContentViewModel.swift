//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

public enum PreparationContentType {
    case prepContentEvent
    case prepContentProblem
}

enum PrepareContentItemType {
    case titleItem(title: String, subTitle: String, contentText: String, placeholderURL: URL?, videoURL: URL?)
    case checkItemsHeader(title: String)
    case item(id: Int, title: String, subTitle: String, readMoreID: Int?)
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

    enum Section: Int {
        case top = 0
        case bottom = 1

        static var allValues: [Section] {
            return [.top, .bottom]
        }
    }

    // MARK: - Properties

    private var headerToggleState: [Int: [Bool]] = [:]
    var displayMode: DisplayMode
    var checkedIDs: [Int: Date?]
    var title: String = ""
    var subTitle: String = ""
    var contentText: String = ""
    var videoPlaceholder: URL?
    var video: URL?
    var items: [Section: [PrepareContentItemType]] = [:]
    var preparationID: String?
    var notes: String = ""
    var notesDictionary: [Int: String] = [:]
    var relatedPrepareStrategies = [ContentCollection]()
    let preparationType: PreparationContentType
    private let prepareItems: [PrepareItem]
    private let services: Services

    var checkedCount: Int {
        return checkedIDs.reduce(0) { (result: Int, check: (key: Int, value: Date?)) -> Int in
            return (check.value == nil) ? result : result + 1
        }
    }

    // MARK: - Initialisation

    init(type: PreparationContentType,
         title: String,
         subtitle: String,
         video: Video?,
         description: String,
         items: [PrepareItem],
         services: Services) {
        self.preparationType = type
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

    init(type: PreparationContentType,
         title: String,
         video: Video?,
         description: String,
         items: [PrepareItem],
         checkedIDs: [Int: Date?],
         preparationID: String,
         contentCollectionTitle: String,
         notes: String,
         notesDictionary: [Int: String],
         services: Services) {
        self.preparationType = type
        self.prepareItems = items
        self.title = title
        self.video = video?.url
        self.subTitle = R.string.localized.prepareSubtitleLearnMore()
        self.videoPlaceholder = video?.placeholderURL
        self.contentText = description
        self.checkedIDs = checkedIDs
        self.displayMode = .checkbox
        self.preparationID = preparationID
        self.notes = notes
        self.notesDictionary = notesDictionary
        self.services = services
        makeItems(items)
    }
}

// MARK: - Public

extension PrepareContentViewModel {

    var headerID: Int {
        return services.contentService.contentCollection(contentTitle: title)?.remoteID.value ?? 0
    }

    var completedTasksValue: String {
        guard
            let preparationID = preparationID,
            let preparation = services.preparationService.preparation(localID: preparationID) else { return subTitle }
        let taskValue = String(format: "%02d/%02d ", checkedCount, preparation.checkableItems.count)
        subTitle = String(format: "%@ %@", taskValue, R.string.localized.prepareContentCompleted())
        return subTitle
    }

    var eventName: String {
        guard
            let preparationID = preparationID,
            let preparation = services.preparationService.preparation(localID: preparationID) else { return "" }
        return preparation.name
    }

    var eventDate: String {
        guard
            let preparationID = preparationID,
            let preparation = services.preparationService.preparation(localID: preparationID) else { return "" }
        return preparation.eventStartDate?.eventStringDate ?? ""
    }

    var selectedIDs: [Int] {
        return prepareItems.compactMap { $0.readMoreID }
    }

    var sectionCount: Int {
        return Section.allValues.count
    }

    func numberOfRows(in sectionIdx: Int) -> Int {
        guard let section = Section(rawValue: sectionIdx) else { return 0 }
        return items[section]?.count ?? 0
    }

    var hasIntentionItems: Bool {
        let results = (prepareItems.map { $0.title }).filter {
            $0.contains("SET INTENTIONS")
        }
        return results.isEmpty == false
    }

    var hasRefelctionItems: Bool {
        let results = (prepareItems.map { $0.title }).filter { $0.contains("REFLECT ON SUCCESS") }
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
        guard displayMode == .checkbox else { return }
        if dateForID(id) == nil {
            checkedIDs.updateValue(Date(), forKey: id)
        } else {
            checkedIDs.updateValue(nil, forKey: id)
        }
    }

    func item(at indexPath: IndexPath) -> PrepareContentItemType? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        return items[section]?[indexPath.item]
    }

    func didTapHeader(indexPath: IndexPath) {
        let currentState = headerToggleState[indexPath.section]?[indexPath.row] ?? false
        headerToggleState[indexPath.section]?[indexPath.row] = !currentState
    }

    func isCellExpanded(at indexPath: IndexPath) -> Bool {
        if numberOfRows(in: 1) == 0 && indexPath.row == 0 {
            headerToggleState[indexPath.section]?[indexPath.row] = true
        }
        return headerToggleState[indexPath.section]?[indexPath.row] ?? false
    }

    func relatedStrategies(for contentCollectionTitle: String) -> [ContentCollection] {
        return services.contentService.relatedPrepareStrategies(contentCollectionTitle)
    }

    func updatePreparation() {
        guard let preparationID = preparationID else { return }
        do {
            try services.preparationService.updatePreparation(localID: preparationID,
                                                              checks: checkedIDs,
                                                              notes: notes,
                                                              notesDictionary: notesDictionary)
        } catch {
            log(error.localizedDescription, level: .error)
        }
    }
}

// MARK: - Private

private extension PrepareContentViewModel {

    func dateForID(_ id: Int) -> Date? {
        return checkedIDs[id] as? Date
    }

    func fillHeaderStatus() {
        for section in 0...sectionCount {
            for _ in 0...numberOfRows(in: section) {
                if headerToggleState[section] == nil {
                    headerToggleState[section] = [Bool]()
                }
                headerToggleState[section]?.append(numberOfRows(in: 1) == 0)
            }
        }
    }

    func makeCheckBoxItems(_ items: [PrepareItem]) {
        if self.items[.top] == nil {
            self.items[.top] = [PrepareContentItemType]()
        }
        if self.items[.bottom] == nil {
            self.items[.bottom] = [PrepareContentItemType]()
        }
        self.items[.top]?.append(.titleItem(title: title,
                                            subTitle: subTitle,
                                            contentText: contentText,
                                            placeholderURL: videoPlaceholder,
                                            videoURL: video))
        if items.isEmpty == false {
            self.items[.bottom]?.append(.checkItemsHeader(title: R.string.localized.prepareHeaderPreparationList()))
        }
        for item in items {
            self.items[.bottom]?.append(.item(id: item.id,
                                              title: item.title,
                                              subTitle: item.subTitle,
                                              readMoreID: item.readMoreID))
        }
    }

    // Don`t like that function name...
    func makeNormalItems(_ items: [PrepareItem]) {
        if self.items[.top] == nil {
            self.items[.top] = [PrepareContentItemType]()
        }
        self.items[.top]?.append(.titleItem(title: title,
                                            subTitle: subTitle,
                                            contentText: contentText,
                                            placeholderURL: videoPlaceholder,
                                            videoURL: video))
    }

    func makeItems(_ items: [PrepareItem]) {
        switch displayMode {
        case .checkbox: makeCheckBoxItems(items)
        case .normal: makeNormalItems(items)
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
        if let localID = preparationID {
            try? services.preparationService.updatePreparation(localID: localID,
                                                               checks: checkedIDs,
                                                               notes: notes, notesDictionary: notesDictionary)
        }
    }
}
