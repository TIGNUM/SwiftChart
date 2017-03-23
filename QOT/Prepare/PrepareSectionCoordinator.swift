//
//  PrepareSectionCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol PrepareChatBotDelegate: class {
    func didFinishDisplayInstructions(in viewController: PrepareSectionViewController, chatMessageType: ChatMessageType)
    func didSelectPreparation(in viewController: PrepareSectionViewController, chatMessageType: ChatMessageType)
}

final class PrepareSectionCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let rootViewController: PrepareSectionViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    
    var children: [Coordinator] = []
    
    // MARK: - Life Cycle
    
    init(root: PrepareSectionViewController, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        // TODO
    }
}
