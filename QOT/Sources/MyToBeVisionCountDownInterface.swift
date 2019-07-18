//
//  MyToBeVisionCountDownInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol  MyToBeVisionCountDownViewControllerInterface: class {
    func setupView(with timerValue: String)
    func updateText(with value: String)
}

protocol MyToBeVisionCountDownPresenterInterface {
    func setupView(with timerValue: String)
    func updateText(with value: String)
}

protocol MyToBeVisionCountDownInteractorInterface: Interactor {
    var currentTimerValue: String { get }
    var endTimerValue: String { get }
    func shouldSkip()
    func shouldDismiss()
    func startTimer()
    func invalidateTimer()
}

protocol  MyToBeVisionCountDownRouterInterface {
}
