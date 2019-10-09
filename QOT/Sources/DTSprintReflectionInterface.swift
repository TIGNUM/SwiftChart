//
//  DTSprintReflectionInterface.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DTSprintReflectionViewControllerInterface: class {}

protocol DTSprintReflectionPresenterInterface {}

protocol DTSprintReflectionInteractorInterface: Interactor {
    func updateSprint()
}

protocol DTSprintReflectionRouterInterface {
    func presentTrackTBV()
}
