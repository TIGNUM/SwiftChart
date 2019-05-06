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

    lazy var coachButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabCoachButton), for: .touchUpInside)
        button.setImage(R.image.ic_coach(), for: .normal)
        let size = CGSize(width: 80, height: 80)
        let offset = (24 + size.width * 0.5)
        let center = CGPoint(x: view.frame.width - offset, y: view.frame.height - offset)
        button.frame = CGRect(center: center, size: size)
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        return button
    }()

    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
        button.setImage(R.image.arrowBack(), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        let size = CGSize(width: 40, height: 40)
        let offset = (24 + size.width * 0.5)
        let center = CGPoint(x: 48, y: coachButton.center.y)
        button.frame = CGRect(center: center, size: size)
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        return button
    }()

    func setupNavigationButtons() {
        view.addFadeView(at: .bottom, height: 120, primaryColor: .carbon)
        setupCoachButton()
        setupBackButton()
//        setupLevelNavigationuttonKnowing()
//        setupLevelNavigationuttonDailyBried()
//        setupLevelNavigationuttonMyQot()
    }

    func showHideNavigationButtons() {
        coachButton.isHidden = !coachButton.isHidden
        backButton.isHidden = !backButton.isHidden
    }
}

// MARK: - Actions

extension AbstractLevelTwoViewController {
    @objc func didTabBackButton() {
        dismiss(animated: true)
    }

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
        view.addSubview(coachButton)
    }

    func setupBackButton() {
        view.addSubview(backButton)
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
