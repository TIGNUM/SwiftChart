//
//  PDFReaderWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 28.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PDFReaderWorker {

    // MARK: - Public

    enum Result {
        case success(Share.ContentItem)
        case failure(Error)
    }

    // MARK: - Properties

    private let networkManager: NetworkManager
    private let contentItemID: Int

    init(networkManager: NetworkManager, contentItemID: Int) {
        self.networkManager = networkManager
        self.contentItemID = contentItemID
    }

    func prepareShareContent(completion: @escaping ((Result) -> Void)) {
        self.networkManager.performContentItemSharingRequest(contentItemID: contentItemID) { (result) in
            switch result {
            case .success(let value):
                let content = Share.ContentItem(title: value.title, url: value.url, body: value.body)
                completion(.success(content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func contentItemId() -> Int {
        return contentItemID
    }
}
