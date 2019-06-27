//
//  ThoughtsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

import UIKit
import qot_dal

final class ThoughtsWorker {

    // MARK: - Functions

    func listOfThoughts(completion: @escaping (([String?]) -> Void)) {
        qot_dal.ContentService.main.getContentItemsByCollectionId(101282, { (items) in
            var thoughts = [String]()
                for i in items! {
                thoughts.append(i.valueText)
                }
            completion(thoughts)
        })
    }

    func listOfAuthors(completion: @escaping (([String?]) -> Void)) {
        qot_dal.ContentService.main.getContentItemsByCollectionId(101283, { (items) in
            var authors = [String]()
            for i in items! {
                authors.append(i.valueText)
            }
            completion(authors)
        })
    }
}
