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
    private let worker = MyPrepsWorker()
    private let presenter: MyPrepsPresenterInterface
    private var isEditing = false
    private var canEdit = true

    // MARK: - Init
    init(presenter: MyPrepsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        fetchItemsAndUpdateView()
        presenter.setupView(viewModel: worker.getViewModel())
    }
}

// MARK: - MyPrepsInteractorInterface
extension MyPrepsInteractor: MyPrepsInteractorInterface {

    func fetchItemsAndUpdateView() {
        worker.createModels {
            self.presenter.dataUpdated()
        }
    }

    func numberOfRowsPreparations() -> Int {
        return (worker.model?.items.first?.count ?? 0) + (worker.model?.items.last?.count ?? 0)
    }

    func numberOfRowsCriticalPreparations() -> Int {
        return (worker.model?.items.first?.count ?? 0)
    }

    func numberOfRowsEverydayPreparations() -> Int {
        return  (worker.model?.items.last?.count ?? 0)
    }

    func numberOfRowsRecoveries() -> Int {
        return (worker.recModel?.items.count ?? 0)
    }

    func numberOfRowsMindsetShifters() -> Int {
        return (worker.mindModel?.items.count ?? 0)
    }

    var criticalPrepItems: [MyPrepsModel.Item]? {
        let criticalItems = worker.model?.items.first
        return criticalItems
    }

    var everydayPrepItems: [MyPrepsModel.Item]? {
        let everydayItems = worker.model?.items.last
        return everydayItems
    }

    func itemRec(at indexPath: IndexPath) -> RecoveriesModel.Item? {
        guard worker.recModel?.items.count ?? .zero > indexPath.row else {
            return nil
        }
        return worker.recModel?.items[indexPath.row]
    }

    func itemMind(at indexPath: IndexPath) -> MindsetShiftersModel.Item? {
        guard worker.mindModel?.items.count ?? .zero > indexPath.row else {
            return nil
        }
        return worker.mindModel?.items[indexPath.row]
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
            self?.presenter.dataUpdated()
        }
    }

    func presentPreparation(item: QDMUserPreparation, viewController: UIViewController) {
        let configurator = ResultsPrepareConfigurator.make(item, resultType: .prepareMyPlans)
        let controller = ResultsPrepareViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }

    func present3DRecovery(item: QDMRecovery3D, viewController: UIViewController) {
        let configurator = SolveResultsConfigurator.make(from: item, resultType: .recoveryMyPlans)
        let controller = SolveResultsViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }

    func presentMindsetShifter(item: QDMMindsetShifter, viewController: UIViewController) {
        let configurator = ShifterResultConfigurator.make(mindsetShifter: item, resultType: .mindsetShifterMyPlans)
        let controller = ShifterResultViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }
}
