//
//  DailyBriefInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import DifferenceKit

public extension Notification.Name {
    static let scrollToBucket = Notification.Name("scrollToBucket")
}

final class DailyBriefInteractor {

    // MARK: - Properties
    private let worker: DailyBriefWorker
    private let presenter: DailyBriefPresenterInterface
    private let router: DailyBriefRouterInterface
    private var viewModelOldList: [BaseDailyBriefViewModel] = []
    private var viewModelOldListModels: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
    private var expendImpactReadiness: Bool = false
// Boolean to keep track of the guided closed track.
    private var guidedClosedTrack: Bool = false
    private var isLoadingBuckets: Bool = false
    private var needToLoadBuckets: Bool = false

    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // MARK: - Init

    init(worker: DailyBriefWorker,
         presenter: DailyBriefPresenterInterface,
         router: DailyBriefRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router

        // Listen about UpSync Daily Check In User Answers
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDataSyncRequest(_ :)),
                                               name: .requestSynchronization, object: nil)

        // Listen about Expend/Collapse
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImpactReadinessCellSizeChanges(_ :)),
                                               name: .dispayDailyCheckInScore, object: nil)

        // Listen about Expend/Collapse of Closed Guided Track
        NotificationCenter.default.addObserver(self, selector: #selector(didGuidedClosedCellSizeChanges(_ :)),
                                               name: .displayGuidedTrackRows, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didGetScrollNotificationToBucket(_ :)),
                                               name: .scrollToBucket, object: nil)

        getDailyBriefBucketsForViewModel()
    }
    func viewDidLoad() {
        presenter.setupView()
        NotificationCenter.default.post(name: .requestSynchronization, object: nil)
    }
}

// MARK: Private methods
extension DailyBriefInteractor {
    private func setVisibleBucketsAsSeenIfNeeded(indexPath: IndexPath) {
        let bucketModel = bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        if let bucketList = bucketList,
            bucketList.count > indexPath.row {
            if let bucket = bucketList[indexPath.row].domainModel {
                DailyBriefService.main.markAsSeenBuckets([bucket])
            }
        }
    }
}

// MARK: Notification Listeners
extension DailyBriefInteractor {
    @objc func didGetDataSyncRequest(_ notification: Notification) {
        guard let request = notification.object as? SyncRequestContext,
            request.dataType == .DAILY_CHECK_IN,
            request.syncRequestType == .UP_SYNC else { return }
        expendImpactReadiness = true
        updateDailyBriefBucket()
    }

    @objc func didGetImpactReadinessCellSizeChanges(_ notification: Notification) {
        expendImpactReadiness = !expendImpactReadiness
        updateDailyBriefBucket()
    }
//  Display the expand/collapse of the guided close track
    @objc func didGuidedClosedCellSizeChanges(_ notification: Notification) {
        guidedClosedTrack = !guidedClosedTrack
        updateDailyBriefBucket()
    }

    @objc func didGetScrollNotificationToBucket(_ notification: Notification) {
        guard let bucketName = notification.object as? DailyBriefBucketName else { return }
        switch bucketName {
        default:
            // @Srikanth, Zeljko : We need to scroll to the bucket.
            qot_dal.log("did get scroll notification to bucket: \(bucketName)", level: .info)
        }
    }
}

// MARK: - DailyBriefInteractorInterface

extension DailyBriefInteractor: DailyBriefInteractorInterface {
    // MARK: Properties

    var rowViewModelCount: Int {
        return viewModelOldList.count
    }

    var rowViewSectionCount: Int {
        return viewModelOldListModels.count
    }

    var shpiAnswer: QDMDailyCheckInAnswer? {
        return worker.shpiAnswer
    }

    var peakPerformanceCount: Int? {
        return worker.peakPerformanceCount
    }

