//
//  MyWhyViewModel.swift
//  QOT
//
//  Created by karmic on 13.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MyWhyViewModel {

    // MARK: - Properties

    let items = mockMyWhyItems
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func itemCount(for myWhyItem: MyWhy) -> Int {
        switch myWhyItem {
        case .vision: return 0
        case .weeklyChoices(_, let choices): return choices.count
        case .partners(_, let partners): return partners.count
        }
    }
}

enum MyWhy {
    case vision(Vision)
    case weeklyChoices(title: String, choices: [WeeklyChoice])
    case partners(title: String, partners: [Partner])

    enum Index: Int {
        case vision = 0
        case weeklyChoices = 1
        case partners = 2
    }
}

protocol Vision {
    var localID: String { get }
    var title: String { get }
    var text: String { get }
}

protocol WeeklyChoice {
    var localID: String { get }
    var title: String { get }
    var text: String { get }
}

protocol Partner {
    var localID: String { get }
    var profileImage: UIImage? { get set }
    var name: String { get set }
    var surename: String { get set }
    var initials: String { get }
    var relationship: String { get set }
    var email: String { get set }
}

struct MockVison: Vision {
    let localID: String
    let title: String
    let text: String
}

struct MockWeeklyChoice: WeeklyChoice {
    let localID: String
    let title: String
    let text: String
}

class MockPartner: Partner {
    let localID: String
    var profileImage: UIImage?
    var name: String
    var surename: String
    var relationship: String
    var email: String

    var initials: String {
        guard name.isEmpty == false && surename.isEmpty == false else {
            return ""
        }

        return String(name.characters.first!) + String(surename.characters.first!)
    }

    init(localID: String, profileImage: UIImage?, name: String, surename: String, relationship: String, email: String) {
        self.profileImage = profileImage
        self.name = name
        self.surename = surename
        self.relationship = relationship
        self.email = email
        self.localID = localID
    }
}

private var mockMyWhyItems: [MyWhy] {
    return [
        .vision(myToBeVision),
        .weeklyChoices(title: R.string.localized.meSectorMyWhyWeeklyChoicesTitle(), choices: weeklyChoices),
        .partners(title: R.string.localized.meSectorMyWhyPartnersTitle(), partners: partners)
    ]
}

private var myToBeVision: Vision {
    return MockVison(
        localID: UUID().uuidString,
        title: R.string.localized.meSectorMyWhyVisionTitle(),
        text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut")
}

private var weeklyChoices: [WeeklyChoice] {
    return [
        MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".01 choice",
            text: "You are having a Lorem ipsum here and"
        ),

        MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".02 choice",
            text: "You are having a Lorem ipsum here and"
        ),

        MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".03 choice",
            text: "You are having a Lorem ipsum here and"
        ),

        MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".04 choice",
            text: "You are having a Lorem ipsum here and"
        ),

        MockWeeklyChoice(
            localID: UUID().uuidString,
            title: ".05 choice",
            text: "You are having a Lorem ipsum here and"
        )
    ]
}

private var partners: [Partner] {
    return [
        MockPartner(
            localID: UUID().uuidString,
            profileImage: R.image.partnerProfileImage(),
            name: "Giorgio",
            surename: "Moroder",
            relationship: "Brother",
            email: "giorgiomoroder@novartis.com"
        ),

        MockPartner(
            localID: UUID().uuidString,
            profileImage: nil,
            name: "Giorgio",
            surename: "Moroder",
            relationship: "Brother",
            email: "giorgiomoroder@novartis.com"
        ),

        MockPartner(
            localID: UUID().uuidString,
            profileImage: nil,
            name: "Simon",
            surename: "Pebbels",
            relationship: "Brother",
            email: "giorgiomoroder@novartis.com"
        )
    ]
}
