//
//  OrientationManager.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 13/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class OrientationManager {
    // MARK: - Private Storage

    var supportedOrientations: UIInterfaceOrientationMask = .portrait

    // MARK: - Public

    func regular() {
        supportedOrientations = .portrait
    }

    func videos() {
        supportedOrientations = .all
    }
}
