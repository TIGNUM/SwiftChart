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
    func setupView(viewModel: MyPlansViewModel)
}

protocol MyPrepsPresenterInterface {
    func dataUpdated()
    func setupView(viewModel: MyPlansViewModel)
}

protocol MyPrepsInteractorInterface: Interactor {
    func preparations(completion: @escaping ((MyPrepsModel?) -> Void))
    func recoveries(completion: @escaping ((RecoveriesModel?) -> Void))
    func mindsetShifters(completion: @escaping ((MindsetShiftersModel?) -> Void))

    func numberOfRowsPreparations() -> Int
    func numberOfRowsRecoveries() -> Int
    func numberOfRowsMindsetShifters() -> Int

    func itemPrep(at indexPath: IndexPath) -> MyPrepsModel.Item?
    func itemMind(at indexPath: IndexPath) -> MindsetShiftersModel.Item?
    func itemRec(at indexPath: IndexPath) -> RecoveriesModel.Item?

    func presentPreparation(item: QDMUserPreparation, viewController: UIViewController)
    func present3DRecovery(item: QDMRecovery3D, viewController: UIViewController)
    func presentMindsetShifter(item: QDMMindsetShifter, viewController: UIViewController)

    func fetchItemsAndUpdateView()
    func showDeleteConfirmation(delegate: MyPrepsViewControllerDelegate?)
    func remove(segmentedControl: Int, at indexPath: IndexPath)
}

protocol MyPrepsRouterInterface {
    func showDeleteConfirmation(delegate: MyPrepsViewControllerDelegate?)
    func dismiss()
}
