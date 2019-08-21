//
//  MyDataScreenConfigurator.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import Foundation
import qot_dal

final class MyDataScreenConfigurator: AppStateAccess {
    static func make() -> (MyDataScreenViewController) -> Void {
        return { (viewController) in
            let router = MyDataScreenRouter(viewController: viewController)
            let worker = MyDataScreenWorker(dataService: qot_dal.MyDataService.main)
            let presenter = MyDataScreenPresenter(viewController: viewController)
            let interactor = MyDataScreenInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
