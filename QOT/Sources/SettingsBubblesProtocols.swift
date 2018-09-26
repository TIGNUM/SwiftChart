//
//  SettingsBubblesProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol SettingsBubblesViewControllerInterface: class {
    func load(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem)
}

protocol SettingsBubblesPresenterInterface {
    func load(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem)
}

protocol SettingsBubblesInteractorInterface: Interactor {
    func handleSelection(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem)
}

protocol SettingsBubblesRouterInterface {
    func handleSelection(bubbleTapped: SettingsBubblesModel.SettingsBubblesItem)
}
