//
//  MyQotAboutUsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

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
        aboutUsText {[weak self] (text) in
            self?.presenter.setupView(with: text)
        }
    }
}

extension MyQotAboutUsInteractor: MyQotAboutUsInteractorInterface {

    func aboutUsText(_ completion: @escaping(String) -> Void) {
        worker.aboutUsText { (text) in
            completion(text)
        }
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

    func title(at indexPath: IndexPath, _ completion: @escaping(String) -> Void) {
        worker.title(at: indexPath) { (text) in
            completion(text)
        }
    }

    func subtitle(at indexPath: IndexPath, _ completion: @escaping(String) -> Void) {
        worker.subtitle(at: indexPath) { (text) in
            completion(text)
        }
    }

    func contentCollection(item: MyQotAboutUsModel.MyQotAboutUsModelItem, _ completion: @escaping(QDMContentCollection?) -> Void) {
        worker.contentCollection(item: item) { (collection) in
            completion(collection)
        }
    }

    func handleSelection(for indexPath: IndexPath) {
        guard let item = worker.item(at: indexPath) else { return }
        router.handleSelection(for: item)
    }
}
