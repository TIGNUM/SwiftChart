//
//  RegistrationRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationRouter: BaseRouter, RegistrationRouterInterface {
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
