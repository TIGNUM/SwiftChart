//
//  ThoughtsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//
import qot_dal
import Foundation

protocol ThoughtsViewControllerInterface: class {
}

protocol  ThoughtsPresenterInterface {
}

protocol  ThoughtsInteractorInterface: Interactor {
    func listOfThoughts(completion: @escaping (([String?]) -> Void))
    func listOfAuthors(completion: @escaping (([String?]) -> Void))
}

protocol ThoughtsRouterInterface {

}
