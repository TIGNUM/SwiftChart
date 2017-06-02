//
//  SearchFieldViewModel.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/24/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SearchViewModel {

    var headerItems: [String] {
        return headerBarItems()
    }

    var data: [SearchFieldViewModelItem] {
        return mockData()
    }

    private func headerBarItems() -> [String] {
        return [
            "ALL",
            "TEXT",
            "VIDEO",
            "AUDIO",
            "ALL",
            "TEXT",
            "VIDEO",
            "AUDIO"
        ]
    }

    private func mockData() -> [MockSearchFieldViewModelItem] {

        return [
            MockSearchFieldViewModelItem.init(title: "LEVERAGE STRESS BENEFITS", subtitle: "Audio", duration: "5 MIN TO LISTEN"),
            MockSearchFieldViewModelItem.init(title: "LOREM IPSUM PASTA ONE YU", subtitle: "TEXT", duration: "THE ONLY WAY"),
            MockSearchFieldViewModelItem.init(title: "WE WORK BETTER", subtitle: "VIDEO", duration: "5 MINUTES TO WATCH"),
            MockSearchFieldViewModelItem.init(title: "LOREM IPSUM PASTA ONE YU", subtitle: "TEXT", duration: "THE ONLY WAY"),
            MockSearchFieldViewModelItem.init(title: "LEVERAGE STRESS BENEFITS", subtitle: "Audio", duration: "5 MIN TO LISTEN"),
            MockSearchFieldViewModelItem.init(title: "WE WORK BETTER", subtitle: "VIDEO", duration: "5 MINUTES TO WATCH"),
            MockSearchFieldViewModelItem.init(title: "LEVERAGE STRESS BENEFITS", subtitle: "Audio", duration: "5 MIN TO LISTEN")
        ]
    }
}

protocol SearchFieldViewModelItem {
    var title: String { get }
    var subtitle: String { get }
    var duration: String { get }
}

struct MockSearchFieldViewModelItem: SearchFieldViewModelItem {
    var title: String
    var subtitle: String
    var duration: String
}
