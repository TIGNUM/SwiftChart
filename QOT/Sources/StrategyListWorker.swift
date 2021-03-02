//
//  StrategyListWorker.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class StrategyListWorker {

    // MARK: - Properties

    private let selectedStrategyID: Int?
    weak var interactor: StrategyListInteractorInterface?

    func headerTitle() -> String {
        if isFoundation == true {
            return AppTextService.get(.know_section_strategies_title_foundation).lowercased().capitalizingFirstLetter()
        }
        return selectedStrategy?.title ?? ""
    }

    lazy var isFoundation: Bool = {
        return selectedStrategyID == nil
    }()

    var rowCount: Int {
        if isFoundation == true {
            return foundationStrategies.count
        }
        return strategies.count
    }

    private var selectedStrategy: QDMContentCategory?

    private lazy var contentList: [QDMContentCollection] = {
        guard let contentList = selectedStrategy?.contentCollections else { return [] }
        return Array(contentList).filter { $0.section == .LearnStrategies }
    }()

    // MARK: - Init

    init(selectedStrategyID: Int?) {
        self.selectedStrategyID = selectedStrategyID
        loadStrategies()
    }

    var foundationStrategies = [Strategy.Item]()

    var strategies = [Strategy.Item]()
    func selectedStrategyId() -> Int {
        return selectedStrategyID ?? .zero
    }

    func loadStrategies() {
        ContentService.main.getContentCategory(.PerformanceFoundation) { [weak self] (foundation) in
            var items = [Strategy.Item]()
            for contentCollection in foundation?.contentCollections.filter({ (collection) -> Bool in
                collection.section == .LearnStrategies
            }) ?? [] {
                let foundationItem = contentCollection.contentItems.filter { $0.format == .video }.first
                let imageURL = URL(string: foundationItem?.valueImageURL ?? "")
                items.append(Strategy.Item(remoteID: contentCollection.remoteID ?? .zero,
                                           categoryTitle: contentCollection.contentCategoryTitle ?? "",
                                           title: contentCollection.title,
                                           imageURL: imageURL,
                                           mediaItem: foundationItem,
                                           contentItems: contentCollection.contentItems,
                                           valueDuration: contentCollection.secondsRequired,
                                           isRead: contentCollection.viewedAt != nil))
            }
            self?.foundationStrategies = items
        }

        ContentService.main.getContentCategoryById(selectedStrategyID ?? .zero) { [weak self] (qdmCategory) in
            self?.selectedStrategy = qdmCategory
            let learnContentList = qdmCategory?.contentCollections.filter({ (content) -> Bool in
                content.section == .LearnStrategies
            })
            var items = [Strategy.Item]()
            learnContentList?.forEach { (contentCollection) in
                let title = contentCollection.title
                let firstAudioItem = contentCollection.contentItems.filter { $0.format == .audio }.first
                items.append(Strategy.Item(remoteID: contentCollection.remoteID ?? .zero,
                                           categoryTitle: contentCollection.contentCategoryTitle ?? "",
                                           title: title,
                                           imageURL: nil,
                                           mediaItem: firstAudioItem,
                                           contentItems: contentCollection.contentItems,
                                           valueDuration: Int(firstAudioItem?.valueDuration ?? .zero),
                                           isRead: contentCollection.viewedAt != nil ))
            }
            self?.strategies = items
            self?.interactor?.reloadData()
        }
    }
}
