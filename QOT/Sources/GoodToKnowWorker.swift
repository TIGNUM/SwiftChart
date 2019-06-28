//
//  GoodToKnowWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class GoodToKnowWorker {

    // MARK: - Functions

    func listOfFacts(completion: @escaping (([String?]) -> Void)) {
        qot_dal.ContentService.main.getContentItemsByCollectionId(101285, { (items) in
            var facts = [String]()
            for i in items! {
                facts.append(i.valueText)
            }
            completion(facts)
        })
    }

    func listOfPictures(completion: @escaping (([String?]) -> Void)) {
        qot_dal.ContentService.main.getContentItemsByCollectionId(101286, { (items) in
            var pictures = [String?]()
            for i in items! {
                pictures.append(i.valueMediaURL)
            }
            completion(pictures)
        })
    }

}
