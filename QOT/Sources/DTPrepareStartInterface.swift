//
//  DTPrepareStartInterface.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol DTPrepareStartViewControllerInterface: class {
    func setupView(viewModel: DTPrepareStartViewModel)
}

protocol DTPrepareStartPresenterInterface {
    func setupView()
}

protocol DTPrepareStartInteractorInterface: Interactor {}

protocol DTPrepareStartRouterInterface {
    func dismiss()
    func presentChatBotCritical()
    func presentChatBotDaily()
}
