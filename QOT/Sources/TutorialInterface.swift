//
//  TutorialInterface.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol TutorialViewControllerInterface: class {
    func setup()
}

protocol TutorialPresenterInterface {
    func setup()
}

protocol TutorialInteractorInterface: Interactor {
    var numberOfSlides: Int { get }
    func dismiss()
    func title(at index: Index) -> String?
    func subtitle(at index: Index) -> String?
    func body(at index: Index) -> String?
    func imageURL(at index: Index) -> URL?
    func attributedbuttonTitle(at index: Index, for origin: TutorialOrigin) -> NSAttributedString
}

protocol TutorialRouterInterface {
    func dismiss()
}
