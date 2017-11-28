//
//  SelectWeeklyChoicesDataModel.swift
//  QOT
//
//  Created by Lee Arromba on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

class SelectWeeklyChoicesDataModel {

    private var services: Services
    private let rawData: AnyRealmCollection<ContentCategory>
    private(set) var dataSource: [CollapsableNode]
    
    var selected: [WeeklyChoice] {
        return dataSource.flatMap({ (node: CollapsableNode) -> [WeeklyChoice] in
            return node.children.flatMap({ (choice: WeeklyChoice) -> WeeklyChoice? in
                if choice.selected {
                    return choice
                }
                return nil
            })
        })
    }
    var numberOfSections: Int {
        return dataSource.count
    }
    var numOfItemsSelected: Int {
        return selected.count
    }
    let maxSelectionCount: Int
    
    init(services: Services, maxSelectionCount: Int, startDate: Date, endDate: Date) {
        self.services = services
        self.maxSelectionCount = maxSelectionCount
        self.rawData = services.contentService.learnContentCategories()
        
        dataSource = rawData.map({ (contentCategory: ContentCategory) -> CollapsableNode in
            let children: [WeeklyChoice] = contentCategory.contentCollections.filter({
                $0.section == Database.Section.learnStrategy.rawValue
            }).map({ (contentCollection: ContentCollection) -> WeeklyChoice in
                return WeeklyChoice(
                    localID: UUID().uuidString,
                    contentCollectionID: contentCollection.forcedRemoteID,
                    categoryID: contentCategory.forcedRemoteID,
                    categoryName: nil,
                    title: contentCollection.title,
                    startDate: startDate,
                    endDate: endDate,
                    selected: false
                )
            })
            return CollapsableNode(title: contentCategory.title, children: children, isOpen: false)
        })
    }

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
        selected.forEach({ [unowned self] (choice: WeeklyChoice) in
            _ = try? self.services.userService.createUserChoice(
                contentCategoryID: choice.categoryID,
                contentCollectionID: choice.contentCollectionID,
                startDate: choice.startDate,
                endDate: choice.endDate
            )
        })
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
