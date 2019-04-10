//
//  AbstractLevelTwoViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractLevelTwoViewController: UIViewController {

    weak var delegate: CoachPageViewControllerDelegate?

    func setupNavigationButtons() {
        setupCoachButton()
        setupLevelNavigationuttonKnowing()
        setupLevelNavigationuttonDailyBried()
        setupLevelNavigationuttonMyQot()
    }
}

// MARK: - Actions

extension AbstractLevelTwoViewController {
    @objc func didTabCoachButton() {
        delegate?.presentCoach(from: self)
    }

    @objc func didTabLevelOneKnowingButton() {
        delegate?.navigateToKnowingViewController()
        dismiss(animated: true)
    }

    @objc func didTabbLevelOneDailyriefButton() {
        delegate?.navigateToDailyBriefViewController()
        dismiss(animated: true)
    }

    @objc func didTabLevelOneMyQotutton() {
        delegate?.navigateToMyQotViewController()
        dismiss(animated: true)
    }
}

// MARK: - Private

private extension AbstractLevelTwoViewController {
    func setupCoachButton() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabCoachButton), for: .touchUpInside)
        let center = CGPoint(x: view.center.x, y: view.frame.height - 100)
        button.frame = CGRect(center: center, size: CGSize(width: 69, height: 69))
        button.backgroundColor = .yellow
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        view.addSubview(button)
    }

    func setupLevelNavigationuttonKnowing() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabLevelOneKnowingButton), for: .touchUpInside)
        let center = CGPoint(x: view.center.x - 60, y: view.frame.height - 160)
        button.frame = CGRect(center: center, size: CGSize(width: 44, height: 44))
        button.backgroundColor = .red
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        view.addSubview(button)
    }

    func setupLevelNavigationuttonDailyBried() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabbLevelOneDailyriefButton), for: .touchUpInside)
        let center = CGPoint(x: view.center.x, y: view.frame.height - 180)
        button.frame = CGRect(center: center, size: CGSize(width: 44, height: 44))
        button.backgroundColor = .blue
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        view.addSubview(button)
    }

    func setupLevelNavigationuttonMyQot() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabLevelOneMyQotutton), for: .touchUpInside)
        let center = CGPoint(x: view.center.x + 60, y: view.frame.height - 160)
        button.frame = CGRect(center: center, size: CGSize(width: 44, height: 44))
        button.backgroundColor = .green
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        view.addSubview(button)
    }
}
