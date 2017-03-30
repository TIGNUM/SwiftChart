//
//  WhatsHotViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class WhatsHotViewModel {

    private let items = [WhatsHotItem]()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> WhatsHotItem {
        return items[index]
    }
}

protocol WhatsHot {
    var localID: String { get }
    var identifier: String { get }
    var title: String { get }
    var description: String { get }
    var mediaInformation: String { get }
    var mediaURL: URL { get }
    var bookmarked: Bool { get }
}

struct WhatsHotItem: WhatsHot {
    let localID: String
    let identifier: String
    let title: String
    let description: String
    let mediaInformation: String
    let mediaURL: URL
    let bookmarked: Bool
}

private func mockWhatsHotItems() -> [WhatsHotItem] {
    return [
        WhatsHotItem(
            localID: UUID().uuidString,
            identifier: ".087", title: "QOT // THOUGHTS",
            description: "Impact Of Extrinsic POLJ Motivation On Intrinsic",
            mediaInformation: "Impact Of Extrinsic POLJ Motivation On Intrinsic",
            mediaURL: URL(string:"https://example.com")!,
            bookmarked: false
        )
    ]
}

