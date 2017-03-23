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
    private var token: NotificationToken?

    var categoryCount: Index {
        return categories.count
    }

    // MARK: - Life Cycle

    init(categories: Results<PrepareCategory>) {
        self.categories = categories
        self.token = categories.addNotificationBlock { (change) in
            switch change {
            case .error(let error):
                assertionFailure("An error occurred: \(error)")
            case .initial(_):
                QOTLog(Verbose.Database.Prepare, "Initial run of the query has completed.")
            case .update(_, let deletions, let insertions, let modifications):
                QOTLog(Verbose.Database.Prepare, "Update deletions: \(deletions), insertions: \(insertions), modifications: \(modifications)")
            }
        }
    }

    // MARK: - Helpers

    func category(at index: Index) -> PrepareCategory {
        return categories[index] as PrepareCategory
    }
}
