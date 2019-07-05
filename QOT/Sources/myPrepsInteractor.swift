//
//  MyPrepsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyPrepsInteractor {

    // MARK: - Properties

    private let worker: MyPrepsWorker
    private let presenter: MyPrepsPresenterInterface
    private let router: MyPrepsRouterInterface

    // MARK: - Init

    init(worker: MyPrepsWorker,
         presenter: MyPrepsPresenterInterface,
         router: MyPrepsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyPrepsInteractorInterface

extension MyPrepsInteractor: MyPrepsInteractorInterface {
    func numberOfRowsPreparations(in section: Int) -> Int {
        return (worker.model?.prepItems.count ?? 0)
    }

    func numberOfRowsRecoveries(in section: Int) -> Int {
        return (worker.recModel?.prepItems.count ?? 0)
    }

    func numberOfRowsMindsetShifters(in section: Int) -> Int {
        return (worker.mindModel?.prepItems.count ?? 0)
    }

    func itemPrep(at indexPath: IndexPath) -> MyPrepsModel.Items? {
        return worker.model?.prepItems[indexPath.row]
    }

    func itemRec(at indexPath: IndexPath) -> RecoveriesModel.Items? {
        return worker.recModel?.prepItems[indexPath.row]
    }

    func itemMind(at indexPath: IndexPath) -> MindsetShiftersModel.Items? {
        return worker.mindModel?.prepItems[indexPath.row]
    }

    func preparations(completion: @escaping ((MyPrepsModel?) -> Void)) {
        worker.preparations { (model) in
            completion(model)
        }
    }

    func recoveries(completion: @escaping ((RecoveriesModel?) -> Void)) {
        worker.recoveries { (model) in
            completion(model)
        }
    }

    func mindsetShifters(completion: @escaping ((MindsetShiftersModel?) -> Void)) {
        worker.mindsetShifters { (model) in
            completion(model)
        }
    }

    func remove(segmentedControl: Int, at indexPath: IndexPath) {
        worker.remove(segmentedControl: segmentedControl, at: indexPath) { [weak self] in
            self?.presenter.updateView()
        }
    }

    func createPreparationModel() {
        worker.createPrepModel()
    }

    func createMindsetShifterModel() {
        worker.createMindModel()
    }

    func createRecovery3DModel() {
        worker.createRecModel()
    }

    func presentPreparation(item: QDMUserPreparation, viewController: UIViewController) {
        let configurator = PrepareResultsConfigurator.configurate(item, [], canDelete: true)
        let controller = PrepareResultsViewController(configure: configurator)
        viewController.present(controller, animated: true)
        UIApplication.shared.setStatusBar(colorMode: .darkNot)
    }
}
