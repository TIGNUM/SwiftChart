//
//  DTWorker.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class DTWorker: TBVWorker {

    // MARK: - Properties
    lazy var contentService = ContentService.main
    lazy var questionService = QuestionService.main
    lazy var userService = UserService.main

    // MARK: - Questions
    func getQuestions(questionGroup: QuestionGroup, _ completion: @escaping ([QDMQuestion]?) -> Void) {
        questionService.questionsWithQuestionGroup(questionGroup, ascending: true) { (questions) in
            completion(questions)
        }
    }
}
