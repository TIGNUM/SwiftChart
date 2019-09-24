//
//  MyPrepsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyPrepsViewControllerInterface: class {
    func dataUpdated()
}

protocol MyPrepsPresenterInterface {
    func dataUpdated()
}

protocol MyPrepsInteractorInterface: Interactor {
    func preparations(completion: @escaping ((MyPrepsModel?) -> Void))
    func recoveries(completion: @escaping ((RecoveriesModel?) -> Void))
    func mindsetShifters(completion: @escaping ((MindsetShiftersModel?) -> Void))
    func remove(segmentedControl: Int, at indexPath: IndexPath)
    func numberOfRowsPreparations(in section: Int) -> Int
    func numberOfRowsRecoveries(in section: Int) -> Int
    func numberOfRowsMindsetShifters(in section: Int) -> Int
    func itemPrep(at indexPath: IndexPath) -> MyPrepsModel.Items?
    func itemMind(at indexPath: IndexPath) -> MindsetShiftersModel.Items?
    func itemRec(at indexPath: IndexPath) -> RecoveriesModel.Items?
    func presentPreparation(item: QDMUserPreparation, viewController: UIViewController)
    func present3DRecovery(item: QDMRecovery3D, viewController: UIViewController)
    func showDeleteConfirmation(delegate: MyPrepsViewControllerDelegate?)
    func presentMindsetShifter(item: QDMMindsetShifter, viewController: UIViewController)
}

protocol MyPrepsRouterInterface {
    func showDeleteConfirmation(delegate: MyPrepsViewControllerDelegate?)
    func dismiss()
}
