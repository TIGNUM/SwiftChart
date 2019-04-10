//
//  SubsriptionReminderInteractor.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SubsriptionReminderInteractor {

    // MARK: - Properties

    private let worker: SubsriptionReminderWorker
    private let presenter: SubsriptionReminderPresenterInterface
    private let router: SubsriptionReminderRouterInterface

    // MARK: - Init

    init(worker: SubsriptionReminderWorker,
        presenter: SubsriptionReminderPresenterInterface,
        router: SubsriptionReminderRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.load()
        presenter.setupView()
    }
}

// MARK: - SubsriptionReminderInteractorInterface

extension SubsriptionReminderInteractor: SubsriptionReminderInteractorInterface {
    var title: NSAttributedString? {
        return worker.title
    }

    var subTitle: NSAttributedString? {
        return worker.subTitle
    }

    var benefitsTitleFirst: NSAttributedString? {
        return worker.benefitsTitleFirst
    }

    var benefitsSubtitleFirst: NSAttributedString? {
        return worker.benefitsSubtitleFirst
    }

    var benefitsTitleSecond: NSAttributedString? {
        return worker.benefitsTitleSecond
    }

    var benefitsSubtitleSecond: NSAttributedString? {
        return worker.benefitsSubtitleSecond
    }

    var benefitsTitleThird: NSAttributedString? {
        return worker.benefitsTitleThird
    }

    var benefitsSubtitleThird: NSAttributedString? {
        return worker.benefitsSubtitleThird
    }

    var benefitsTitleFourth: NSAttributedString? {
        return worker.benefitsTitleFourth
    }

    var benefitsSubtitleFourth: NSAttributedString? {
        return worker.benefitsSubtitleFourth
    }

    var showCloseButton: Bool {
        return worker.expired == false
    }
    var showSwitchAccountButton: Bool {
        return worker.expired == true
    }

    func didTapMinimiseButton() {
        router.dismiss()
    }

    func didTapSwitchAccounts() {
        router.showLogoutDialog()
    }
}
