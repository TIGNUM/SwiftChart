//
//  PresentationManager.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum PresentationType {
    case fade
}

class PresentationManager: NSObject {

    var presentationType = PresentationType.fade
}

extension PresentationManager: UIViewControllerTransitioningDelegate {

}
