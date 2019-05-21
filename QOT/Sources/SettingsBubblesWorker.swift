//
//  SettingsBubblesWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 12/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class SettingsBubblesWorker {

    private let services: Services
    private var type: SettingsBubblesType
    let updates = PublishSubject<CollectionUpdate, Never>()

    init(services: Services, type: SettingsBubblesType) {
        self.services = services
        self.type = type
    }

    func itemCount() -> Int {
        let items = type == .about ?
            SettingsBubblesModel.SettingsBubblesItem.aboutValues :
            SettingsBubblesModel.SettingsBubblesItem.supportValues
        return items.count
    }

    func item(at indexPath: IndexPath) -> SettingsBubblesModel.SettingsBubblesItem? {
        guard let item = SettingsBubblesModel.SettingsBubblesItem(rawValue: indexPath.row) else { return nil }
        return item
    }

    func contentCollection(_ item: SettingsBubblesModel.SettingsBubblesItem) -> ContentCollection? {
        return item.contentCollection(for: services.contentService)
    }
}
