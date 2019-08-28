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
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
}

protocol DailyBriefPresenterInterface {
    func setupView()
    func updateView(_ differenceList: StagedChangeset<[BaseDailyBriefViewModel]>)
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>)
}

protocol DailyBriefInteractorInterface: Interactor {
    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>])
    func updateViewModelList(_ list: [BaseDailyBriefViewModel])
    var rowCount: Int { get }
    var rowViewModelCount: Int { get }
    var rowViewSectionCount: Int { get }
    var shpiAnswer: QDMDailyCheckInAnswer? { get }
    var peakPerformanceCount: Int? { get }
    var lastEstimatedLevel: Int? { get }
    func bucket(at row: Int) -> QDMDailyBriefBucket?
    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel?
    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]?
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
    func saveUpdatedDailyCheckInSleepTarget(_ value: Double)
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func saveTargetValue(value: Int?)
    func showSolveResults(solve: QDMSolve)
    func showDailyCheckIn()
    func showPrepareScreen()
    func presentCopyRight(copyrightURL: String?)
}

protocol DailyBriefRouterInterface {
    func presentWhatsHotArticle(selectedID: Int)
    func presentMyToBeVision()
    func showCustomizeTarget(_ data: RatingQuestionViewModel.Question?)
    func presentStrategyList(selectedStrategyID: Int)
    func presentToolsItems(selectedToolID: Int?)
    func showSolveResults(solve: QDMSolve)
    func showDailyCheckIn()
    func presentCopyRight(copyrightURL: String?)
}
