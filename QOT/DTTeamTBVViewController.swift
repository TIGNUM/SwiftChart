//
//  DTTeamTBVViewController.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class DTTeamTBVViewController: DTViewController {

    // MARK: - Init
    init(configure: Configurator<DTTeamTBVViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didTapClose() {
        router?.dismissChatBotFlow()
    }
}

// MARK: - Private
private extension DTTeamTBVViewController {}

// MARK: - DTTeamTBVViewControllerInterface
extension DTTeamTBVViewController: DTTeamTBVViewControllerInterface {}
