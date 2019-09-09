//
//  PDFReaderWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PDFReaderWorker {

    // MARK: - Public

    enum Result {
        case success(Share.ContentItem)
        case failure(Error)
    }

    // MARK: - Properties

    private let contentItemID: Int

    init(contentItemID: Int) {
        self.contentItemID = contentItemID
    }

    func prepareShareContent(completion: @escaping ((Result) -> Void)) {
        qot_dal.ContentService.main.getContentItemShareData(contentItemId: contentItemID) { (shareData, error) in
            guard let value = shareData else {
                completion(.failure(error ?? NSError(domain: "QOT", code: 500, userInfo: nil) ))
                return
            }

            let content = Share.ContentItem(title: value.title ?? "", url: value.url ?? "", body: value.body ?? "")
            completion(.success(content))
        }
    }

    func contentItemId() -> Int {
        return contentItemID
    }
}
