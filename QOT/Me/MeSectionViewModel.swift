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
    let profileImage = R.image.profileImage()
    let items = mockMyDataItems
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> MyDataItem {
        return items[indexPath.row]
    }
}

protocol MyDataItem {
    var localID: String { get }
    var load: CGFloat { get }
    var category: DataCategory { get }
}

enum DataCategory {
    case load(subCategory: Load)
    case bodyBrain(subCategory: BodyBrain)

    enum Load {
        case load(title: String)
        case meetings(title: String)
        case peak(title: String)
        case trips(title: String)
        case sleep(title: String)
        case activity(title: String)

        var angle: CGFloat {
            switch self {
            case .load(_): return 120
            case .meetings(_): return 140
            case .peak(_): return 160
            case .trips(_): return 180
            case .sleep(_): return 200
            case .activity(_): return 220
            }
        }

        var distance: CGFloat {
            return randomNumber
        }
    }

    enum BodyBrain {
        case nutrition(title: String)
        case movement(title: String)

        var angle: CGFloat {
            switch self {
            case .nutrition(_): return 240
            case .movement(_): return 260
            }
        }

        var distance: CGFloat {
            return randomNumber
        }
    }
}

struct MockMyDataItem: MyDataItem {
    let localID: String
    let load: CGFloat
    let category: DataCategory
}

private var mockMyDataItems: [MyDataItem] {
    return [
        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .load(title: "load")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .meetings(title: "meetings")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .peak(title: "peak")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .trips(title: "trips")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .sleep(title: "sleep")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.load(
                subCategory: .activity(title: "activity")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.bodyBrain(
                subCategory: .nutrition(title: "nutrition")
            )
        ),

        MockMyDataItem(
            localID: UUID().uuidString,
            load: randomNumber,
            category: DataCategory.bodyBrain(
                subCategory: .movement(title: "movement")
            )
        )
    ]
}
