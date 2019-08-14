//
//  DailyBriefInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import DifferenceKit

protocol DailyBriefViewControllerInterface: class {
    func setupView()
    func updateView(_ differenceList: StagedChangeset<[BaseDailyBriefViewModel]>)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateView(_ differenceList: StagedChangeset<[BaseDailyBriefViewModel]>)
}

protocol DailyBriefInteractorInterface: Interactor {
    func updateViewModelList(_ list: [BaseDailyBriefViewModel])
    var rowCount: Int { get }
    var rowViewModelCount: Int { get }
    var shpiAnswer: QDMDailyCheckInAnswer? { get }
    var peakPerformanceCount: Int? { get }
    var lastEstimatedLevel: Int? { get }
    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel?
    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void))
    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void))
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void))
    func presentWhatsHotArticle(selectedID: Int)
    func presentMyToBeVision()
    func getToBeVisionImage(completion: @escaping (URL?) -> Void)
    func presentStrategyList(selectedStrategyID: Int)
    func presentToolsItems(selectedToolID: Int?)
    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void)
    func showCustomizeTarget()
    func getDailyBriefBucketsForViewModel()
    func saveAnswerValue(_ value: Int)
    func saveUpdateGetToLevel5Selection(_ value: Int)
    func getReferenceValues(completion: @escaping ([String]?) -> Void)
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func saveTargetValue(value: Int?)
}

protocol DailyBriefRouterInterface {
    func presentWhatsHotArticle(selectedID: Int)
    func presentMyToBeVision()
    func showCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func presentStrategyList(selectedStrategyID: Int)
    func presentToolsItems(selectedToolID: Int?)
}
