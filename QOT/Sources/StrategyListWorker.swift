//
//  StrategyListWorker.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListWorker {

    // MARK: - Properties

    let services: Services
    private let selectedStrategyID: Int?

    lazy var headerTitle: String = {
        if isFoundation == true {
            return LearnContentTitle.foundation.rawValue
        }
        return selectedStrategy?.title ?? ""
    }()

    lazy var isFoundation: Bool = {
        return selectedStrategyID == nil
    }()

    var rowCount: Int {
        if isFoundation == true {
            return foundationStrategies.count
        }
        return strategies.count
    }

    private lazy var selectedStrategy: ContentCategory? = {
        return services.contentService.contentCategory(id: selectedStrategyID ?? 0)
    }()

    private lazy var contentList: [ContentCollection] = {
        guard let contentList = selectedStrategy?.contentCollections else { return [] }
        return Array(contentList).filter { $0.section == Database.Section.learnStrategy.value }
    }()

    // MARK: - Init

    init(services: Services, selectedStrategyID: Int?) {
        self.services = services
        self.selectedStrategyID = selectedStrategyID
    }

    lazy var foundationStrategies: [Strategy.Item] = {
        var items = [Strategy.Item]()
        services.contentService.learnStrategiesFoundation().forEach { (contentCollection) in
            let title = contentCollection.title.replacingOccurrences(of: "Performance ", with: "")
            let foundationItem = contentCollection.articleItems.filter { $0.format == "video" }.first
            let imageURL = URL(string: foundationItem?.valueImageURL ?? "")
            let mediaURL = URL(string: foundationItem?.valueMediaURL ?? "")
            items.append(Strategy.Item(remoteID: contentCollection.remoteID.value ?? 0,
                                       categoryTitle: contentCollection.contentCategories.first?.title ?? "",
                                       title: title,
                                       durationString: foundationItem?.durationString ?? "",
                                       imageURL: imageURL,
                                       mediaURL: mediaURL,
                                       duration: 0))
        }
        return items
    }()

    lazy var strategies: [Strategy.Item] = {
        guard let selectedID = selectedStrategyID else { return [] }
        let learnContentList = services.contentService.contentCollections(categoryID: selectedID).filter { $0.section == Database.Section.learnStrategy.value }
        var items = [Strategy.Item]()
        learnContentList.forEach { (contentCollection) in
            let title = contentCollection.title.replacingOccurrences(of: "Performance ", with: "")
            let firstAudioItem = contentCollection.articleItems.filter { $0.format == "audio" }.first
            items.append(Strategy.Item(remoteID: contentCollection.remoteID.value ?? 0,
                                       categoryTitle: contentCollection.contentCategories.first?.title ?? "",
                                       title: title,
                                       durationString: contentCollection.durationString,
                                       imageURL: nil,
                                       mediaURL: URL(string: (firstAudioItem?.valueMediaURL ?? "")),
                                       duration: firstAudioItem?.valueDuration.value ?? 0))
        }
        return items
    }()
}
