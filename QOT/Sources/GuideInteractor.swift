//
//  GuideInteractor.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol GuideInteractorInput {

    func fetchItems()
}

protocol GuideInteractorOutput {

    func presentFetchResults()
}

final class GuideInteractor: GuideInteractorInput {

    var output: GuideInteractorOutput!
    var worker: GuideWorker!

    func fetchItems() {

        worker = GuideWorker()
        worker.fetch()
        output.presentFetchResults()
    }
}
