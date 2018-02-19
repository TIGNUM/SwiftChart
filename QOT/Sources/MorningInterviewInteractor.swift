//
//  MorningInterviewInteractor.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class MorningInterviewInteractor: MorningInterviewInteractorInterface {

    let presenter: MorningInterviewPresenterInterface
    let worker: MorningInterviewWorker

    init(presenter: MorningInterviewPresenterInterface, worker: MorningInterviewWorker) {
        self.worker = worker
        self.presenter = presenter
    }

    func viewDidLoad() {
        presenter.presentQuestions(worker.questions())
    }

    func saveAnswers(questions: [MorningInterview.Question]) {
        worker.saveAnswers(questions: questions)
    }
}
