//
//  SubsriptionReminderInterface.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol SubsriptionReminderViewControllerInterface: class {
    func setupView()
}

protocol SubsriptionReminderPresenterInterface {
    func setupView()
    func load()
}

protocol SubsriptionReminderInteractorInterface: Interactor {
    func didTapMinimiseButton()
    func didTapSwitchAccounts()
    var title: NSAttributedString? { get }
    var subTitle: NSAttributedString? { get }
    var benefitsTitleFirst: NSAttributedString? { get }
    var benefitsSubtitleFirst: NSAttributedString? { get }
    var benefitsTitleSecond: NSAttributedString? { get }
    var benefitsSubtitleSecond: NSAttributedString? { get }
    var benefitsTitleThird: NSAttributedString? { get }
    var benefitsSubtitleThird: NSAttributedString? { get }
    var benefitsTitleFourth: NSAttributedString? { get }
    var benefitsSubtitleFourth: NSAttributedString? { get }
    var showCloseButton: Bool { get }
    var showSwitchAccountButton: Bool { get }
}

protocol SubsriptionReminderRouterInterface {
    func dismiss()
    func showLogoutDialog()
}
