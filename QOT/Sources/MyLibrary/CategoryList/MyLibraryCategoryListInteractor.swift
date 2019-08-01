//
//  MyLibraryCategoryListInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryCategoryListInteractor {

    // MARK: - Properties

    private let worker: MyLibraryCategoryListWorker
    private let presenter: MyLibraryCategoryListPresenterInterface
    private let router: MyLibraryCategoryListRouterInterface

    var categoryItems = [MyLibraryCategoryListModel]()

    // MARK: - Init

    init(worker: MyLibraryCategoryListWorker,
        presenter: MyLibraryCategoryListPresenterInterface,
        router: MyLibraryCategoryListRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(load(_:)),
                                               name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(load(_:)),
                                               name: .didUpdateMyLibraryData, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        load()
    }

    @objc func load(_ notification: Notification? = nil) {
        worker.loadData { [weak self] (initiated, items) in
            if !initiated {
                // shows loading
            } else {
                self?.categoryItems.removeAll()
                self?.categoryItems.append(contentsOf: items ?? [])
                self?.presenter.presentStorages()
            }
        }
    }
}

// MARK: - MyLibraryCategoryListInteractorInterface

extension MyLibraryCategoryListInteractor: MyLibraryCategoryListInteractorInterface {

    func handleSelectedItem(at index: Int) {
        if categoryItems.count > index {
            let item = categoryItems[index]
            router.presentLibraryItems(for: item.type)
        }
    }
}
