//
//  MyUniverseCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyUniverseCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let rootViewController: MyUniverseViewController
    fileprivate let services: Services
    
    var children: [Coordinator] = []
    
    // MARK: - Life Cycle
    
    init(root: MyUniverseViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }
    
    func start() {

    }
}
