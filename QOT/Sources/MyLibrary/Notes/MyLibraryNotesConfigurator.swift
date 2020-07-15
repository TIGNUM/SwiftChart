//
//  MyLibraryNotesConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyLibraryNotesConfigurator {

    static func make(with team: QDMTeam?) -> (MyLibraryNotesViewController, String?) -> Void {
        return { (viewController, note) in
            let router = MyLibraryNotesRouter(viewController: viewController)
            let worker = MyLibraryNotesWorker(noteId: note)
            let presenter = MyLibraryNotesPresenter(viewController: viewController)
            let interactor = MyLibraryNotesInteractor(team: team, worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
