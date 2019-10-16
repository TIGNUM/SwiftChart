//
//  OnboardingLoginPresenter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLoginPresenter {

    // Structure that encapsulates the minimum time that activity indicator should be displayed
    private class GracePeriod {
        private static let period: Double = 0.3
        private static let billion: Double = 1000000000

        static var nanoSeconds: UInt64 = {
            return UInt64(period * billion)
        }()

        static func delayFromDifference(_ time: UInt64) -> Double {
            return period - Double(time) / billion
        }
    }

    private var lastActivityChange: DispatchTime = DispatchTime.now()

    // MARK: - Properties
    private weak var viewController: OnboardingLoginViewControllerInterface?

    // MARK: - Init
    init(viewController: OnboardingLoginViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - OnoardingLoginInterface
extension OnboardingLoginPresenter: OnboardingLoginPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present() {
        viewController?.updateView()
    }

    func presentActivity(state: ActivityState?) {
        let difference = DispatchTime.now().uptimeNanoseconds - lastActivityChange.uptimeNanoseconds
        // If indicator has been displayed for longer than the minimum required time
        if state != nil || difference > GracePeriod.nanoSeconds {
            viewController?.presentActivity(state: state)
        } else {
            // Show it for the remainder of duration
            DispatchQueue.main.asyncAfter(deadline: .now() + GracePeriod.delayFromDifference(difference)) { [weak self] in
                self?.viewController?.presentActivity(state: state)
            }
        }
        lastActivityChange = DispatchTime.now()
    }

    func presentCodeEntry() {
        viewController?.beginCodeEntry()
    }
}
