//
//  MorningInterviewProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol MorningInterviewViewControllerInterface: class {
    func setQuestions(_ questions: [MorningInterview.Question])
}

protocol MorningInterviewPresenterInterface {
    func presentQuestions(_ questions: [MorningInterview.Question])
}

protocol MorningInterviewInteractorInterface: Interactor {
    func saveAnswers(questions: [MorningInterview.Question])
}

protocol MorningInterviewRouterInterface {
    func close()
}
