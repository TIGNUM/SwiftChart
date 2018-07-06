//
//  SigningCountryInteractor.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCountryInteractor {

    // MARK: - Properties

    private let worker: SigningCountryWorker
    private let presenter: SigningCountryPresenterInterface
    private let router: SigningCountryRouterInterface

    // MARK: - Init

    init(worker: SigningCountryWorker,
         presenter: SigningCountryPresenterInterface,
         router: SigningCountryRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup()
        worker.fetchCountries { [weak self] in
            self?.presenter.tableViewReloadData()
        }
    }
}

// MARK: - SigningCountryInteractorInterface

extension SigningCountryInteractor: SigningCountryInteractorInterface {

    func updateWorkerValue(for formType: FormView.FormType?) {
        worker.updateCountryQuery(query: formType?.value ?? "")
    }

    func setSelectedCountry(countryName: String) {
        worker.setSelectedCountry(countryName: countryName)
    }

    func didTapNext() {
        guard let country = worker.selectedCountry else { return }
        worker.userSigning.country = country
        router.showProfileDetailsView(userSigning: worker.userSigning)
    }

    var countryQuery: String {
        return worker.countryQuery
    }

    func country(at indexPath: IndexPath) -> String {
        return indexPath.row < worker.countryNames.count ? worker.countryNames[indexPath.row] : ""
    }

    func numberOfRows() -> Int {
        return worker.numberOfRows(query: worker.countryQuery)
    }
}
