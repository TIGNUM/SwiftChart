//
//  DailyBriefInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DailyBriefViewControllerInterface: class {
}

protocol DailyBriefPresenterInterface {
}

protocol DailyBriefInteractorInterface: Interactor {
    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void))
    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void))
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void))
    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void)
    func createFactsModel(completion: @escaping ((GoodToKnowCellViewModel)?) -> Void)
    func randomQuestionModel(completion: @escaping ((QuestionCellViewModel)?) -> Void)
    func lastMessage(completion: @escaping ((FromTignumCellViewModel)?) -> Void)
    func createThoughtsModel(completion: @escaping ((ThoughtsCellViewModel)?) -> Void)
    func getDepartureModel(completion: @escaping ((DepartureInfoCellViewModel)?) -> Void)
    func presentWhatsHotArticle(selectedID: Int)
    func getFeastModel(completion: @escaping ((FeastCellViewModel)?) -> Void)
}

protocol DailyBriefRouterInterface {
    func presentWhatsHotArticle(selectedID: Int)
}
