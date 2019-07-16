//
//  MyLibraryNotesConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyLibraryNotesConfigurator: AppStateAccess {

    static func make() -> (MyLibraryNotesViewController, String?) -> Void {
        return { (viewController, note) in
            let router = MyLibraryNotesRouter(viewController: viewController)
            let worker = MyLibraryNotesWorker(noteId: note)
            let presenter = MyLibraryNotesPresenter(viewController: viewController)
            let interactor = MyLibraryNotesInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
