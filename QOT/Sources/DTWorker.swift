//
//  DTWorker.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class DTWorker: WorkerTBV {

    // MARK: - Questions
    func getQuestions(questionGroup: QuestionGroup, _ completion: @escaping ([QDMQuestion]?) -> Void) {
        QuestionService.main.questionsWithQuestionGroup(questionGroup, ascending: true) { (questions) in
            completion(questions)
        }
    }

    func getContent(contentId: Int, completion: @escaping (QDMContentCollection?) -> Void) {
        ContentService.main.getContentCollectionById(contentId) { (content) in
            completion(content)
        }
    }

    func getCriticalPreparations(_ completion: @escaping ([QDMUserPreparation]) -> Void) {
        UserService.main.getUserPreparations { (preparations, _, error) in
            if let error = error {
                log("Error while getting preparations with error: \(error)", level: .error)
            }
            let criticalPreparations = preparations?.filter { $0.type == QDMUserPreparation.Level.LEVEL_CRITICAL }
            completion(criticalPreparations ?? [])
        }
    }
}
