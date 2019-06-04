//
//  MyQotAboutUsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAboutUsInteractor {
    
    // MARK: - Properties
    
    private let worker: MyQotAboutUsWorker
    private let presenter: MyQotAboutUsPresenterInterface
    private let router: MyQotAboutUsRouterInterface
    
    // MARK: - Init
    
    init(worker: MyQotAboutUsWorker,
         presenter: MyQotAboutUsPresenterInterface,
         router: MyQotAboutUsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
    
    func viewDidLoad() {
        presenter.setupView(with: worker.aboutUsText)
    }
}

extension MyQotAboutUsInteractor: MyQotAboutUsInteractorInterface {
    var aboutUsText: String {
        return worker.aboutUsText
    }
    
    func itemCount() -> Int {
        return worker.itemCount()
    }
    
    func item(at indexPath: IndexPath) -> MyQotAboutUsModel.MyQotAboutUsModelItem? {
        return worker.item(at: indexPath)
    }
    
    func trackingKeys(at indexPath: IndexPath) -> String {
        return worker.trackingKeys(at: indexPath)
    }
    
    func title(at indexPath: IndexPath) -> String {
        return worker.title(at: indexPath)
    }
    
    func subtitle(at indexPath: IndexPath) -> String {
        return worker.subtitle(at: indexPath)
    }
    
    func contentCollection(_ item: MyQotAboutUsModel.MyQotAboutUsModelItem) -> ContentCollection? {
        return worker.contentCollection(item)
    }
    
    func handleSelection(for indexPath: IndexPath) {
        guard let item = worker.item(at: indexPath) else { return }
        router.handleSelection(for: item)
    }
}
