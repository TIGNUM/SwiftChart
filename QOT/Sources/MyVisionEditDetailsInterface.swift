//
//  MyVisionEditDetailsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyVisionEditDetailsControllerInterface: class {
    func setupView(title: String, vision: String)
}

protocol MyVisionEditDetailsPresenterInterface {
    func setupView(title: String, vision: String)
}

protocol MyVisionEditDetailsInteractorInterface: Interactor {
    var firstTimeUser: Bool { get }
    var myVision: QDMToBeVision? { get }
    var originalTitle: String { get }
    var originalVision: String { get }
    var isFromNullState: Bool { get }
    var visionPlaceholderDescription: String? { get }
    var visionPlaceholderTitle: String? { get }
    func updateMyToBeVision(_ toBeVision: QDMToBeVision, _ completion: @escaping (Error?) -> Void)
    func formatPlaceholder(title: String) -> NSAttributedString?
    func format(title: String) -> NSAttributedString?
    func formatPlaceholder(vision: String) -> NSAttributedString?
    func format(vision: String) -> NSAttributedString?
}
