//
//  MyToBeVisionCountDownViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyToBeVisionCountDownViewControllerProtocol: class {
    func shouldSkip()
    func shouldDismiss()
}

final class MyToBeVisionCountDownViewController: UIViewController {

    @IBOutlet weak var skipSwitch: UISwitch!
    @IBOutlet weak var topCounterLabel: UILabel!

    var interactor: MyToBeVisionCountDownInteractorInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbon
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimer()
    }
}

extension MyToBeVisionCountDownViewController: MyToBeVisionCountDownViewControllerInterface {

    func setupView(with timerValue: String) {
        topCounterLabel.text = timerValue
        setupSkipSwitch()
        startTimer()
    }

    func updateText(with value: String) {
        if interactor?.currentTimerValue == interactor?.endTimerValue {
            invalidateTimer()
            interactor?.shouldSkip()
        }
        topCounterLabel.text = value
        startAnimating()
    }
}

private extension MyToBeVisionCountDownViewController {

    @IBAction func skipAction(_ sender: Any) {
        interactor?.shouldSkip()
    }

    @IBAction func dismissAction(_ sender: Any) {
        interactor?.shouldDismiss()
    }

    func startTimer() {
        interactor?.startTimer()
    }

    @objc func valueChanged(sender: UISwitch) {
        trackUserEvent(.SELECT, value: sender.isOn ? 1 : 0, valueType: "DontShowCountDownViewAgain", action: .TAP)
        UserDefaults.standard.set(sender.isOn, forKey: UserDefault.skipTBVCounter.rawValue)
    }

    func invalidateTimer() {
        interactor?.invalidateTimer()
    }

    func startAnimating() {
        UIView.animate(withDuration: Animation.duration_01,
                       delay: 0,
                       options: [],
                       animations: {
                        self.topCounterLabel.alpha = 0.0

        },
                       completion: { [weak self] _ in
                        self?.topCounterLabel.text = self?.interactor?.currentTimerValue
        })

        UIView.animate(withDuration: Animation.duration_01,
                       delay: 0,
                       options: [],
                       animations: {
                        self.topCounterLabel.alpha = 1

        }, completion: nil)
    }

    func setupSkipSwitch() {
        skipSwitch.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        skipSwitch.tintColor = .white40
        skipSwitch.onTintColor = .clear
        skipSwitch.layer.borderWidth = 1
        skipSwitch.layer.borderColor = UIColor.white40.cgColor
        skipSwitch.layer.cornerRadius = 16
    }
}