    // MARK: Retrieve methods

    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return worker.bucket(at: row)
    }

    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel? {
        return viewModelOldList.at(index: row)
    }

    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]? {
        return viewModelOldListModels
    }

    func getDailyBriefBucketsForViewModel() {
        if isLoadingBuckets {
            needToLoadBuckets = true
        }

        isLoadingBuckets = true
        var sectionDataList: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
        worker.getDailyBriefBucketsForViewModel { [weak self] (bucketsList) in
            guard let strongSelf = self else {
                return
            }
            bucketsList.forEach { [weak self] (bucket) in
                guard let strongSelf = self else {
                    return
                }
                switch bucket.bucketName {
                case .DAILY_CHECK_IN_1?:
                    sectionDataList.append(ArraySection(model: .dailyCheckIn1,
                                                        elements: strongSelf.createImpactReadinessCell(impactReadinessBucket: bucket)))
                case .DAILY_CHECK_IN_2?:
                    sectionDataList.append(ArraySection(model: .dailyCheckIn2,
                                                        elements: strongSelf.createDailyCheckIn2(dailyCheckIn2Bucket: bucket)))
                case .EXPLORE?:
                    sectionDataList.append(ArraySection(model: .explore,
                                                        elements: strongSelf.createExploreModel(exploreBucket: bucket)))
                case .ME_AT_MY_BEST?:
                    sectionDataList.append(ArraySection(model: .meAtMyBest,
                                                        elements: strongSelf.createMeAtMyBest(meAtMyBestBucket: bucket)))
                case .GET_TO_LEVEL_5?:
                    sectionDataList.append(ArraySection(model: .getToLevel5,
                                                        elements: strongSelf.createLevel5Cell(level5Bucket: bucket)))
                case .QUESTION_WITHOUT_ANSWER?:
                    sectionDataList.append(ArraySection(model: .questionWithoutAnswer,
                                                        elements: strongSelf.createQuestionsWithoutAnswer(questionsWithoutAnswerBucket: bucket)))
                case .LATEST_WHATS_HOT?:
                    sectionDataList.append(ArraySection(model: .whatsHotLatest,
                                                        elements: strongSelf.createLatestWhatsHot(whatsHotLatestCell: bucket)))
                case .THOUGHTS_TO_PONDER?:
                    sectionDataList.append(ArraySection(model: .thoughtsToPonder,
                                                        elements: strongSelf.createThoughtsToPonder(thoughtsToPonderBucket: bucket)))
                case .GOOD_TO_KNOW?:
                    sectionDataList.append(ArraySection(model: .goodToKnow,
                                                        elements: strongSelf.createGoodToKnow(createGoodToKnowBucket: bucket)))
                case .FROM_TIGNUM?:
                    sectionDataList.append(ArraySection(model: .fromTignum,
                                                        elements: strongSelf.createFromTignum(fromTignum: bucket)))
                case .BESPOKE?:
                    sectionDataList.append(ArraySection(model: .bespoke,
                                                        elements: strongSelf.createBeSpokeModel(beSpokeModelBucket: bucket)))
                case .DEPARTURE_INFO?:
                    sectionDataList.append(ArraySection(model: .departureInfo,
                                                        elements: strongSelf.createDepatureInfo(depatureInfoBucket: bucket)))
                case .LEADERS_WISDOM?:
                    sectionDataList.append(ArraySection(model: .leaderswisdom,
                                                        elements: strongSelf.createLeaderWisdom(createLeadersWisdom: bucket)))
                case .FEAST_OF_YOUR_EYES?:
                    sectionDataList.append(ArraySection(model: .feastForYourEyes,
                                                        elements: strongSelf.createFeastForEyesModel(feastForEyesBucket: bucket)))
                case .FROM_MY_COACH?:
                    sectionDataList.append(ArraySection(model: .fromMyCoach,
                                                        elements: strongSelf.createFromMyCoachModel(fromCoachBucket: bucket)))
                case .MY_PEAK_PERFORMANCE?:
                    let elements = strongSelf.createMyPeakPerformanceModel(myPeakPerformanceBucket: bucket)
                    if elements.count > 0 {
                        sectionDataList.append(ArraySection(model: .myPeakPerformance, elements: elements))
                    }
                case .SPRINT_CHALLENGE?:
                    if bucket.sprint != nil {
                        sectionDataList.append(ArraySection(model: .sprint,
                                                            elements: strongSelf.createSprintChallenge(bucket: bucket)))
                    }
                case .ABOUT_ME?:
                    sectionDataList.append(ArraySection(model: .aboutMe,
                                                        elements: strongSelf.createAboutMe(aboutMeBucket: bucket)))
                case .SOLVE_REFLECTION?:
                    sectionDataList.append(ArraySection(model: .solveReflection,
                                                        elements: strongSelf.createSolveViewModel(bucket: bucket)))
                case .WEATHER?:
                    sectionDataList.append(ArraySection(model: .weather,
                                                        elements: strongSelf.createWeatherViewModel(weatherBucket: bucket)))
                case .GUIDE_TRACK?:
                    sectionDataList.append(ArraySection(model: .guidedTrack,
                                                        elements: strongSelf.createGuidedTrack(guidedTrackBucket: bucket)))
                default:
                    print("Default : \(bucket.bucketName ?? "" )")
                }
            }
            let changeSet = StagedChangeset(source: strongSelf.viewModelOldListModels, target: sectionDataList)
            strongSelf.presenter.updateViewNew(changeSet)
            strongSelf.isLoadingBuckets = false
            if strongSelf.needToLoadBuckets {
                strongSelf.needToLoadBuckets = false
                strongSelf.getDailyBriefBucketsForViewModel()
            }
        }
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        worker.getToBeVisionImage(completion: completion)
    }

    // MARK: Present methods

    func presentMyDataScreen() {
        router.presentMyDataScreen()
    }

    func presentWhatsHotArticle(selectedID: Int) {
        router.presentWhatsHotArticle(selectedID: selectedID)
    }

    func presentMyToBeVision() {
        router.presentMyToBeVision()
    }

    func presentStrategyList(selectedStrategyID: Int) {
        router.presentStrategyList(selectedStrategyID: selectedStrategyID)
    }

    func presentToolsItems(selectedToolID: Int?) {
        router.presentToolsItems(selectedToolID: selectedToolID)
    }

    func presentCopyRight(copyrightURL: String?) {
        router.presentCopyRight(copyrightURL: copyrightURL)
    }

    func openGuidedTrackAppLink(_ appLink: QDMAppLink?) {
        router.openGuidedTrackAppLink(appLink)
    }

    func showSolveResults(solve: QDMSolve) {
        router.showSolveResults(solve: solve)
    }

    func showCustomizeTarget() {
        worker.customzieSleepQuestion { [weak self] (model) in
            self?.router.showCustomizeTarget(model)
        }
    }

    func displayCoachPreparationScreen() {
        router.displayCoachPreparationScreen()
    }

    // MARK: Save methods

    func saveAnswerValue(_ value: Int) {
        worker.saveAnswerValue(value)
    }

    func saveUpdatedDailyCheckInSleepTarget(_ value: Double) {
        _ = self.viewModelOldList.filter { $0.domainModel?.bucketName == .DAILY_CHECK_IN_1 }.first as? ImpactReadinessCellViewModel
        //        check this implementation
        //        bucketViewModel?.targetReferenceArray![0] = (60 + value * 30) * 5 / 60
    }

    func saveTargetValue(value: Int?) {
        worker.saveTargetValue(value: value)
    }

    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customzieSleepQuestion(completion: completion)
    }

    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]) {
        viewModelOldListModels = list
    }

    func updateDailyBriefBucket() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didUpdateDailyBriefBuckets, object: nil)
        }
    }

    func showQuestions() {
        worker.getQuestions{[weak self] (questions) in
            guard let finalQuestions = questions?.suffix(from: 1) else {return}
            self?.router.showQuestions(Array(finalQuestions))
        }
    }
}

