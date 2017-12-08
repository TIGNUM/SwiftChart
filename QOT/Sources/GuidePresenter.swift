//
//  GuidePresenter.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol GuidePresenterInput {

    func presentFetchResults()
}

protocol GuidePresenterOutput: class {

    func successFetchedItems(viewModel: GuideModel.ViewModel)

    func errorFetchingItems()
}

final class GuidePresenter: GuidePresenterInput {

    weak var output: GuidePresenterOutput!

    func presentFetchResults() {
        let viewModel = GuideModel.ViewModel(title: "Morning InterView",
                                             content: "Some content",
                                             type: .morningInterview,
                                             status: .todo,
                                             plan: ".0001 plan")
        output.successFetchedItems(viewModel: viewModel)
    }
}
