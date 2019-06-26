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

// MARK: - Getter &&& Setter

extension ChoiceWorker {

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
        return (indexPath.row == 0) ? 64.0 : 40.0
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
    func generateDataSource(_ selectedIds: [Int],
                            _ relatedId: Int,
                            _ completion: @escaping (([CollapsableNode]) -> Void)) {
        var nodes = [CollapsableNode]()
        getRelatedContents(relatedId) { [weak self] (relatedContents) in
            self?._maxSelectionCount = relatedContents?.count ?? 0
            let categoryIds = relatedContents?.flatMap { $0.categoryIDs } ?? []
            qot_dal.ContentService.main.getContentCategoriesByIds(categoryIds) { (categories) in
                categories?.forEach { (category) in
                    let children: [Choice] = (relatedContents ?? []).filter { $0.categoryIDs.first == category.remoteID }
                        .map { (content: QDMContentCollection) -> Choice in
                    return Choice(categoryName: category.title,
                                  contentId: content.remoteID ?? 0,
                                  title: content.title,
                                  readingTime: content.durationString,
                                  isDefault: false,
                                  isSuggested: false,
                                  selected: selectedIds.contains(content.remoteID ?? 0))
                    }
                    let node = CollapsableNode(title: category.title, children: children, isOpen: false)
                    nodes.append(node)
                }
                completion(nodes)
            }
        }
    }

    func getRelatedContents(_ relatedId: Int, completion: @escaping (([QDMContentCollection]?) -> Void)) {
        qot_dal.ContentService.main.getContentCollectionById(relatedId) { (content) in
            let relatedIds = content?.relatedContentIDsPrepareAll ?? []
            qot_dal.ContentService.main.getContentCollectionsByIds(relatedIds, completion)
        }
    }
}
