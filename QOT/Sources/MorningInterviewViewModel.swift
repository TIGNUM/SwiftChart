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

    init(questions: AnyRealmCollection<Question>) {
        self.questions = questions
    }

    var questionsCount: Int {
        return questions.count
    }

    func question(at index: Index) -> Question {
        return questions[index]
    }
}
