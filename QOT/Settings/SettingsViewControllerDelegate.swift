//
//  SettingsViewControllerDelegate.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func didTapSettingsViewController(in viewController: UIViewController)
    func didTapClose(in viewController: UIViewController, animated: Bool)
}
