//
//  ChatViewCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class ChatViewCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let rootViewController: ChatViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    
    var children: [Coordinator] = []
    
    // MARK: - Life Cycle
    
    init(root: ChatViewController, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        // TODO
    }
}
