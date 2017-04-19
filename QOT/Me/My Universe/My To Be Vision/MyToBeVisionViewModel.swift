//
//  MyToBeVisionViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionViewModel {

    // MARK: - Properties

    fileprivate let myToBeVision = mockMyToBeVisionItem

    var title: String {
        return myToBeVision.title
    }

    var headLine: String {
        return myToBeVision.headline
    }

    var subHeadline: String {
        return myToBeVision.subHeadline
    }

    var text: String {
        return myToBeVision.text
    }

    var profileImage: URL {
        return myToBeVision.profileImage
    }
}

// MARK: - Mock Data

protocol MyToBeVision {
    var title: String { get }
    var headline: String { get }
    var subHeadline: String { get }
    var text: String { get }
    var profileImage: URL { get }
}

struct MockMyToBeVision: MyToBeVision {
    let title: String
    let headline: String
    let subHeadline: String
    let text: String
    let profileImage: URL
}

private var mockMyToBeVisionItem: MyToBeVision {
    return MockMyToBeVision(
        title: "My To Be Vision",
        headline: "LORE IPSUM IMPUSM PLUS",
        subHeadline: "Written 45 days ago",
        text: "Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum textYour are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text Your are having a lorem Issue here and there ipsum text text text text there ipsum text",
        profileImage: URL(string: "https://randomuser.me/api/portraits/men/10.jpg")!
    )
}
