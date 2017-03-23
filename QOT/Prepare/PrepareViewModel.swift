//
//  PrepareViewModel.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

protocol ChatBot {

    var message: String { get }
    var type: Preparation.ChatType { get }
}

final class PrepareChatBotViewModel {

    // MARK: - Properties

    private let categories: Results<PrepareCategory>

    var categoryCount: Index {
        return categories.count
    }

    // MARK: - Life Cycle

    init(categories: Results<PrepareCategory>) {
        self.categories = categories
    }

    // MARK: - Helpers

    func category(at index: Index) -> PrepareCategory {
        return categories[index] as PrepareCategory
    }
}
