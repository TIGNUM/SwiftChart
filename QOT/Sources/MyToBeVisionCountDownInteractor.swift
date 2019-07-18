//
//  MyToBeVisionCountDownInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionCountDownInteractor {
    let presenter: MyToBeVisionCountDownPresenterInterface
    let worker: MyToBeVisionCountDownWorker
    let router: MyToBeVisionCountDownRouter

    var timer = Timer()
    private var timerValue: Int = 3

    init(presenter: MyToBeVisionCountDownPresenterInterface,
         worker: MyToBeVisionCountDownWorker,
         router: MyToBeVisionCountDownRouter) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
}

extension MyToBeVisionCountDownInteractor: MyToBeVisionCountDownInteractorInterface {

    func viewDidLoad() {
        presenter.setupView(with: String(timerValue))
    }

    func shouldSkip() {
        worker.shouldSkip()
    }

    func shouldDismiss() {
        worker.shouldDismiss()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerValue), userInfo: nil, repeats: true)
    }

    @objc private func updateTimerValue() {
        timerValue -= 1
        let value = String(timerValue)
        presenter.updateText(with: value)
    }

    func invalidateTimer() {
        timer.invalidate()
    }

    var endTimerValue: String {
        return "0"
    }

    var currentTimerValue: String {
        return String(timerValue)
    }
}
