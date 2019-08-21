//
//  MyQotMainInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotMainViewControllerInterface: class {
    func setupView()
    func setup(for myQotSection: MyQotViewModel)
}

protocol MyQotMainPresenterInterface {
    func setupView()
    func present(for myQotSection: MyQotViewModel)
}

protocol MyQotMainInteractorInterface: Interactor {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyToBeVision()
    func presentMyLibrary()
    func getImpactReadinessScore(completion: @escaping(Double?) -> Void)
    func presentMyDataScreen()
    func nextPrep(completion: @escaping (String?) -> Void)
    func nextPrepType(completion: @escaping (String?) -> Void)
    func toBeVisionDate(completion: @escaping (Date?) -> Void)
    func getSubtitles(completion: @escaping ([String?]) -> Void)
    func getUserName(completion: @escaping (String?) -> Void)
}

protocol MyQotMainRouterInterface {
    func presentMyPreps()
    func presentMyProfile()
    func presentMySprints()
    func presentMyToBeVision()
    func presentMyLibrary()
    func presentMyDataScreen()
}
