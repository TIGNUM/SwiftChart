//
//  Coordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

/// A `Coordinator` is responsible for the setting up and flow between 
/// `UIViewController`s.
@objc protocol Coordinator: class {
    /// Starts the coordination process.
    func start()
}

/// A `Coordinator` with child `Coordinators`.
protocol ParentCoordinator: Coordinator {
    /// The children of `self`.
    var children: [Coordinator] { get set }

    func removeChild(child: Coordinator)

    func removeAllChildren()
}

extension ParentCoordinator {

    func removeChild(child: Coordinator) {
        children = children.filter({ ($0 !== child) })
    }

    func startChild(child: Coordinator) {
        children.append(child)
        child.start()
    }

    func removeAllChildren() {
        children.removeAll()
    }
}
