//
//  DTPrepareInterface.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTPrepareViewControllerInterface: class {}

protocol DTPreparePresenterInterface {}

protocol DTPrepareInteractorInterface: Interactor {}

protocol DTPrepareRouterInterface {
    func presentPrepareResults(_ contentId: Int)
    func presentPrepareResults(_ preparation: QDMUserPreparation, _ answers: [SelectedAnswer])
}
