//
//  MyLibraryCategoryListInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListInteractor {

    // MARK: - Properties
    private let worker: MyLibraryCategoryListWorker
    private let presenter: MyLibraryCategoryListPresenterInterface
    private let router: MyLibraryCategoryListRouterInterface
    private let team: QDMTeam?
    private var targetCategory: String?
    var categoryItems = [MyLibraryCategoryListModel]()

    // MARK: - Init
    init(team: QDMTeam?,
         category: String?,
         worker: MyLibraryCategoryListWorker,
         presenter: MyLibraryCategoryListPresenterInterface,
         router: MyLibraryCategoryListRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.team = team
        self.targetCategory = category

        _ = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.load(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .didUpdateMyLibraryData,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.load(notification)
        }
    }

    // MARK: - Texts
    var titleText: String {
        if let team = team {
            return worker.titleTemplateForTeam.replacingOccurrences(of: "${NAME}", with: team.name ?? "")
        }
        return worker.titleText
    }
    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        load()
    }

    @objc func load(_ notification: Notification? = nil) {
        worker.loadData(in: team) { [weak self] (initiated, items) in
            if !initiated {
                // shows loading
            } else {
                self?.categoryItems.removeAll()
                self?.categoryItems.append(contentsOf: items ?? [])
                self?.presenter.presentStorages()
                if let categoryString = self?.targetCategory?.uppercased() {
                    self?.targetCategory = nil
                    guard let type = MyLibraryCategoryType(rawValue: categoryString) else { return }
                    if let item = self?.categoryItems.filter({ $0.type == type }).first {
                        self?.router.presentLibraryItems(for: item, in: self?.team)
                    }
                }
            }
        }
    }
}

// MARK: - MyLibraryCategoryListInteractorInterface
extension MyLibraryCategoryListInteractor: MyLibraryCategoryListInteractorInterface {
    var teamId: Int? {
        return team?.remoteID == .zero ? nil : team?.remoteID
    }

    func handleSelectedItem(at index: Int) {
        if categoryItems.count > index {
            let item = categoryItems[index]
            router.presentLibraryItems(for: item, in: team)
        }
    }

    func reload() {
        load()
    }
}
