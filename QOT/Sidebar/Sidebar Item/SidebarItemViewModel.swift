//
//  SidebarItemViewModel.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class SidebarItemViewModel {

    enum ItemType {
        case about
        case benefits
        case privacy
    }

    // MARK: - Properties

    private let items: [SidebarItem]
    private let sidebarItemType: ItemType
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> SidebarItem {
        return items[indexPath.row]
    }

    // MARK: - Init

    init(sidebarItemType: ItemType) {
        self.sidebarItemType = sidebarItemType
        self.items = mockSidebarItems(sidebarItemType: sidebarItemType)
    }
}

enum SidebarItem {
    case text(localID: String, title: NSAttributedString, text: NSAttributedString)
    case video(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case audio(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case image(localID: String, placeholderURL: URL, description: NSAttributedString?)
    case shareAction(title: NSAttributedString)
}

private func mockSidebarItems(sidebarItemType: SidebarItemViewModel.ItemType) -> [SidebarItem] {
    switch sidebarItemType {
    case .about: return mockAboutItems
    case .benefits: return mockBenefitItems
    case .privacy: return mockPrivacyItems
    }
}

private var mockBenefitItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.Benefits.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Sidebar.SideBarItems.Benefits.headerText(string: "Lorem ipsum 26 items")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: AttributedString.Sidebar.SideBarItems.Benefits.headerText(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.Benefits.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Sidebar.SideBarItems.Benefits.text(string: "Performance Mindset")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.Benefits.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Sidebar.SideBarItems.Benefits.text(string: "Performance Mindset")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: AttributedString.Sidebar.SideBarItems.Benefits.headerText(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.Benefits.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Sidebar.SideBarItems.Benefits.text(string: "Performance Mindset")
        ),

        .shareAction(
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.shareText(string: "Share")
        )
    ]
}

private var mockPrivacyItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerTitle(string: ".01 SCOPE OF APPLICATION"),
            text: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerText(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerTitle(string: ".02 SCOPE OF APPLICATION"),
            text: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerText(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerTitle(string: ".03 SCOPE OF APPLICATION"),
            text: AttributedString.Sidebar.SideBarItems.DataPrivacy.headerText(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        )
    ]
}

private var mockAboutItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Sidebar.SideBarItems.AboutTignum.headerSubTitle(string: "Lorem ispum text here more and more")
        ),

        .image(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.headerSubTitle(string: "Why"),
            text: AttributedString.Sidebar.SideBarItems.AboutTignum.text(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.headerSubTitle(string: "What"),
            text: AttributedString.Sidebar.SideBarItems.AboutTignum.text(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .image(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://cdn.pixabay.com/photo/2011/01/17/18/03/iguana-4612_960_720.jpg")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.headerSubTitle(string: "How"),
            text: AttributedString.Sidebar.SideBarItems.AboutTignum.text(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .shareAction(
            title: AttributedString.Sidebar.SideBarItems.AboutTignum.shareText(string: "Share")
        )
    ]
}