extension DailyBriefInteractor {

    // MARK: Helpers
    func getSprintInfo(_ bucket: QDMDailyBriefBucket, _ tag1: String, _ tag2: String) -> String {
        return bucket.contentCollections?.filter {
            $0.searchTags.contains(tag1) && $0.searchTags.contains(tag2)
            }.first?.contentItems.first?.valueText ?? ""
    }

    func isNew(_ collection: QDMContentCollection) -> Bool {
        var isNewArticle = collection.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = collection.viewedAt == nil && collection.modifiedAt ?? collection.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }

    func didPressGotItSprint(sprint: QDMSprint) {
        worker.didPressGotItSprint(sprint: sprint)
    }

    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath) {
        forCell.setTimer(with: 3.0) { [weak self] in
            self?.setVisibleBucketsAsSeenIfNeeded(indexPath: indexPath)
        }
    }

    func invalidateTimer(forCell: BaseDailyBriefCell) {
        forCell.stopTimer()
    }

    // MARK: Create buckets models
    /**
     * Method name: createImpactReadinessCell.
     * Description: Create the impact readiness model which is required for the dailyCheck in Bucket.
     * Parameters: [QDMDailyBriefBucket]
     */
    func createImpactReadinessCell(impactReadinessBucket impactReadiness: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var impactReadinessList: [BaseDailyBriefViewModel] = []
        var readinessIntro: String? = ""
        var models: [ImpactReadinessScoreViewModel.ImpactDataViewModel] = []
        let responseIndex: Int = Int(impactReadiness.dailyCheckInResult?.impactReadiness?.rounded(.up) ?? 0)
        let impactReadinessImageURL = impactReadiness.toBeVision?.profileImageResource?.url()
        if impactReadiness.dailyCheckInResult?.impactReadiness == nil {
            readinessIntro = impactReadiness.bucketText?.contentItems.filter {$0.format == .paragraph}.first?.valueText
        } else { readinessIntro = impactReadiness.contentCollections?.filter {$0.searchTags.contains("impact_readiness_score")}
            .first?.contentItems.at(index: (responseIndex - 1))?.valueText
        }
        let bucketTitle = impactReadiness.bucketText?.contentItems.first?.valueText

//If the daily check in completed update the ImpactReadinessCellViewModel
        let readinessscore = Int(impactReadiness.dailyCheckInResult?.impactReadiness ?? -1)

        if impactReadiness.dailyCheckInAnswerIds?.isEmpty != false,
            impactReadiness.dailyCheckInResult == nil {
            expendImpactReadiness = false
        }

        impactReadinessList.append(ImpactReadinessCellViewModel.init(title: bucketTitle,
                                                                     dailyCheckImageURL: impactReadinessImageURL,
                                                                     readinessScore: readinessscore,
                                                                     readinessIntro: readinessIntro,
                                                                     domainModel: impactReadiness))
        let howYouFeelToday = impactReadiness.contentCollections?.filter {$0.searchTags.contains("rolling_data_intro")}.first?.contentItems.first?.valueText
        let asteriskText = impactReadiness.contentCollections?.filter {$0.searchTags.contains("additional")}.first?.contentItems.first?.valueText
        let sleepQuantity = impactReadiness.dailyCheckInResult?.fiveDaysSleepQuantity ?? 0
        let sleepQuality = min(impactReadiness.dailyCheckInResult?.fiveDaysSleepQuality ?? 0, 10)
        let load = impactReadiness.dailyCheckInResult?.fiveDaysload ?? 0
        let futureLoad = impactReadiness.dailyCheckInResult?.tenDaysFutureLoad ?? 0
        let targetSleepQuantity = impactReadiness.dailyCheckInResult?.targetSleepQuantity ?? 0
        let sleepQualityReference = impactReadiness.dailyCheckInResult?.sleepQualityReference ?? 0
        let loadReference = impactReadiness.dailyCheckInResult?.loadReference ?? 0
        let futureLoadReference = impactReadiness.dailyCheckInResult?.futureLoadReference ?? 0

        impactReadiness.contentCollections?.filter {$0.searchTags.contains("TITLE") }.forEach {(collection) in
            models.append(ImpactReadinessScoreViewModel.ImpactDataViewModel(title: collection.title,
                                                                            subTitle: collection.contentItems.first?.valueText))
        }
        if expendImpactReadiness {
            impactReadinessList.append(ImpactReadinessScoreViewModel.init(howYouFeelToday: howYouFeelToday,
                                                                          asteriskText: asteriskText,
                                                                          sleepQuantityValue: sleepQuantity,
                                                                          sleepQualityValue: sleepQuality,
                                                                          loadValue: load,
                                                                          futureLoadValue: futureLoad,
                                                                          targetSleepQuality: targetSleepQuantity,
                                                                          sleepQualityReference: sleepQualityReference,
                                                                          loadReference: loadReference,
                                                                          futureLoadReference: futureLoadReference,
                                                                          impactDataModels: models,
                                                                          domainModel: impactReadiness, "detail"))
        }

        return impactReadinessList
    }

    func createLevel5Cell(level5Bucket level5: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createLevel5List: [BaseDailyBriefViewModel] = []
        var levelMessageModels: [Level5ViewModel.LevelDetail] = []

        let title = level5.bucketText?.contentItems.first?.valueText ?? ""
        let intro = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("intro")}.first?.valueText ?? ""
        let question = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("question1")}.first?.valueText ?? ""
        let youRatedPart1 = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("you_rated_part1")}.first?.valueText ?? ""
        let youRatedPart2 = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("you_rated_part2")}.first?.valueText ?? ""
        let confirmationMessage =  level5.bucketText?.contentItems.filter {$0.searchTags.contains("LEVEL_5_CONFIRMATION_MESSAGE")}.first?.valueText ?? ""
        let level1Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_1")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
          let level1Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_1")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let comeBackText = level5.bucketText?.contentItems.filter {$0.searchTags.contains("COME_BACK")}.first?.valueText ?? "Noted! Come back in 1 month."
        var lastEstimatedLevel: Int?
        lastEstimatedLevel = level5.latestGetToLevel5Value
        var questionLevel: String?
        if lastEstimatedLevel != nil {
            questionLevel = youRatedPart1 + " " + String(lastEstimatedLevel ?? 0) + " " + youRatedPart2
        } else {
            questionLevel = question
        }
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level1Title, levelContent: level1Text))

        let level2Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_2")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level2Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_2")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level2Title, levelContent: level2Text))

        let level3Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_3")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level3Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_3")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level3Title, levelContent: level3Text))

        let level4Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_4")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level4Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_4")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level4Title, levelContent: level4Text))

        let level5Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_5")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level5Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_5")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level5Title, levelContent: level5Text))

        createLevel5List.append(Level5ViewModel(title: title,
                                                intro: intro,
                                                question: questionLevel,
                                                youRatedPart1: youRatedPart1,
                                                youRatedPart2: youRatedPart2,
                                                comeBackText: comeBackText,
                                                levelMessages: levelMessageModels,
                                                confirmationMessage: confirmationMessage,
                                                latestSavedValue: level5.latestGetToLevel5Value,
                                                domainModel: level5))
        return createLevel5List
    }

    func createDepatureInfo(depatureInfoBucket depatureInfo: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var departureInfoList: [BaseDailyBriefViewModel] = []
        guard let collection = depatureInfo.contentCollections?.first else {
            departureInfoList.append( DepartureInfoCellViewModel(title: "",
                                                                 subtitle: "",
                                                                 text: "",
                                                                 image: "",
                                                                 copyright: "",
                                                                 domainModel: depatureInfo))
            return departureInfoList
        }
        departureInfoList.append(DepartureInfoCellViewModel(title: depatureInfo.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                                            subtitle: depatureInfo.bucketText?.contentItems.filter { $0.searchTags.contains("BUCKET_CONTENT") }.first?.valueText,
                                                            text: collection.contentItems.first?.valueText,
                                                            image: collection.thumbnailURLString ?? "",
                                                            copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                            domainModel: depatureInfo))
        return departureInfoList
    }

    func createSolveViewModel(bucket solveBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createSolveList: [BaseDailyBriefViewModel] = []
        guard (solveBucket.solves?.first) != nil else {
            createSolveList.append(SolveReminderCellViewModel(bucketTitle: "",
                                                              twoDayAgo: "",
                                                              question1: "",
                                                              question2: "",
                                                              question3: "",
                                                              domainModel: solveBucket))
            return createSolveList
        }

        let bucketTitle = solveBucket.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText ?? ""
        let twoDaysAgo = solveBucket.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText ?? ""
        let question1 = solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }.first?.valueText ?? ""
        let filteredQuestions2 = solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }
        let question2 = filteredQuestions2?.at(index: 1)?.valueText ?? ""
        let question3 = solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }.last?.valueText ?? ""
        createSolveList.append(SolveReminderCellViewModel(bucketTitle: bucketTitle,
                                                          twoDayAgo: twoDaysAgo,
                                                          question1: question1,
                                                          question2: question2,
                                                          question3: question3,
                                                          domainModel: solveBucket))
        solveBucket.solves?.forEach {(solve) in
            createSolveList.append(SolveReminderTableCellViewModel(title: solve.solveTitle,
                                                                   date: DateFormatter.solveDate.string(from: solve.createdAt ?? Date()),
                                                                   solve: solve,
                                                                   domainModel: solveBucket))
        }
        return createSolveList
    }

    func createQuestionsWithoutAnswer(questionsWithoutAnswerBucket questionsWithoutAnswer: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createQuestionWithoutAnswerList: [BaseDailyBriefViewModel] = []

        guard let collection = questionsWithoutAnswer.contentCollections?.first else {
            createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: "", text: "", domainModel: questionsWithoutAnswer))
            return createQuestionWithoutAnswerList
        }
        createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: questionsWithoutAnswer.bucketText?.contentItems.first?.valueText,
                                                                 text: collection.contentItems.first?.valueText,
                                                                 domainModel: questionsWithoutAnswer))
        return createQuestionWithoutAnswerList
    }

    func createExploreModel(exploreBucket explore: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var exploreModelList: [BaseDailyBriefViewModel] = []
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        guard let exploreContentCollections = explore.contentCollections else {
            exploreModelList.append(ExploreCellViewModel(bucketTitle: "",
                                                         title: "",
                                                         introText: "",
                                                         labelPosition: 0,
                                                         remoteID: 0,
                                                         domainModel: explore,
                                                         section: ContentSection.Unkown))
            return exploreModelList
        }
        if let hour = dateComponents.hour {
            if 6 <= hour && hour < 12 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                                             title: exploreContentCollections.first?.title,
                                                             introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                                             labelPosition: 40,
                                                             remoteID: exploreContentCollections.first?.remoteID,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.first?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 12 <= hour && hour < 18 {
                exploreModelList.append( ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                                              title: exploreContentCollections.at(index: 1)?.title,
                                                              introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                                              labelPosition: 125,
                                                              remoteID: exploreContentCollections.at(index: 1)?.remoteID,
                                                              domainModel: explore,
                                                              section: exploreContentCollections.at(index: 1)?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 18 <= hour && hour <= 24 || hour < 6 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                                             title: exploreContentCollections.last?.title,
                                                             introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                                             labelPosition: 230,
                                                             remoteID: exploreContentCollections.last?.remoteID,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.last?.section ?? ContentSection.Unkown))
                return exploreModelList }
        }
        exploreModelList.append(ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.first?.valueText,
                                                     title: "", introText: "",
                                                     labelPosition: 0, remoteID: 666,
                                                     domainModel: explore,
                                                     section: ContentSection.Unkown))
        return exploreModelList
    }

    func createMyPeakPerformanceModel(myPeakPerformanceBucket myPeakperformance: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createMyPeakPerformanceList: [BaseDailyBriefViewModel] = []
        let bucketTitle: String = myPeakperformance.bucketText?.contentItems.first?.valueText ?? ""
        var contentSentence: String = ""
        var sectionsModels: [MyPeakPerformanceCellViewModel.MyPeakPerformanceSections] = []
        let beginingOfToday = Date().beginingOfDate()
        let endOfToday = Date().endOfDay()
        let yesterday = -1, today = 0, tomorrow = 1, threeDays = 3
        myPeakperformance.bucketText?.contentItems.forEach({ (contentItem) in
            var localPreparationList = [QDMUserPreparation]()
            var rows: [MyPeakPerformanceCellViewModel.MyPeakPerformanceRow] = []
            if contentItem.searchTags.contains(obj: "IN_THREE_DAYS") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_3_DAYS_BEFORE")
                    }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    let remainingDays = beginingOfToday.days(to: date)
                    return remainingDays == threeDays
                } ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "TOMORROW") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_BEFORE")
                    }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday.days(to: date) == tomorrow
                } ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "TODAY") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_SAME_DAY")
                    }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday.days(to: date) == today
                } ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "REFLECT") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_AFTER")
                    }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return endOfToday.days(to: date) == yesterday
                } ?? [QDMUserPreparation]()
            }
            if localPreparationList.count > 0 {
                localPreparationList.forEach({ (prepareItem) in
                    let subtitle: String = prepareItem.eventType ?? "" + DateFormatter.tbvTracker.string(from: prepareItem.eventDate ?? Date())
                    rows.append(MyPeakPerformanceCellViewModel.MyPeakPerformanceRow(title: prepareItem.name,
                                                                                    subtitle: subtitle,
                                                                                    qdmUserPreparation: prepareItem))
                })
                let sections = MyPeakPerformanceCellViewModel.MyPeakPerformanceSectionRow(sectionSubtitle: contentItem.valueText,
                                                                                          sectionContent: contentSentence)
                sectionsModels.append(MyPeakPerformanceCellViewModel.MyPeakPerformanceSections(sections: sections, rows: rows))
            }
        })
        let cellViewModel = MyPeakPerformanceCellViewModel.init(title: MyPeakPerformanceCellViewModel.MypeakPerformanceTitle(title: bucketTitle),
                                                                sections: sectionsModels,
                                                                domainModel: myPeakperformance)
        createMyPeakPerformanceList.append(cellViewModel)
        return sectionsModels.count > 0 ? createMyPeakPerformanceList : []
    }

    func createDailyCheckIn2(dailyCheckIn2Bucket dailyCheckIn2: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var dailyCheckIn2List: [BaseDailyBriefViewModel] = []
        let dailyCheckIn2ViewModel = DailyCheckin2ViewModel(domainModel: dailyCheckIn2)
        if dailyCheckIn2.toBeVisionTrackId != nil {
            // for TBV
            let title: String = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let tbvRating: Int = dailyCheckIn2.toBeVisionTrack?.ratings.first?.rating ?? 0
            let intro: String = (dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro")}.first?.contentItems.first?.valueText ?? "") + String(tbvRating)
            let tbvSentence: String = dailyCheckIn2.toBeVisionTrack?.sentence ?? ""
            let reflection = dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro2")}.randomElement()?.contentItems.first?.valueText
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.TBV
            dailyCheckIn2ViewModel.dailyCheckIn2TBVModel = DailyCheckIn2TBVModel(title: title,
                                                                                 introText: intro,
                                                                                 tbvSentence: tbvSentence,

                                                                                 adviceText: reflection)
        } else if dailyCheckIn2.SHPIQuestionId != nil {
            //SHPI
            let shpiTitle: String = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let shpiContent =  dailyCheckIn2.contentCollections?.first?.contentItems.first?.valueText
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.SHPI
            let rating = Int(dailyCheckIn2.dailyCheckInAnswers?.first?.userAnswerValue ?? "0")
            dailyCheckIn2ViewModel.dailyCheck2SHPIModel = DailyCheck2SHPIModel(title: shpiTitle, shpiContent: shpiContent, shpiRating: rating)
        } else {
            // peak performance
            let peakPerformanceTitle = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let performanceCount = dailyCheckIn2.dailyCheckInAnswers?.first?.PeakPerformanceCount ?? 0
            let performanceTag = "\(performanceCount)_performances"
            let performanceString = dailyCheckIn2.contentCollections?.filter { $0.searchTags.contains(performanceTag) }.first?.contentItems.first?.valueText
            let replacedString = performanceString?.replacingOccurrences(of: "${peak_performance_count}", with: "\(performanceCount)")
            let model = DailyCheckIn2PeakPerformanceModel(title: peakPerformanceTitle, intro: replacedString)
            dailyCheckIn2ViewModel.dailyCheckIn2PeakPerformanceModel = model
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.PEAKPERFORMANCE
        }
        dailyCheckIn2List.append(dailyCheckIn2ViewModel)
        return dailyCheckIn2List
    }

    func createAboutMe(aboutMeBucket aboutMeModel: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var aboutMeList: [BaseDailyBriefViewModel] = []
        let aboutMeBucketTitle = aboutMeModel.bucketText?.contentItems.first?.valueText ?? ""
        let aboutMeContent = aboutMeModel.stringValue ?? ""
        let aboutMeAdditionalContent = aboutMeModel.additionalDescription
        aboutMeList.append(AboutMeViewModel(title: aboutMeBucketTitle,
                                            aboutMeContent: aboutMeContent,
                                            aboutMeMoreInfo: aboutMeAdditionalContent,
                                            domainModel: aboutMeModel))
        return aboutMeList
    }

    func createWeatherViewModel(weatherBucket: QDMDailyBriefBucket?) -> [BaseDailyBriefViewModel] {
        var weatherList: [BaseDailyBriefViewModel] = []

        let title = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "BUCKET_TITLE")
        }).first?.valueText ?? "BUCKET_TITLE"

        let intro = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "BUCKET_INTRO")
        }).first?.valueText ?? "BUCKET_INTRO"

        let requestLocationPermissionDescription = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "REQUEST_LOCATION_PERMISSION_TEXT")
        }).first?.valueText ?? "REQUEST_LOCATION_PERMISSION_TEXT"

        let requestLocationPermissionButtonTitle = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "REQUEST_LOCATION_PERMISSION_BUTTON_TITLE")
        }).first?.valueText ?? "REQUEST_LOCATION_PERMISSION_BUTTON_TITLE"

        let deniedLocationPermissionDescription = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "DENIED_LOCATION_PERMISSION_TEXT")
        }).first?.valueText ?? "DENIED_LOCATION_PERMISSION_TEXT"

        let deniedLocationPermissionButtonTitle = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "DENIED_LOCATION_PERMISSION_BUTTON_TITLE")
        }).first?.valueText ?? "DENIED_LOCATION_PERMISSION_BUTTON_TITLE"

        weatherList.append(WeatherViewModel(bucketTitle: title,
                                            intro: intro,
                                            requestLocationPermissionDescription: requestLocationPermissionDescription,
                                            requestLocationPermissionButtonTitle: requestLocationPermissionButtonTitle,
                                            deniedLocationPermissionDescription: deniedLocationPermissionDescription,
                                            deniedLocationPermissionButtonTitle: deniedLocationPermissionButtonTitle,
                                            domain: weatherBucket))

        return weatherList
    }

    /**
     * Method name: createGuidedTrack.
     * Description: Method which returns the GuidedTrack Model required for the tableview.
     * Parameters: [guidedTrackBucket]
     */
    func createGuidedTrack(guidedTrackBucket guidedTrack: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var guidedtrackList: [BaseDailyBriefViewModel] = []
        let guidedTrackBucketTitle = guidedTrack.bucketText?.contentItems.filter {$0.searchTags.contains("bucket_title")}
            .first?.valueText ?? ""
        let guidedTrackIntro = guidedTrack.bucketText?.contentItems.filter {$0.searchTags.contains("bucket_intro")}
            .first?.valueText ?? ""
        let guidedTrackCta = guidedTrack.bucketText?.contentItems.filter {$0.searchTags.contains("bucket_cta")}
            .first?.valueText ?? ""
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: guidedTrackBucketTitle,
                                                    levelTitle: "",
                                                    content: guidedTrackIntro,
                                                    buttonText: guidedTrackCta,
                                                    type: GuidedTrackItemType.SECTION,
                                                    appLink: nil,
                                                    domain: guidedTrack))
        guard guidedClosedTrack == true else {
            return guidedtrackList
        }

        guidedTrack.contentCollections?.forEach {(contentItem) in
            let stepTitle = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TITLE")}
                .first?.valueText ?? ""
            let levelTitle = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_TITLE")}
                .first?.valueText ?? ""
            let levelDescription = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_DESCRIPTION")}
                .first?.valueText ?? ""
            let levelCta = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_CTA")}
                .first?.valueText ?? ""
            let qdmAppLink = contentItem.links.first
            guidedtrackList.append(GuidedTrackViewModel(bucketTitle: stepTitle,
                                                        levelTitle: levelTitle,
                                                        content: levelDescription,
                                                        buttonText: levelCta,
                                                        type: GuidedTrackItemType.ROW,
                                                        appLink: qdmAppLink,
                                                        domain: guidedTrack))
        }
        return guidedtrackList
    }

    func createFromTignum(fromTignum: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromTignumList: [BaseDailyBriefViewModel] = []
        let bucketTitle = fromTignum.bucketText?.contentItems.first?.valueText ?? ""
        guard (fromTignum.contentCollections?.first) != nil else {
            createFromTignumList.append( FromTignumCellViewModel(title: "",
                                                                 text: "",
                                                                 subtitle: "",
                                                                 domainModel: fromTignum))
            return createFromTignumList

        }
        fromTignum.contentCollections?.forEach {(fromTignumModel) in
            createFromTignumList.append(FromTignumCellViewModel(title: bucketTitle,
                                                                text: fromTignumModel.contentItems.first?.valueText ?? "",
                                                                subtitle: fromTignumModel.title,
                                                                domainModel: fromTignum))
        }
        return createFromTignumList
    }

    func createLeaderWisdom(createLeadersWisdom leadersWisdom: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var leadersWisdomList: [BaseDailyBriefViewModel] = []
        guard let collection = leadersWisdom.contentCollections?.first else {
            leadersWisdomList.append(LeaderWisdomCellViewModel(title: "",
                                                               subtitle: "",
                                                               description: "",
                                                               audioDuration: 0,
                                                               audioLink: URL(string: ""),
                                                               videoTitle: "",
                                                               videoDuration: 0.0,
                                                               videoThumbnail: URL(string: ""),
                                                               format: .unknown,
                                                               remoteID: 0,
                                                               durationString: "",
                                                               domainModel: nil))

            return leadersWisdomList
        }

        leadersWisdomList.append(LeaderWisdomCellViewModel(title: leadersWisdom.bucketText?.contentItems.first?.valueText ?? "",
                                                           subtitle: "\(leadersWisdom.bucketText?.contentItems[1].valueText ?? "") \(collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_NAME")}.first?.valueText ?? "")",
            description: collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_TRANSCRIPT")}.first?.valueText ?? "",
            audioDuration: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.valueDuration,
            audioLink: URL(string: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.link ?? ""),
            videoTitle: collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.valueDescription ?? "",
            videoDuration: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.valueDuration,
            videoThumbnail: URL(string: collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.valueMediaURL ?? ""),
            format: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.format ?? .unknown,
            remoteID: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.remoteID ?? 0,
            durationString: collection.contentItems.filter { $0.searchTags.contains("LEADER_WISDOM_FILE")}.first?.durationString ?? "",
            domainModel: leadersWisdom))
        return leadersWisdomList
    }

    func createMeAtMyBest(meAtMyBestBucket meAtMyBest: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var meAtMyBestList: [BaseDailyBriefViewModel] = []
        let createMeAtMyBestTitle = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("MY_AT_MY_BEST_TITLE")}.first?.valueText ?? ""
        if meAtMyBest.toBeVisionTrack?.sentence?.isEmpty != false {
            let tbvEmptyIntro = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_NULL_STATE_INTRO")}.first?.valueText ?? "intro_empty"
            let ctaTBVButtonText = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_NULL_STATE_CTA")}.first?.valueText ?? "Create your To Be Vision"
            meAtMyBestList.append(MeAtMyBestCellEmptyViewModel(title: createMeAtMyBestTitle, intro: tbvEmptyIntro, buttonText: ctaTBVButtonText, domainModel: meAtMyBest))
            return meAtMyBestList
        } else {
            let tbvIntro = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_INTRO")}.first?.valueText ?? ""
            let tbvSentence = meAtMyBest.toBeVisionTrack?.sentence ?? ""
            let tbvIntro2 = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_INTRO_2")}.first?.valueText ?? " "
            let ctaTBVButtonText = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_CTA")}.first?.valueText ?? ""
            meAtMyBestList.append(MeAtMyBestCellViewModel(title: createMeAtMyBestTitle,
                                                          intro: tbvIntro,
                                                          tbvStatement: tbvSentence,
                                                          intro2: tbvIntro2,
                                                          buttonText: ctaTBVButtonText,
                                                          domainModel: meAtMyBest))
            return meAtMyBestList
        }

    }

    func createThoughtsToPonder(thoughtsToPonderBucket thoughtsToPonder: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createThoughtsToPonderList: [BaseDailyBriefViewModel] = []

        guard let collection = thoughtsToPonder.contentCollections?.first else {
            createThoughtsToPonderList.append(ThoughtsCellViewModel(title: "",
                                                                    thought: "",
                                                                    author: "String?",
                                                                    domainModel: thoughtsToPonder))
            return createThoughtsToPonderList}
        createThoughtsToPonderList.append(ThoughtsCellViewModel(title: thoughtsToPonder.bucketText?.contentItems.first?.valueText,
                                                                thought: collection.contentItems.first?.valueText ?? "",
                                                                author: collection.author ?? "",
                                                                domainModel: thoughtsToPonder))
        return createThoughtsToPonderList
    }

    func createGoodToKnow(createGoodToKnowBucket createGoodToKnow: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createGoodToKnowList: [BaseDailyBriefViewModel] = []
        guard let collection = createGoodToKnow.contentCollections?.first else {
            createGoodToKnowList.append(GoodToKnowCellViewModel(title: "", fact: "",
                                                                image: URL(string: ""),
                                                                copyright: "",
                                                                domainModel: createGoodToKnow))
            return createGoodToKnowList }
        createGoodToKnowList.append(GoodToKnowCellViewModel(title: createGoodToKnow.bucketText?.contentItems.first?.valueText,
                                                            fact: collection.contentItems.first?.valueText,
                                                            image: URL(string: (collection.thumbnailURLString ?? "")),
                                                            copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                            domainModel: createGoodToKnow))
        return createGoodToKnowList
    }

    func createLatestWhatsHot(whatsHotLatestCell whatsHotLatest: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var latestWhatsHotList: [BaseDailyBriefViewModel] = []

        guard let collection = whatsHotLatest.contentCollections?.first else {
            latestWhatsHotList.append(WhatsHotLatestCellViewModel(bucketTitle: "",
                                                                  title: "",
                                                                  image: URL(string: "") ?? URL(string: "")!,
                                                                  author: "", publisheDate: Date(), timeToRead: 0,
                                                                  isNew: false, remoteID: 0,
                                                                  domainModel: whatsHotLatest))
            return latestWhatsHotList
        }
        latestWhatsHotList.append(WhatsHotLatestCellViewModel(bucketTitle: "test",
                                                              title: collection.title,
                                                              image: URL(string: collection.thumbnailURLString ?? "") ?? URL(string: "")!,
                                                              author: collection.author ?? "",
                                                              publisheDate: collection.contentItems.first?.createdAt ?? Date(),
                                                              timeToRead: collection.secondsRequired,
                                                              isNew: self.isNew(collection),
                                                              remoteID: collection.remoteID ?? 0,
                                                              domainModel: whatsHotLatest))
        return latestWhatsHotList
    }

    func createFeastForEyesModel(feastForEyesBucket feastForEyes: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFeastForEyesList: [BaseDailyBriefViewModel] = []

        guard let collection = feastForEyes.contentCollections?.first else {
            createFeastForEyesList.append(FeastCellViewModel(title: "",
                                                             image: "",
                                                             remoteID: 1,
                                                             copyright: "",
                                                             domainModel: feastForEyes))
            return createFeastForEyesList

        }
        createFeastForEyesList.append(FeastCellViewModel(title: feastForEyes.bucketText?.contentItems.first?.valueText ?? "",
                                                         image: collection.thumbnailURLString ?? "",
                                                         remoteID: collection.contentItems.first?.remoteID,
                                                         copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                         domainModel: feastForEyes))
        return createFeastForEyesList
    }

    func createFromMyCoachModel(fromCoachBucket fromCoach: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromMyCoachModelList: [BaseDailyBriefViewModel] = []
        var messageModels: [FromMyCoachCellViewModel.FromMyCoachMessage] = []
        fromCoach.coachMessages?.forEach {(message) in
            messageModels.append(FromMyCoachCellViewModel.FromMyCoachMessage(date: DateFormatter.messageDate.string(from: message.issueDate!),
                                                                             text: message.body ?? ""))
        }
        createFromMyCoachModelList.append(FromMyCoachCellViewModel(detail: FromMyCoachCellViewModel.FromMyCoachDetail(imageUrl: URL(string: fromCoach.coachMessages?.last?.coachProfileImageUrl ?? ""), title: fromCoach.bucketText?.contentItems.first?.valueText ?? "FROM MY COACH"), messages: messageModels, domainModel: fromCoach))
        return createFromMyCoachModelList
    }

    func createBeSpokeModel(beSpokeModelBucket beSpoke: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createBeSpokeModelList: [BaseDailyBriefViewModel] = []

        guard let collection = beSpoke.contentCollections?.first else {
            createBeSpokeModelList.append(BeSpokeCellViewModel(bucketTitle: "",
                                                               title: "",
                                                               description: "",
                                                               image: "",
                                                               copyright: "",
                                                               domainModel: nil))
            return createBeSpokeModelList

        }
        createBeSpokeModelList.append(BeSpokeCellViewModel(bucketTitle: beSpoke.bucketText?.contentItems.first?.valueText,
                                                           title: collection.title,
                                                           description: collection.contentItems.filter {$0.searchTags.contains("BUCKET_CONTENT")}.first?.valueText,
                                                           image: collection.thumbnailURLString ?? "",
                                                           copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                           domainModel: beSpoke))
        return createBeSpokeModelList
    }

    func createSprintChallenge(bucket sprintBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createSprintChanllengeList: [BaseDailyBriefViewModel] = []

        guard sprintBucket.sprint != nil else {
            let relatedStrategiesModels = [SprintChallengeViewModel.RelatedStrategiesModel()]
            createSprintChanllengeList.append(SprintChallengeViewModel(bucketTitle: "",
                                                                       sprintTitle: "",
                                                                       sprintInfo: "",
                                                                       sprintStepNumber: 0,
                                                                       relatedStrategiesModels: relatedStrategiesModels,
                                                                       domainModel: sprintBucket,
                                                                       sprint: sprintBucket.sprint!))
            return createSprintChanllengeList
        }
        let searchTag: String = "SPRINT_BUCKET_DAY_" + String(sprintBucket.sprint?.currentDay ?? 0)
        let sprintTag = sprintBucket.sprint?.sprintCollection?.searchTags.filter({ $0 != "SPRINT_REPORT"}).first ?? ""
        let sprintInfo = getSprintInfo(sprintBucket, sprintTag, searchTag)
        var relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel] = []
        sprintBucket.sprint?.dailyBriefRelatedContents.forEach {(content) in
            relatedStrategiesModels.append(SprintChallengeViewModel.RelatedStrategiesModel(content.title,
                                                                                           content.durationString,
                                                                                           content.remoteID ?? 0,
                                                                                           nil,
                                                                                           content.section,
                                                                                           content.contentItems.first?.format,
                                                                                           content.contentItems.count))
        }
        sprintBucket.sprint?.dailyBriefRelatedContentItems.forEach { (contentItem) in
            relatedStrategiesModels.append(SprintChallengeViewModel.RelatedStrategiesModel(contentItem.valueText,
                                                                                           contentItem.durationString,
                                                                                           nil,
                                                                                           contentItem.remoteID,
                                                                                           .Unkown,
                                                                                           contentItem.format, 1))
        }

        createSprintChanllengeList.append(SprintChallengeViewModel(bucketTitle: sprintBucket.bucketText?.contentItems.first?.valueText,
                                                                   sprintTitle: sprintBucket.sprint?.title,
                                                                   sprintInfo: sprintInfo,
                                                                   sprintStepNumber: sprintBucket.sprint?.currentDay,
                                                                   relatedStrategiesModels: relatedStrategiesModels,
                                                                   domainModel: sprintBucket,
                                                                   sprint: sprintBucket.sprint!))
        return createSprintChanllengeList
    }
}
