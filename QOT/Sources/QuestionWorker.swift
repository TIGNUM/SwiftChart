//
//  QuestionWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

import UIKit
import qot_dal

final class QuestionWorker {

    // MARK: - Functions

    func randomQuestion(completion: @escaping ((String?) -> Void)) {
        qot_dal.ContentService.main.getContentItemsByCollectionId(101281, { (items) in
            completion(items?.randomElement()?.valueText)
        })
    }
}
