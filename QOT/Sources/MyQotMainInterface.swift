//
//  MyQotMainInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import DifferenceKit

protocol MyQotMainViewControllerInterface: class {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]>)
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]>)
}

protocol MyQotMainInteractorInterface: Interactor {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyToBeVision()
    func presentMyLibrary()
    func presentMyDataScreen()
    func qotViewModelNew() -> [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]?
    func updateViewModelListNew(_ list: [ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>])
    func refreshParams()
}

protocol MyQotMainRouterInterface {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyToBeVision()
    func presentMyLibrary()
    func presentMyDataScreen()
}
