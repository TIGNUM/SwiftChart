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

protocol WhatsHot {
    var localID: String { get }
    var identifier: NSAttributedString { get }
    var subtitle: NSAttributedString { get }
    var text: NSAttributedString { get }
    var mediaInformation: NSAttributedString { get }
    var mediaURL: URL { get }
    var bookmarked: Bool { get }
}

struct WhatsHotItem: WhatsHot {
    let localID: String
    let identifier: NSAttributedString
    let subtitle: NSAttributedString
    let text: NSAttributedString
    let mediaInformation: NSAttributedString
    let mediaURL: URL
    let bookmarked: Bool
}

private func mockWhatsHotItems() -> [WhatsHotItem] {
    return [
        WhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.whatsHotID(string: ".087"),
            subtitle: AttributedString.Learn.whatsHotTitle(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.whatsHotText(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaInformation: AttributedString.Learn.whatsHotTitle(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaURL: URL(string:"https://example.com")!,
            bookmarked: false
        ),

        WhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.whatsHotID(string: ".086"),
            subtitle: AttributedString.Learn.whatsHotTitle(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.whatsHotText(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaInformation: AttributedString.Learn.whatsHotTitle(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaURL: URL(string:"https://example.com")!,
            bookmarked: false
        ),

        WhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.whatsHotID(string: ".085"),
            subtitle: AttributedString.Learn.whatsHotTitle(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.whatsHotText(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaInformation: AttributedString.Learn.whatsHotTitle(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaURL: URL(string:"https://example.com")!,
            bookmarked: false
        ),

        WhatsHotItem(
            localID: UUID().uuidString,
            identifier: AttributedString.Learn.whatsHotID(string: ".084"),
            subtitle: AttributedString.Learn.whatsHotTitle(string: "QOT // THOUGHTS"),
            text: AttributedString.Learn.whatsHotText(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaInformation: AttributedString.Learn.whatsHotTitle(string: "Impact Of Extrinsic POLJ Motivation On Intrinsic"),
            mediaURL: URL(string:"https://example.com")!,
            bookmarked: false
        )
    ]
}
