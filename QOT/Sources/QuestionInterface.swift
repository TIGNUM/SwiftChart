//
//  QuestionInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol QuestionViewControllerInterface: class {
}

protocol  QuestionPresenterInterface {
}

protocol  QuestionInteractorInterface: Interactor {
    func randomQuestion(completion: @escaping ((String?) -> Void))
}

protocol  QuestionRouterInterface {

}
