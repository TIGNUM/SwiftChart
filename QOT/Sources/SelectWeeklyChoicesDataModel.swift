//
//  SelectWeeklyChoicesDataModel.swift
//  QOT
//
//  Created by Lee Arromba on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class SelectWeeklyChoicesDataModel {

    enum SelectionType {
        case weeklyChoices
        case prepareStrategies
    }

    // MARK: - Properties

    private var services: Services
    private let rawData: AnyRealmCollection<ContentCategory>
    private let strategies = [String: [ContentCollection]]()
    private var dataSource = [CollapsableNode]()
    let selectionType: SelectionType
    let maxSelectionCount: Int

    var numberOfSections: Int {
        return dataSource.count
    }

    var numOfItemsSelected: Int {
        return selected.count
    }

    var selected: [WeeklyChoice] {
        return dataSource.flatMap { (node: CollapsableNode) -> [WeeklyChoice] in
            return node.children.compactMap { (choice: WeeklyChoice) -> WeeklyChoice? in
                if choice.selected == true {
                    return choice
                }
                return nil
            }
        }
    }

    // MARK: - Init

    init(services: Services, maxSelectionCount: Int, startDate: Date, endDate: Date) {
        self.services = services
        self.maxSelectionCount = maxSelectionCount
        self.selectionType = SelectionType.weeklyChoices
        self.rawData = services.contentService.learnContentCategories()
        self.dataSource = createDataSource(from: rawData, startDate: startDate, endDate: endDate)
    }

    init(services: Services, relatedContent: [ContentCollection], selectedIDs: [Int]) {
        self.services = services
        self.maxSelectionCount = 0
        self.selectionType = SelectionType.prepareStrategies
        self.rawData = services.contentService.learnContentCategories()
        self.dataSource = createDataSource(from: relatedContent, selectedIDs: selectedIDs)
    }
}

// MARK: - Helpers

extension SelectWeeklyChoicesDataModel {

    func numberOfRows(inSection section: Int) -> Int {
        return 1 + dataSource[section].numberOfRows // 1 needed for node row
    }

    func rowHeight(forIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64.0
        }
        return 40.0
    }

    func isParentNode(atIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.row == 0 // first row in section is always a node
    }

    func setIsOpen(_ isOpen: Bool, forNodeAtSection section: Int) {
        var node = dataSource[section]
        node.isOpen = isOpen
        dataSource[section] = node
    }

    func node(forSection section: Int) -> CollapsableNode {
        return dataSource[section]
    }

    func item(forIndexPath indexPath: IndexPath) -> WeeklyChoice {
        let node = dataSource[indexPath.section]
        let item = node.children[indexPath.row - 1] // 1 needed for node row, so offset
        return item
    }

    func replace(_ item: WeeklyChoice, atIndexPath indexPath: IndexPath) {
        var node = dataSource[indexPath.section]
        node.replace(item, atRow: indexPath.row - 1) // 1 needed for node row, so offset
        dataSource[indexPath.section] = node
    }

    func createUsersWeeklyChoices() {
        selected.forEach { [unowned self] (choice: WeeklyChoice) in
            _ = try? self.services.userService.createUserChoice(
                contentCategoryID: choice.categoryID,
                contentCollectionID: choice.contentCollectionID,
                startDate: choice.startDate,
                endDate: choice.endDate
            )
        }
    }

    func contentCollection(forIndexPath indexPath: IndexPath) -> ContentCollection? {
        let item = self.item(forIndexPath: indexPath)
        return services.contentService.contentCollection(id: item.contentCollectionID)
    }

    func contentCategory(forIndexPath indexPath: IndexPath) -> ContentCategory? {
        let item = self.item(forIndexPath: indexPath)
        return services.contentService.contentCategory(id: item.categoryID)
    }
}

// MARK: - Private

private extension SelectWeeklyChoicesDataModel {

    func createDataSource(from relatedContent: [ContentCollection], selectedIDs: [Int]) -> [CollapsableNode] {
        var nodes = [CollapsableNode]()
        let categories = (relatedContent.compactMap { $0.contentCategories.first }).unique
        categories.forEach { (category) in
            let children: [WeeklyChoice] = relatedContent.filter { $0.contentCategories.first == category }
                .map { (contentCollection: ContentCollection) -> WeeklyChoice in
                    return WeeklyChoice(
                        localID: UUID().uuidString,
                        contentCollectionID: contentCollection.forcedRemoteID,
                        categoryID: category.forcedRemoteID,
                        categoryName: category.title,
                        title: contentCollection.title,
                        covered: nil,
                        startDate: Date(),
                        endDate: Date(),
                        selected: selectedIDs.contains(contentCollection.remoteID.value ?? 0)
                    )
            }
            let node = CollapsableNode(title: category.title, children: children, isOpen: false)
            nodes.append(node)
        }
        return nodes
    }

    func createDataSource(from contentCategories: AnyRealmCollection<ContentCategory>, startDate: Date, endDate: Date) -> [CollapsableNode] {
        return rawData.map { (contentCategory: ContentCategory) -> CollapsableNode in
            let children: [WeeklyChoice] = contentCategory.contentCollections.filter {
                $0.section == Database.Section.learnStrategy.rawValue
                }.map { (contentCollection: ContentCollection) -> WeeklyChoice in
                    return WeeklyChoice(
                        localID: UUID().uuidString,
                        contentCollectionID: contentCollection.forcedRemoteID,
                        categoryID: contentCategory.forcedRemoteID,
                        categoryName: nil,
                        title: contentCollection.title,
                        covered: nil,
                        startDate: startDate,
                        endDate: endDate,
                        selected: false
                    )
            }
            return CollapsableNode(title: contentCategory.title, children: children, isOpen: false)
        }
    }
}
