//
//  DTRecoveryViewController.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTRecoveryViewController: DTViewController {

    // MARK: - Init
    init(configure: Configurator<DTRecoveryViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension DTRecoveryViewController {}

// MARK: - DTRecoveryViewControllerInterface
extension DTRecoveryViewController: DTRecoveryViewControllerInterface {}
