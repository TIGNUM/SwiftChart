//
//  AskPermissionInterface.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol AskPermissionViewControllerInterface: class {
    func setupView(_ viewModel: AskPermission.ViewModel)
}

protocol AskPermissionPresenterInterface {
    func setupView(_ content: QDMContentCollection?, type: AskPermission.Kind?)
}

protocol AskPermissionInteractorInterface: Interactor {
    var permissionType: AskPermission.Kind { get }
    var placeholderImage: UIImage? { get }
}

protocol AskPermissionRouterInterface {
    func didTapConfirm(_ permissionType: AskPermission.Kind?)
}
