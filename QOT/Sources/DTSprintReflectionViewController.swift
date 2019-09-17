//
//  DTSprintReflectionViewController.swift
//  QOT
//
//  Created by Michael Karbe on 17.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSprintReflectionViewController: DTViewController {

    // MARK: - Init
    init(configure: Configurator<DTSprintReflectionViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension DTSprintReflectionViewController {}

// MARK: - DTSprintReflectionViewControllerInterface
extension DTSprintReflectionViewController: DTSprintReflectionViewControllerInterface {}
