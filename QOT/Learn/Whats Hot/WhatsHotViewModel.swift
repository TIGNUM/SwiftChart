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

    private let items = mockWhatsHotItems()
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at index: Index) -> WhatsHotItem {
        return items[index]
    }
}

protocol WhatsHotItem {
    var localID: String { get }
    var identifier: NSAttributedString { get }
    var subtitle: NSAttributedString { get }
    var text: NSAttributedString { get }
    var mediaInformation: NSAttributedString { get }
    var placeholderURL: URL { get }
    var bookmarked: Bool { get }
}

struct MockWhatsHotItem: WhatsHotItem {
    let localID: String
    let identifier: NSAttributedString
    let subtitle: NSAttributedString
    let text: NSAttributedString
    let mediaInformation: NSAttributedString
    let placeholderURL: URL
    let bookmarked: Bool
}

private func mockWhatsHotItems() -> [WhatsHotItem] {
    return [
        MockWhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.WhatsHot.identifier(string: ".087"),
            subtitle: AttributedString.Learn.WhatsHot.title(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.WhatsHot.text(string: "IMPACT Of EXTRINSIC POLJ MOTIVATION ON INTRINSIC"),
            mediaInformation: AttributedString.Learn.WhatsHot.title(string: "VIDEO // 2 MIN"),
            placeholderURL: URL(string:"https://static.pexels.com/photos/348323/pexels-photo-348323.jpeg")!,
            bookmarked: false
        ),

        MockWhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.WhatsHot.identifier(string: ".086"),
            subtitle: AttributedString.Learn.WhatsHot.title(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.WhatsHot.text(string: "IMPACT Of EXTRINSIC POLJ MOTIVATION ON INTRINSIC"),
            mediaInformation: AttributedString.Learn.WhatsHot.title(string: "VIDEO // 2 MIN"),
            placeholderURL: URL(string:"https://static.pexels.com/photos/234171/pexels-photo-234171.jpeg")!,
            bookmarked: false
        ),

        MockWhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.WhatsHot.identifier(string: ".085"),
            subtitle: AttributedString.Learn.WhatsHot.title(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.WhatsHot.text(string: "IMPACT Of EXTRINSIC POLJ MOTIVATION ON INTRINSIC"),
            mediaInformation: AttributedString.Learn.WhatsHot.title(string: "VIDEO // 2 MIN"),
            placeholderURL: URL(string:"https://images.pexels.com/photos/7715/pexels-photo.jpg?w=1260&h=750&auto=compress&cs=tinysrgb")!,
            bookmarked: false
        ),

        MockWhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.WhatsHot.identifier(string: ".084"),
            subtitle: AttributedString.Learn.WhatsHot.title(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.WhatsHot.text(string: "IMPACT Of EXTRINSIC POLJ MOTIVATION ON INTRINSIC"),
            mediaInformation: AttributedString.Learn.WhatsHot.title(string: "VIDEO // 2 MIN"),
            placeholderURL: URL(string:"https://static.pexels.com/photos/351073/pexels-photo-351073.jpeg")!,
            bookmarked: false
        )
    ]
}
