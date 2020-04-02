//
//  ChoiceWorker.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ChoiceWorker {

    enum ChoiceType: String {
        case CHOICE
        case UNKOWN
    }

    // MARK: - Properties
    private var dataSource = [CollapsableNode]()
    private var _maxSelectionCount: Int = 0
    let selectedIds: [Int]
    let relatedId: Int
    let choiceType: ChoiceType

    // MARK: - Init
    init(selectedIds: [Int], relatedId: Int) {
        self.selectedIds = selectedIds
        self.relatedId = relatedId
        self.choiceType = .CHOICE
    }
}

extension ChoiceWorker {
    var maxSelectionCount: Int {
        return _maxSelectionCount
    }

    var sectionCount: Int {
        return dataSource.count
    }

    var selectedCount: Int {
        return selected.count
    }

    func selectedCount(in section: Int) -> Int {
        return node(in: section).children.filter { $0.selected == true }.count
    }

    func numberOfItems(in section: Int) -> Int {
        return node(in: section).children.count
    }

    var selected: [Choice] {
        return dataSource.flatMap { (node: CollapsableNode) -> [Choice] in
            return node.children.compactMap { (choice: Choice) -> Choice? in
                return choice.selected == true ? choice : nil
            }
        }
    }
}

// MARK: - Helpers
extension ChoiceWorker {
    func generateItems(_ completion: @escaping (() -> Void)) {
        generateDataSource(selectedIds, relatedId) { [weak self] (nodes) in
            self?.dataSource = nodes
            completion()
        }
    }

    func numberOfRows(in section: Int) -> Int {
        return 1 + dataSource[section].numberOfRows // 1 needed for node row
    }

    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? .ParentNode : .Default
    }

    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 // first row in section is always a node
    }

    func setIsOpen(_ isOpen: Bool, in section: Int) {
        var node = dataSource[section]
        node.isOpen = isOpen
        dataSource[section] = node
    }

    func node(in section: Int) -> CollapsableNode {
        return dataSource[section]
    }

    func item(at indexPath: IndexPath) -> Choice {
        let node = dataSource[indexPath.section]
        let item = node.children[indexPath.row - 1] // 1 needed for node row, so offset
        return item
    }

    func replace(_ item: Choice?, at indexPath: IndexPath) {
        guard let item = item else { return }
        var node = dataSource[indexPath.section]
        node.replace(item, atRow: indexPath.row - 1) // 1 needed for node row, so offset
        dataSource[indexPath.section] = node
    }
}

// MARK: - Private
private extension ChoiceWorker {
    func getChildren(category: QDMContentCategory,
                     relatedContents: [QDMContentCollection]?,
                     relatedContentItems: [QDMContentItem]?,
                     relatedContentItemsCollection: [QDMContentCollection]?) -> [Choice] {

        let childrenContent: [Choice] = (relatedContents ?? [])
            .filter { $0.categoryIDs.first == category.remoteID }
            .map { (content: QDMContentCollection) -> Choice in
                return Choice(categoryName: category.title,
                              contentId: content.remoteID ?? 0,
                              contentItemId: 0,
                              title: content.title,
                              readingTime: content.durationString,
                              isDefault: false,
                              isSuggested: false,
                              selected: selectedIds.contains(content.remoteID ?? 0))
        }

        let relatedContentItemIds = relatedContentItems?.compactMap { $0.remoteID } ?? []
        let childrenContentItems = (relatedContentItemsCollection ?? []).filter { $0.categoryIDs.first == category.remoteID }
            .flatMap { $0.contentItems }
            .filter { relatedContentItemIds.contains($0.remoteID ?? 0) }
            .map { (contentItem: QDMContentItem) -> Choice in
                return Choice(categoryName: category.title,
                              contentId: 0,
                              contentItemId: contentItem.remoteID ?? 0,
                              title: contentItem.valueText,
                              readingTime: contentItem.durationString,
                              isDefault: false,
                              isSuggested: false,
                              selected: selectedIds.contains(contentItem.remoteID ?? 0))
        }

        return childrenContent + childrenContentItems
    }

    func generateDataSource(_ selectedIds: [Int],
                            _ relatedId: Int,
                            _ completion: @escaping ([CollapsableNode]) -> Void) {
        let worker = WorkerContent()
        var nodes = [CollapsableNode]()

        worker.getRelatedContents(relatedId) { [weak self] (relatedContents) in
            worker.getRelatedContentItems(relatedId) { [weak self] (relatedContentItems, itemCollections) in
                guard let strongSelf = self else {
                    completion([])
                    return
                }

                strongSelf._maxSelectionCount = (relatedContents?.count ?? 0) + (relatedContentItems?.count ?? 0)
                worker.getCategories(relatedContents, relatedContentItems) { (categories) in
                    categories?.forEach { (category) in
                        let children = strongSelf.getChildren(category: category,
                                                   relatedContents: relatedContents,
                                                   relatedContentItems: relatedContentItems,
                                                   relatedContentItemsCollection: itemCollections)
                        let node = CollapsableNode(title: category.title, children: children, isOpen: false)
                        nodes.append(node)
                    }
                    completion(nodes)

                }
            }
        }
    }
}
