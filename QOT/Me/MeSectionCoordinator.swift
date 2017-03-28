//
//  MeSectionCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol MeSectionDelegate: class {
    
    func didTapMeSectionItem(in viewController: MeSectionViewController)
}

final class MeSectionCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let rootViewController: MeSectionViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    
    var children: [Coordinator] = []
    
    // MARK: - Life Cycle
    
    init(root: MeSectionViewController, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        // TODO
    }
}
