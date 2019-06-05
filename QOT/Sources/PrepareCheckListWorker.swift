//
//  PrepareCheckListWorker.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListWorker {

    // MARK: - Properties

    private let services: Services
    private let contentID: Int

    private lazy var content: ContentCollection? = {
        return services.contentService.contentCollection(id: contentID)
    }()

    private lazy var items: [PrepareCheckListModel] = {
        var items = [PrepareCheckListModel]()
        content?.items.forEach {
            items.append(PrepareCheckListModel(itemFormat: ContentItemFormat(rawValue: $0.format),
                                               title: $0.valueText))
        }
        return items
    }()

    // MARK: - Init

    init(services: Services, contentID: Int) {
        self.services = services
        self.contentID = contentID
    }
}

extension PrepareCheckListWorker {
    var rowCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> PrepareCheckListModel {
        return items[indexPath.row]
    }

    func attributedText(title: String?, itemFormat: ContentItemFormat?) -> NSAttributedString? {
        guard let title = title, let itemFormat = itemFormat else { return nil }
        switch itemFormat {
        case .textH1: return attributed(text: title, font: .sfProDisplayLight(ofSize: 24), textColor: .carbon)
        case .textH2,
             .listItem: return attributed(text: title, font: .sfProtextLight(ofSize: 16), textColor: UIColor.carbon.withAlphaComponent(0.7))
        case .list: return attributed(text: "\n\n"+title, font: .sfProtextMedium(ofSize: 14), textColor: UIColor.carbon.withAlphaComponent(0.4))
        case .title: return attributed(text: title, font: .sfProtextLight(ofSize: 16), textColor: .carbon)
        default: return nil
        }
    }

    func rowHeight(at indexPath: IndexPath) -> CGFloat {
        guard let format = item(at: indexPath).itemFormat else { return 0 }
        switch format {
        case .textH1: return 68
        case .textH2: return 20
        case .list: return 80
        case .title: return 64
        case .listItem: return 48
        default: return 0
        }
    }

    func hasListMark(at indexPath: IndexPath) -> Bool {
        guard let format = item(at: indexPath).itemFormat else { return false }
        switch format {
        case .listItem: return true
        default: return false
        }
    }

    func hasBottomSeperator(at indexPath: IndexPath) -> Bool {
        guard let format = item(at: indexPath).itemFormat else { return false }
        switch format {
        case .title: return true
        default: return false
        }
    }

    func hasHeaderMark(at indexPath: IndexPath) -> Bool {
        guard let format = item(at: indexPath).itemFormat else { return false }
        switch format {
        case .textH1: return true
        default: return false
        }
    }
}

private extension PrepareCheckListWorker {
    func attributed(text: String, font: UIFont, textColor: UIColor) -> NSAttributedString? {
        return NSAttributedString(string: text,
                                  font: font,
                                  textColor: textColor,
                                  alignment: .left)
    }
}
