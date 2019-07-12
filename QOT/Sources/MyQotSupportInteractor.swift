//
//  MyQotSupportInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportInteractor {

    // MARK: - Properties

    private let worker: MyQotSupportWorker
    private let presenter: MyQotSupportPresenterInterface
    private let router: MyQotSupportRouterInterface

    // MARK: - Init

    init(worker: MyQotSupportWorker,
         presenter: MyQotSupportPresenterInterface,
         router: MyQotSupportRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.setupView()
    }
}

extension MyQotSupportInteractor: MyQotSupportInteractorInterface {
    func itemCount() -> Int {
        return worker.itemCount()
    }

    func item(at indexPath: IndexPath) -> MyQotSupportModel.MyQotSupportModelItem? {
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

    func contentCollection(_ item: MyQotSupportModel.MyQotSupportModelItem, _ completion: @escaping(QDMContentCollection?) -> Void) {
        worker.contentCollection(item) { (collection) in
            completion(collection)
        }
    }

    func handleSelection(for indexPath: IndexPath) {
        guard let item = worker.item(at: indexPath) else { return }
        worker.email {[weak self] (email) in
            self?.router.handleSelection(for: item, email: email)
        }
    }

    func supportText(_ completion: @escaping(String) -> Void) {
        worker.supportText { (text) in
            completion(text)
        }
    }
}
