//
//  AskPermissionInterface.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool)
}

protocol AskPermissionViewControllerInterface: class {
    func setupView(_ viewModel: AskPermission.ViewModel)
}

protocol AskPermissionPresenterInterface {
    func setupView(_ content: QDMContentCollection?, type: AskPermission.Kind?)
}

protocol AskPermissionInteractorInterface: Interactor {
    var permissionType: AskPermission.Kind { get }
    var placeholderImage: UIImage? { get }
    func didTapSkip()
    func didTapConfirm()
}

protocol AskPermissionRouterInterface {
    func didTapDismiss(_ permissionType: AskPermission.Kind)
    func didTapConfirm(_ permissionType: AskPermission.Kind)
}
