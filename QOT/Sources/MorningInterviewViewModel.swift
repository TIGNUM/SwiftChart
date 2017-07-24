//
//  File.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/28/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class MorningInterviewViewModel: NSObject {

    fileprivate let questions: AnyRealmCollection<Question>

    init(services: Services, questionGroupID: Int) {
        self.questions = services.questionsService.morningInterviewQuestions(questionGroupID: questionGroupID)
    }

    var questionsCount: Int {
        return questions.count
    }

    func question(at index: Index) -> Question {
        return questions[index]
    }
}
