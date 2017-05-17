//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class PrepareContentViewModel {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    fileprivate var headerStatus: [String: Bool] = [:]
    fileprivate var items: [PrepareContentItemType] = []
    fileprivate let contentItems: DataProvider<PrepareContentItem>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    // MARK: - Init

    init(collection: PrepareContentCollection) {
        self.contentItems = collection.prepareItems

        contentItems.observeChange { [unowned self] (_) in
            self.fillHeaderStatus()
            self.makeItems()
        }.dispose(in: disposeBag)
    }

    // MARK: - Public

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(item: PrepareContentItemType) {
        switch item {
        case .header(_, let title, let open):
            headerStatus[title] = !open
            makeItems()
            updates.next(.reload)
        default:
            preconditionFailure("item is not a header: \(item)")
        }
    }
}

// MARK: - Private

private enum IntermediateSection {
    case ungrouped(PrepareContentItem)
    case grouped(title: String, items: [PrepareContentItem])
}

private extension PrepareContentViewModel {

    func fillHeaderStatus() {
        for contentItem in contentItems.items {
            if let title = contentItem.accordionTitle(), headerStatus[title] == nil {
                headerStatus[title] = false
            }
        }
    }

    private func groupedItems(title: String, groupItems: [PrepareContentItem]) -> [PrepareContentItemType] {
        var groupedItems: [PrepareContentItemType] = []
        let open = headerStatus[title]!
        groupedItems.append(PrepareContentItemType.header(sectionID: "", title: title, open: open))

        if open {
            for groupItem in groupItems {
                if let prepareContentItemType = PrepareContentItemType(contentItemValue: groupItem.contentItemValue) {
                    groupedItems.append(prepareContentItemType)
                }

            }
            groupedItems.append(.sectionFooter(sectionID: ""))
        }

        return groupedItems
    }

    func makeItems() {
        let sections = intermediateSections()
        var items: [PrepareContentItemType] = []

        for section in sections {
            switch section {
            case .ungrouped(let item):
                if let prepareContentItemType = PrepareContentItemType(contentItemValue: item.contentItemValue) {
                    items.append(prepareContentItemType)
                }
            case .grouped(let title, let groupItems): items.append(contentsOf: groupedItems(title: title, groupItems: groupItems))
            }
        }

        items.append(.tableFooter)
        self.items = items
    }

    func intermediateSections() -> [IntermediateSection] {
        var currentGroup: (title: String, items: [PrepareContentItem])? = nil
        var sections: [IntermediateSection] = []

        for contentItem in contentItems.items {
            if let headerTitle = contentItem.accordionTitle() {
                if let group = currentGroup {
                    if headerTitle == group.title {
                        var items = group.items
                        items.append(contentItem)

                        currentGroup = (title: headerTitle, items: items)
                    } else {
                        if let currentGroup = currentGroup {
                            sections.append(.grouped(title: currentGroup.title, items: currentGroup.items))
                        }
                        currentGroup = (title: headerTitle, items: [contentItem])
                    }
                } else {
                    currentGroup = (title: headerTitle, items: [contentItem])
                }
            } else {
                if let currentGroup = currentGroup {
                    sections.append(.grouped(title: currentGroup.title, items: currentGroup.items))
                }
                currentGroup = nil
                sections.append(.ungrouped(contentItem))
            }
        }
        return sections
    }
}

enum PrepareContentItemType {
    case title(localID: String, text: String)
    case text(localID: String, text: String)
    case video(localID: String, placeholderURL: URL)
    case step(localID: String, index: Int, text: String)
    case header(sectionID: String, title: String, open: Bool)
    case sectionFooter(sectionID: String)
    case tableFooter

    init?(contentItemValue: ContentItemValue) {
        switch contentItemValue {
        case .text(let text):
            self = .text(localID: "", text: text)
        default:
            return nil
        }
    }
}
