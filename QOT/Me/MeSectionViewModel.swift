//
//  MeSectionViewModel.swift
//  QOT
//
//  Created by karmic on 04.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MeSectionViewModel {

    // MARK: - Properties

    private let items = [MyDataItem]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> MyDataItem {
        return items[indexPath.row]
    }
}

enum MyDataItem {
    case image(localID: String, placeholderURL: URL)
    case dataPoint(localID: String, distance: Float, angle: Float)
}
