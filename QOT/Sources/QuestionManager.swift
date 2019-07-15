//
//  QuestionManager.swift
//  QOT
//
//  Created by karmic on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class QuestionManager {

    private let questionService: qot_dal.QuestionService?
    static var main = QuestionManager()

    private init() {
        self.questionService = qot_dal.QuestionService.main
    }
}

extension QuestionManager {
    func fetchQuestions(for type: DecisionTreeType, completion: @escaping ([QDMQuestion]?) -> Void) {
        questionService?.questionsWithQuestionGroup(type.questionGroup, ascending: true, completion)
    }
}

