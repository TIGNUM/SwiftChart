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
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem ipsum 26 items")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: AttributedString.Learn.headerSubtitle(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: AttributedString.Learn.headerSubtitle(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        )
    ]
}

private var mockBenefitItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem ipsum 26 items")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: AttributedString.Learn.headerSubtitle(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: AttributedString.Learn.headerSubtitle(string: "How to create your optimal performance state (2:26)")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Learn.headerTitle(string: "OPTIMAL PERFORMANCE STATE"),
            text: AttributedString.Learn.headerSubtitle(string: "Performance Mindset")
        )
    ]
}

private var mockPrivacyItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: ".01 SCOPE OF APPLICATION"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: ".02 SCOPE OF APPLICATION"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: ".03 SCOPE OF APPLICATION"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        )
    ]
}

private var mockAboutItems: [SidebarItem] {
    return [
        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "LOREM IPSUMOP TEXT ONESOIP TWO LINES"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem ispum text here more and more")
        ),

        .image(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "Why"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .video(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "What"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        ),

        .image(
            localID: UUID().uuidString,
            placeholderURL: URL(string:"https://example.com")!,
            description: nil
        ),

        .text(
            localID: UUID().uuidString,
            title: AttributedString.Sidebar.Benefits.headerTitle(string: "How"),
            text: AttributedString.Learn.headerSubtitle(string: "Lorem Ipsum text  is about bringing your best to those critical events that matter most to you. In each of these events, the demands on you and your mindset will be different. In order to optimize your effectiveness you will have to be in your optimal performance state.")
        )
    ]
}
