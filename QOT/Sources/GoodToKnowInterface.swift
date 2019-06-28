//
//  GoodToKnowInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 25.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import qot_dal
import Foundation

protocol GoodToKnowViewControllerInterface: class {
}

protocol  GoodToKnowPresenterInterface {
}

protocol  GoodToKnowInteractorInterface: Interactor {
    func listOfFacts(completion: @escaping (([String?]) -> Void))
    func listOfPictures(completion: @escaping (([String?]) -> Void))
}

protocol GoodToKnowRouterInterface {

}
