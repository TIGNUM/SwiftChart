//
//  TrackablePage.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol TrackablePage: class {
    var pageName: String { get }
    var object: SyncableObject? { get }
}

extension AnimatedLaunchScreenViewController: TrackablePage {
    var pageName: String {
        return ""
    }
    var object: SyncableObject? {
        return nil
    }
}
