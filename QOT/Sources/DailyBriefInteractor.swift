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
    private let presenter: DailyBriefPresenterInterface
    private var viewModelOldListModels: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
    private var expendImpactReadiness: Bool = false

    private var guidedClosedTrack: Bool = false
    private var isLoadingBuckets: Bool = false
    private var needToLoadBuckets: Bool = false

    private let dailyCheckInResultRequestTimeOut: Int = 20 // seconds
    private var dailyCheckInResultRequestCheckTimer: Timer?
    private var targetBucketName: DailyBriefBucketName?

    var didDailyCheckIn = false
    var hasSiriShortcuts = false
    var hasToBeVision = false
    var hasConnectedWearable = false

    private lazy var firstInstallTimeStamp = UserDefault.firstInstallationTimestamp.object as? Date
    private lazy var worker = DailyBriefWorker(questionService: QuestionService.main,
                                               userService: UserService.main,
                                               settingService: SettingService.main)

    // MARK: - Init
    init(presenter: DailyBriefPresenterInterface) {
        self.presenter = presenter

        // Listen about UpSync Daily Check In User Answers
        NotificationCenter.default.addObserver(self, selector: #selector(didGetDataSyncRequest(_ :)),
                                               name: .requestSynchronization, object: nil)
        // Listen about Expend/Collapse of Closed Guided Track
        NotificationCenter.default.addObserver(self, selector: #selector(didGuidedClosedCellSizeChanges(_ :)),
                                               name: .displayGuidedTrackRows, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didGetScrollNotificationToBucket(_ :)),
                                               name: .scrollToBucket, object: nil)

        getDailyBriefBucketsForViewModel()
    }

    // MARK: - Life Cycle
    func viewDidLoad() {
        presenter.setupView()
        getDailyBriefDummySectionModels()
        NotificationCenter.default.post(name: .requestSynchronization, object: nil)
    }
}

// MARK: Private methods
private extension DailyBriefInteractor {
    func setVisibleBucketsAsSeenIfNeeded(indexPath: IndexPath) {
        let bucketModel = bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        if let bucketList = bucketList,
            bucketList.count > indexPath.row {
            if let bucket = bucketList[indexPath.row].domainModel {
                DailyBriefService.main.markAsSeenBuckets([bucket])
            }
        }
    }

    func scrollToBucket(_ bucketName: DailyBriefBucketName) {
        var modelIndex: Int?
        for (index, item) in viewModelOldListModels.enumerated() {
            guard item.elements.first?.domainModel?.bucketName == bucketName else { continue }
            modelIndex = index
            break
        }
        if let targetIndex = modelIndex {
            presenter.scrollToSection(at: targetIndex)
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
        guard viewModelOldListModels.filter({ $0.elements.first?.domainModel?.bucketName == bucketName }).first != nil else {
            targetBucketName = bucketName
            updateDailyBriefBucket()
            return
        }

        scrollToBucket(bucketName)
    }
}

// MARK: - DailyBriefInteractorInterface
extension DailyBriefInteractor: DailyBriefInteractorInterface {

    // MARK: - Properties
    var rowViewSectionCount: Int {
        return viewModelOldListModels.count
    }

    // MARK: - Retrieve methods
    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return worker.bucket(at: row)
    }

    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]? {
        return viewModelOldListModels
    }

    func getDailyBriefDummySectionModels() {
        var sectionDataList: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
        sectionDataList.append(ArraySection(model: .impactReadiness,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .dailyCheckIn2,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .questionWithoutAnswer,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .meAtMyBest,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .goodToKnow,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .explore,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .leaderswisdom,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .feastForYourEyes,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .thoughts,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .departureInfo,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .aboutMe,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .whatsHotLatest,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .getToLevel5,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .fromTignum,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        sectionDataList.append(ArraySection(model: .weather,
                                            elements: [BaseDailyBriefViewModel.init(nil)]))
        let changeSet = StagedChangeset(source: viewModelOldListModels, target: sectionDataList)
        presenter.updateViewNew(changeSet)
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

            strongSelf.worker.hasConnectedWearable { (hasConnected) in
                strongSelf.hasConnectedWearable = hasConnected
            }
            strongSelf.worker.hasSiriShortcuts { (hasShortcuts) in
                strongSelf.hasSiriShortcuts = hasShortcuts
            }

            bucketsList.forEach { [weak self] (bucket) in
                guard let strongSelf = self else {
                    return
                }
                switch bucket.bucketName {
                case .DAILY_CHECK_IN_1?:
                    strongSelf.hasToBeVision = (bucket.toBeVision != nil)
                    strongSelf.didDailyCheckIn = (bucket.dailyCheckInAnswerIds?.isEmpty == false)
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
                                                         elements: strongSelf.createProductsWeLove(productsBucket: bucket)))
                case .DEPARTURE_INFO?:
                    sectionDataList.append(ArraySection(model: .departureInfo,
                                                        elements: strongSelf.createOnTheRoad(onTheRoadBucket: bucket)))
                case .LEADERS_WISDOM?:
                    sectionDataList.append(ArraySection(model: .leaderswisdom,
                                                        elements: strongSelf.createLeaderWisdom(createLeadersWisdom: bucket)))
                case .FEAST_OF_YOUR_EYES?:
                    sectionDataList.append(ArraySection(model: .feastForYourEyes,
                                                        elements: strongSelf.createDepatureBespokeFeast(depatureBespokeFeastBucket: bucket)))
                case .FROM_MY_COACH?:
                    let elements = strongSelf.createFromMyCoachModel(fromCoachBucket: bucket)
                    if elements.isEmpty == false {
                        sectionDataList.append(ArraySection(model: .fromMyCoach, elements: elements))
                    }

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
                    let models = strongSelf.createWeatherViewModel(weatherBucket: bucket)
                    if models.count > 0 {
                        sectionDataList.append(ArraySection(model: .weather,
                                                            elements: models))
                    }
                case .GUIDE_TRACK?:
                    let elements = strongSelf.createGuidedTrack(guidedTrackBucket: bucket)
                    if elements.isEmpty == false {
                        sectionDataList.append(ArraySection(model: .guidedTrack, elements: elements))
                    }
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

            if let bucketNameToScroll = strongSelf.targetBucketName, changeSet.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    strongSelf.scrollToBucket(bucketNameToScroll)
                })
                strongSelf.targetBucketName = nil
            }
        }
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        worker.getToBeVisionImage(completion: completion)
    }

    // MARK: Save methods
    func saveAnswerValue(_ value: Int) {
        worker.saveAnswerValue(value)
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
}

// MARK: Helpers
extension DailyBriefInteractor {
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

    func startTimer(forCell: BaseDailyBriefCell, at indexPath: IndexPath) {
        forCell.setTimer(with: 3.0) { [weak self] in
            self?.setVisibleBucketsAsSeenIfNeeded(indexPath: indexPath)
        }
    }

    func invalidateTimer(forCell: BaseDailyBriefCell) {
        forCell.stopTimer()
    }

    // MARK: - CREATING BUCKET MODELS
    /**
     * Method name:  createImpactReadinessCell.
     * Description: Create the impact readiness model which is required for the dailyCheck in Bucket.
     * Parameters: [QDMDailyBriefBucket]
     */

    // MARK: - Impact Readiness
    func createImpactReadinessCell(impactReadinessBucket impactReadiness: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var impactReadinessList: [BaseDailyBriefViewModel] = []
        var readinessIntro: String? = ""
        var models: [ImpactReadinessScoreViewModel.ImpactDataViewModel] = []
        let impactReadinessImageURL = impactReadiness.toBeVision?.profileImageResource?.url()
        if impactReadiness.dailyCheckInResult?.impactReadiness == nil {
            readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_empty_body)
        }

        let bucketTitle = AppTextService.get(.daily_brief_section_impact_readiness_title)

        //If the daily check in completed update the ImpactReadinessCellViewModel
        let readinessscore = Int(impactReadiness.dailyCheckInResult?.impactReadiness ?? -1)
        var enableButton = true
        if impactReadiness.dailyCheckInAnswerIds?.isEmpty != false,
            impactReadiness.dailyCheckInResult == nil {
            expendImpactReadiness = false

        }

        // check request time for result
        if let answerDate = impactReadiness.dailyCheckInAnswers?.first?.createdOnDevice,
            impactReadiness.dailyCheckInResult == nil {
            // if it took longer than dailyCheckInResultRequestTimeOut and still we don't have result
            if answerDate.dateAfterSeconds(dailyCheckInResultRequestTimeOut) < Date() {
                readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_error_body)
                dailyCheckInResultRequestCheckTimer?.invalidate()
                dailyCheckInResultRequestCheckTimer = nil
                expendImpactReadiness = false
                enableButton = false
            } else if dailyCheckInResultRequestCheckTimer == nil { // if timer is not triggered.
                readinessIntro = impactReadiness.bucketText?.contentItems
                    .filter {$0.searchTags.contains("LOADING_DAILY_CHECK_IN_RESULT")}.first?.valueText
                dailyCheckInResultRequestCheckTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(dailyCheckInResultRequestTimeOut),
                                                                           repeats: false) { (timer) in
                                                                            self.dailyCheckInResultRequestCheckTimer?.invalidate()
                                                                            self.dailyCheckInResultRequestCheckTimer = nil
                                                                            self.updateDailyBriefBucket()
                }
            }
        } else if impactReadiness.dailyCheckInResult != nil { // if we got the result.
            dailyCheckInResultRequestCheckTimer?.invalidate()
            dailyCheckInResultRequestCheckTimer = nil
            readinessIntro = impactReadiness.dailyCheckInResult?.feedback
            expendImpactReadiness = true
        }

        impactReadinessList.append(ImpactReadinessCellViewModel.init(title: bucketTitle,
                                                                     dailyCheckImageURL: impactReadinessImageURL,
                                                                     readinessScore: readinessscore,
                                                                     readinessIntro: readinessIntro,
                                                                     isExpanded: expendImpactReadiness,
                                                                     enableButton: enableButton,
                                                                     domainModel: impactReadiness))
        let howYouFeelToday = AppTextService.get(.daily_brief_section_impact_readiness_section_five_days_rolling_body_explainer)
        let sleepQuantity = impactReadiness.dailyCheckInResult?.fiveDaysSleepQuantity ?? 0
        let sleepQuality = min(impactReadiness.dailyCheckInResult?.fiveDaysSleepQuality ?? 0, 10)
        let maxTrackingDays = impactReadiness.dailyCheckInResult?.maxTrackingDays
        let load = impactReadiness.dailyCheckInResult?.fiveDaysload ?? 0
        let futureLoad = impactReadiness.dailyCheckInResult?.tenDaysFutureLoad ?? 0
        let targetSleepQuantity = impactReadiness.dailyCheckInResult?.targetSleepQuantity ?? 0
        let sleepQualityReference = AppTextService.get(.daily_brief_section_impact_readiness_section_sleep_quality_number_ref)
        let loadReference = AppTextService.get(.daily_brief_section_impact_readiness_section_load_number_ref)
        let futureLoadReference = AppTextService.get(.daily_brief_section_impact_readiness_section_future_load_number_ref)
        impactReadiness.contentCollections?.filter {$0.searchTags.contains("TITLE") }.forEach {(collection) in
            models.append(ImpactReadinessScoreViewModel.ImpactDataViewModel(title: collection.title,
                                                                            subTitle: collection.contentItems.first?.valueText))
        }
        if expendImpactReadiness {
            let asteriskText = AppTextService.get(.daily_brief_section_impact_readiness_body_missing_five_days_data)
            let hasFullLoadData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForLoad
            let hasFullSleepQuantityData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForSleepQuantity
            let hasFullSleepQualityData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForSleepQuality

            impactReadinessList.append(ImpactReadinessScoreViewModel.init(howYouFeelToday: howYouFeelToday,
                                                                          asteriskText: asteriskText,
                                                                          sleepQuantityValue: sleepQuantity,
                                                                          hasFiveDaySleepQuantityValues: hasFullSleepQuantityData,
                                                                          sleepQualityValue: sleepQuality,
                                                                          hasFiveDaySleepQualityValue: hasFullSleepQualityData,
                                                                          loadValue: load,
                                                                          hasFiveDayLoadValue: hasFullLoadData,
                                                                          futureLoadValue: futureLoad,
                                                                          targetSleepQuantity: targetSleepQuantity,
                                                                          sleepQualityReference: Double(sleepQualityReference),
                                                                          loadReference: Double(loadReference),
                                                                          futureLoadReference: Double(futureLoadReference),
                                                                          impactDataModels: models,
                                                                          maxTrackingDays: maxTrackingDays,
                                                                          domainModel: impactReadiness, "detail"))
        }

        return impactReadinessList
    }

    // MARK: - Daily Insights
    func createDailyCheckIn2(dailyCheckIn2Bucket dailyCheckIn2: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var dailyCheckIn2List: [BaseDailyBriefViewModel] = []
        let dailyCheckIn2ViewModel = DailyCheckin2ViewModel(domainModel: dailyCheckIn2)
        if dailyCheckIn2.toBeVisionTrackId != nil {
            // TBV Rated sentence
            let title: String = AppTextService.get(.daily_brief_section_daily_insights_tbv_title)
            let tbvRating: Int = Int(dailyCheckIn2.dailyCheckInSixthQuestionAnswerValue ?? "") ?? 0
            let intro: String = AppTextService.get(.daily_brief_section_daily_insights_tbv_subtitle_rating_of) + " " + String(tbvRating)
            let ctaText = AppTextService.get(.daily_brief_section_daily_insights_tbv_button_view_my_tbv)
            let tbvSentence: String = dailyCheckIn2.toBeVisionTrack?.sentence ?? ""
            let reflection = dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro2")}.randomElement()?.contentItems.first?.valueText
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.TBV
            dailyCheckIn2ViewModel.dailyCheckIn2TBVModel = DailyCheckIn2TBVModel(title: title,
                                                                                 introText: intro,
                                                                                 tbvSentence: tbvSentence,
                                                                                 adviceText: reflection,
                                                                                 cta: ctaText)
        } else if dailyCheckIn2.SHPIQuestionId != nil {
            // Shpi
            let shpiTitle: String = AppTextService.get(.daily_brief_section_daily_insights_shpi_title)
            let shpiContent =  dailyCheckIn2.contentCollections?.first?.contentItems.first?.valueText
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.SHPI
            let rating = Int(dailyCheckIn2.dailyCheckInSixthQuestionAnswerValue ?? "") ?? 0
            let question = dailyCheckIn2.SHPIQuestion?.title
            dailyCheckIn2ViewModel.dailyCheck2SHPIModel = DailyCheck2SHPIModel(title: shpiTitle, shpiContent: shpiContent, shpiRating: rating, shpiQuestion: question)
        } else {
            // Peak Performance
            let peakPerformanceTitle = AppTextService.get(.daily_brief_section_daily_insights_peak_performances_title)
            let performanceCount = Int(dailyCheckIn2.dailyCheckInSixthQuestionAnswerValue ?? "") ?? 0
            var performanceBody: String?
            let hasNoPerformance = performanceCount == 0
            let performanceString = AppTextService.get(.daily_brief_section_daily_insights_peak_performances_body)
            if hasNoPerformance {
                performanceBody = AppTextService.get(.daily_brief_section_daily_insights_peak_performances_null_body)
            } else if performanceCount == 9 {
                 performanceBody = AppTextService.get(.daily_brief_section_daily_insights_peak_performances_over_nine_body)
            } else {
                performanceBody = performanceString.replacingOccurrences(of: "${peak_performance_count}", with: "\(performanceCount)")
            }
            let model = DailyCheckIn2PeakPerformanceModel(title: peakPerformanceTitle, intro: performanceBody, hasNoPerformance: hasNoPerformance)
            dailyCheckIn2ViewModel.dailyCheckIn2PeakPerformanceModel = model
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.PEAKPERFORMANCE
        }
        dailyCheckIn2List.append(dailyCheckIn2ViewModel)
        return dailyCheckIn2List
    }

    // MARK: - Level up
    func createLevel5Cell(level5Bucket level5: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createLevel5List: [BaseDailyBriefViewModel] = []
        var levelMessageModels: [Level5ViewModel.LevelDetail] = []

        let title = AppTextService.get(.daily_brief_section_level_5_title)
        let intro = AppTextService.get(.daily_brief_section_level_5_body)
        let question = AppTextService.get(.daily_brief_section_level_5_question)
        let youRatedPart1 = AppTextService.get(.daily_brief_section_level_5_question_with_data_one)
        let youRatedPart2 = AppTextService.get(.daily_brief_section_level_5_question_with_data_two)
        let confirmationMessage =  AppTextService.get(.daily_brief_section_level_5_alert_body)
        let level1Title = AppTextService.get(.daily_brief_section_level_5_level_1_title)
        let level1Text = AppTextService.get(.daily_brief_section_level_5_level_1_body)
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

        let level2Title = AppTextService.get(.daily_brief_section_level_5_level_2_title)
        let level2Text =  AppTextService.get(.daily_brief_section_level_5_level_2_body)
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level2Title, levelContent: level2Text))

        let level3Title = AppTextService.get(.daily_brief_section_level_5_level_3_title)
        let level3Text =  AppTextService.get(.daily_brief_section_level_5_level_3_body)
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level3Title, levelContent: level3Text))

        let level4Title = AppTextService.get(.daily_brief_section_level_5_level_4_title)
        let level4Text =  AppTextService.get(.daily_brief_section_level_5_level_4_body)
        levelMessageModels.append(Level5ViewModel.LevelDetail(levelTitle: level4Title, levelContent: level4Text))

        let level5Title = AppTextService.get(.daily_brief_section_level_5_level_5_title)
        let level5Text =  AppTextService.get(.daily_brief_section_level_5_level_5_body)
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

    // MARK: - Visual delights
    func createDepatureBespokeFeast(depatureBespokeFeastBucket depatureBespokeFeast: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var departureBespokeFeastList: [BaseDailyBriefViewModel] = []
        guard let collection = depatureBespokeFeast.contentCollections?.first else {
            departureBespokeFeastList.append(DepartureBespokeFeastModel(title: "",
                                                                        subtitle: "",
                                                                        text: "",
                                                                        images: [""],
                                                                        copyrights: [""],
                                                                        domainModel: depatureBespokeFeast))
            return departureBespokeFeastList
        }
        let title = AppTextService.get(.daily_brief_section_on_the_road_title)
        let subtitle = collection.contentItems.filter { $0.format == .title }.first?.valueText
        let text = collection.contentItems.filter { $0.searchTags.contains("BUCKET_CONTENT") }.first?.valueText
        var copyrights: [String?] = []
        var images: [String?] = []
        collection.contentItems.filter { $0.format == .image }.forEach { (image) in
            images.append(image.valueMediaURL)
            copyrights.append(image.copyrightURLString)
        }
        let model = DepartureBespokeFeastModel(title: title,
                                               subtitle: subtitle,
                                               text: text,
                                               images: images,
                                               copyrights: copyrights,
                                               domainModel: depatureBespokeFeast)
        departureBespokeFeastList.append(model)
        return departureBespokeFeastList
    }

    // MARK: - Products we love
    func createProductsWeLove(productsBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var productsList: [BaseDailyBriefViewModel] = []
        guard let collection = productsBucket.contentCollections?.first else {
            productsList.append(DepartureBespokeFeastModel(title: "",
                                                           subtitle: "",
                                                           text: "",
                                                           images: [""],
                                                           copyrights: [""],
                                                           domainModel: productsBucket))
            return productsList
        }
        let title = AppTextService.get(.daily_brief_section_products_we_love_title)
        let subtitle = collection.contentItems.filter { $0.format == .title }.first?.valueText
        let text = collection.contentItems.filter { $0.searchTags.contains("BUCKET_CONTENT") }.first?.valueText
        var copyrights: [String?] = []
        var images: [String?] = []
        collection.contentItems.filter { $0.format == .image }.forEach { (image) in
            images.append(image.valueMediaURL)
            copyrights.append(image.copyrightURLString)
        }
        let model = DepartureBespokeFeastModel(title: title,
                                               subtitle: subtitle,
                                               text: text,
                                               images: images,
                                               copyrights: copyrights,
                                               domainModel: productsBucket)
        productsList.append(model)
        return productsList
    }

    // MARK: - On the Road
     func createOnTheRoad(onTheRoadBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
         var onTheRoadList: [BaseDailyBriefViewModel] = []
         guard let collection = onTheRoadBucket.contentCollections?.first else {
             onTheRoadList.append(DepartureBespokeFeastModel(title: "",
                                                            subtitle: "",
                                                            text: "",
                                                            images: [""],
                                                            copyrights: [""],
                                                            domainModel: onTheRoadBucket))
             return onTheRoadList
         }
         let title = AppTextService.get(.daily_brief_section_on_the_road_title)
         let subtitle = collection.contentItems.filter { $0.format == .title }.first?.valueText
         let text = collection.contentItems.filter { $0.searchTags.contains("BUCKET_CONTENT") }.first?.valueText
         var copyrights: [String?] = []
         var images: [String?] = []
         collection.contentItems.filter { $0.format == .image }.forEach { (image) in
             images.append(image.valueMediaURL)
             copyrights.append(image.copyrightURLString)
         }
         let model = DepartureBespokeFeastModel(title: title,
                                                subtitle: subtitle,
                                                text: text,
                                                images: images,
                                                copyrights: copyrights,
                                                domainModel: onTheRoadBucket)
         onTheRoadList.append(model)
         return onTheRoadList
     }

    // MARK: - Solve Reminder
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

        let bucketTitle = AppTextService.get(.daily_brief_section_solve_reflection_title)
        let twoDaysAgo = AppTextService.get(.daily_brief_section_solve_reflection_body)
        let question1 = AppTextService.get(.daily_brief_section_solve_reflection_bullet_1)
        let question2 = AppTextService.get(.daily_brief_section_solve_reflection_bullet_2)
        let question3 = AppTextService.get(.daily_brief_section_solve_reflection_bullet_3)
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

    // MARK: - Big questions
    func createQuestionsWithoutAnswer(questionsWithoutAnswerBucket questionsWithoutAnswer: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createQuestionWithoutAnswerList: [BaseDailyBriefViewModel] = []

        guard let collection = questionsWithoutAnswer.contentCollections?.first else {
            createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: "", text: "", domainModel: questionsWithoutAnswer))
            return createQuestionWithoutAnswerList
        }
        createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: AppTextService.get(.daily_brief_section_big_questions_title),
                                                                     text: collection.contentItems.first?.valueText,
                                                                     domainModel: questionsWithoutAnswer))
        return createQuestionWithoutAnswerList
    }

    // MARK: - Explore
    func createExploreModel(exploreBucket explore: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var exploreModelList: [BaseDailyBriefViewModel] = []
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        guard let exploreContentCollections = explore.contentCollections else {
            exploreModelList.append(ExploreCellViewModel(bucketTitle: "",
                                                         title: "",
                                                         introText: "",
                                                         remoteID: 0,
                                                         domainModel: explore,
                                                         section: ContentSection.Unkown))
            return exploreModelList
        }
        if let hour = dateComponents.hour {
            if 6 <= hour && hour < 12 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title),
                                                             title: exploreContentCollections.first?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.first?.remoteID,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.first?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 12 <= hour && hour < 18 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title),
                                                             title: exploreContentCollections.at(index: 1)?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.at(index: 1)?.remoteID,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.at(index: 1)?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 18 <= hour && hour <= 24 || hour < 6 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title),
                                                             title: exploreContentCollections.last?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.last?.remoteID,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.last?.section ?? ContentSection.Unkown))
                return exploreModelList }
        }
        exploreModelList.append(ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.first?.valueText,
                                                     title: "", introText: "",
                                                     remoteID: 666,
                                                     domainModel: explore,
                                                     section: ContentSection.Unkown))
        return exploreModelList
    }

    // MARK: - My Peak Performances
    func createMyPeakPerformanceModel(myPeakPerformanceBucket myPeakperformance: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createMyPeakPerformanceList: [BaseDailyBriefViewModel] = []
        let bucketTitle = AppTextService.get(.daily_brief_section_my_peak_performances_title)
        var contentSentence = ""
        var contentSubtitle = ""
        var sectionsModels: [MyPeakPerformanceCellViewModel.MyPeakPerformanceSections] = []
        let beginingOfToday = Date().beginingOfDate()
        let endOfToday = Date().endOfDay()
        let yesterday = -1, tomorrow = 1, threeDays = 3
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
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_in_three_days_label)
            } else if contentItem.searchTags.contains(obj: "TOMORROW") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_BEFORE")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday.days(to: date) == tomorrow
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_tomorrow_label)
            } else if contentItem.searchTags.contains(obj: "TODAY") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_SAME_DAY")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday == date.beginingOfDate()
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_today_label)
            } else if contentItem.searchTags.contains(obj: "REFLECT") {
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_AFTER")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return endOfToday.days(to: date) == yesterday
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_reflect_label)
            }
            if localPreparationList.count > 0 {
                localPreparationList.forEach({ (prepareItem) in
                    let subtitle = prepareItem.eventType ?? "" + DateFormatter.tbvTracker.string(from: prepareItem.eventDate ?? Date())
                    rows.append(MyPeakPerformanceCellViewModel.MyPeakPerformanceRow(title: prepareItem.name,
                                                                                    subtitle: subtitle,
                                                                                    qdmUserPreparation: prepareItem))
                })
                let sections = MyPeakPerformanceCellViewModel.MyPeakPerformanceSectionRow(sectionSubtitle: contentSubtitle,
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

    // MARK: - My Stats
    func createAboutMe(aboutMeBucket aboutMeModel: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var aboutMeList: [BaseDailyBriefViewModel] = []
        let aboutMeBucketTitle = AppTextService.get(.daily_brief_section_my_stats_title)
        let aboutMeContent = aboutMeModel.stringValue ?? ""
        let aboutMeAdditionalContent = aboutMeModel.additionalDescription

        aboutMeList.append(AboutMeViewModel(title: aboutMeBucketTitle,
                                            aboutMeContent: aboutMeContent,
                                            aboutMeMoreInfo: aboutMeAdditionalContent,
                                            domainModel: aboutMeModel))
        return aboutMeList
    }

    // MARK: - Weather
    func createWeatherViewModel(weatherBucket: QDMDailyBriefBucket?) -> [BaseDailyBriefViewModel] {
        var weatherList: [BaseDailyBriefViewModel] = []

        let title = AppTextService.get(.daily_brief_section_weather_empty_title)

        let intro = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "BUCKET_INTRO")
        }).first?.valueText ?? "BUCKET_INTRO"

        let requestLocationPermissionDescription = AppTextService.get(.daily_brief_section_weather_empty_body_under_pic)
        let requestLocationPermissionButtonTitle = AppTextService.get(.daily_brief_section_weather_empty_button_allow)
        let deniedLocationPermissionDescription = AppTextService.get(.daily_brief_section_weather_empty_body_under_pic)
        let deniedLocationPermissionButtonTitle = AppTextService.get(.daily_brief_section_weather_empty_button_open_settings)
        let locationPermission = AppCoordinator.permissionsManager?.currentStatusFor(for: .location) ?? .notDetermined
        weatherList.append(WeatherViewModel(bucketTitle: title,
                                            intro: intro,
                                            requestLocationPermissionDescription: requestLocationPermissionDescription,
                                            requestLocationPermissionButtonTitle: requestLocationPermissionButtonTitle,
                                            deniedLocationPermissionDescription: deniedLocationPermissionDescription,
                                            deniedLocationPermissionButtonTitle: deniedLocationPermissionButtonTitle,
                                            locationName: weatherBucket?.weather?.locationName,
                                            locationPermissionStatus: locationPermission,
                                            domain: weatherBucket))

        return weatherList
    }

    // MARK: - Guided tour
    func createGuidedTrack(guidedTrackBucket guidedTrack: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var guidedtrackList: [BaseDailyBriefViewModel] = []
        let title = AppTextService.get(.daily_brief_section_guided_track_title)
        let intro = AppTextService.get(.daily_brief_section_guided_track_body)
        let buttonTitle = AppTextService.get(.daily_brief_section_guided_track_button_get_to_know_qot)
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: title,
                                                    levelTitle: "",
                                                    content: intro,
                                                    buttonText: buttonTitle,
                                                    type: GuidedTrackItemType.SECTION,
                                                    appLink: nil,
                                                    domain: guidedTrack))

        guard guidedClosedTrack == true else {
            return guidedtrackList
        }
//        TO DO
//        let level1Title = AppTextService.get(.daily_brief_section_guided_track_section_step_1_subtitle)
//        let level1Description = AppTextService.get(.daily_brief_section_guided_track_section_step_1_body)
//        let level1Cta = AppTextService.get(.daily_brief_section_guided_track_section_step_1_button)
//
//        let level2Tile = AppTextService.get(.daily_brief_section_guided_track_section_step_2_subtitle)
//        let level2Description = AppTextService.get(.daily_brief_section_guided_track_section_step_2_body)
//        let level2Cta = AppTextService.get(.daily_brief_section_guided_track_section_step_2_button)
//
//        let level3Title = AppTextService.get(.daily_brief_section_guided_track_section_step_3_subtitle)
//        let level3Description = AppTextService.get(.daily_brief_section_guided_track_section_step_3_body)
//        let level3Cta = AppTextService.get(.daily_brief_section_guided_track_section_step_3_button)
//
//        let level4Title = AppTextService.get(.daily_brief_section_guided_track_section_step_4_subtitle)
//        let level4Description = AppTextService.get(.daily_brief_section_guided_track_section_step_4_body)
//        let level4Cta = AppTextService.get(.daily_brief_section_guided_track_section_step_4_button)
//
//        let level5Title = AppTextService.get(.daily_brief_section_guided_track_section_step_5_subtitle)
//        let level5Description = AppTextService.get(.daily_brief_section_guided_track_section_step_5_body)
//        let level5Cta = AppTextService.get(.daily_brief_section_guided_track_section_step_5_button)

        guidedTrack.contentCollections?.forEach { (contentItem) in
            let levelTitle = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_TITLE")}
                .first?.valueText
            let levelDescription = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_DESCRIPTION")}
                .first?.valueText
            let levelCta = contentItem.contentItems.filter {$0.searchTags.contains("STEP_TASK_CTA")}
                .first?.valueText
            let qdmAppLink = contentItem.links.first

            if  let levelTitle = levelTitle,
                let levelDescription = levelDescription,
                let levelCta = levelCta,
                let qdmAppLink = qdmAppLink {

                guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "",
                                                            levelTitle: levelTitle,
                                                            content: levelDescription,
                                                            buttonText: levelCta,
                                                            type: GuidedTrackItemType.ROW,
                                                            appLink: qdmAppLink,
                                                            domain: guidedTrack))
            }
        }
        return guidedtrackList
    }

    // MARK: - Tignum Messages
    func createFromTignum(fromTignum: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromTignumList: [BaseDailyBriefViewModel] = []
        let bucketTitle = AppTextService.get(.daily_brief_section_from_tignum_title)
        guard (fromTignum.contentCollections?.first) != nil, isValidFromTignumBucket(fromTignum) else {
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

    // MARK: - Leader Wisdom
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
        leadersWisdomList.append(LeaderWisdomCellViewModel(title: AppTextService.get(.daily_brief_section_leader_wisdom_title),
                                                           subtitle: "\(AppTextService.get(.daily_brief_section_leader_wisdom_body)) \(collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_NAME")}.first?.valueText ?? "")",
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

    // MARK: - Tobevision
    func createMeAtMyBest(meAtMyBestBucket meAtMyBest: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var meAtMyBestList: [BaseDailyBriefViewModel] = []
        let createMeAtMyBestTitle = AppTextService.get(.daily_brief_section_my_best_title)
        if meAtMyBest.toBeVisionTrack?.sentence?.isEmpty != false {
            let tbvEmptyIntro = AppTextService.get(.daily_brief_section_my_best_empty_body)
            let ctaTBVButtonText = AppTextService.get(.daily_brief_section_my_best_empty_button_create_tbv)
            meAtMyBestList.append(MeAtMyBestCellEmptyViewModel(title: createMeAtMyBestTitle, intro: tbvEmptyIntro, buttonText: ctaTBVButtonText, domainModel: meAtMyBest))
            return meAtMyBestList
        } else {
            let tbvIntro = AppTextService.get(.daily_brief_section_my_best_body)
            let tbvSentence = meAtMyBest.toBeVisionTrack?.sentence ?? ""
            let tbvIntro2 = DailyBriefAtMyBestWorker().storedText(meAtMyBest.contentCollections?.filter {$0.searchTags.contains("ME_AT_MY_BEST_REFLECTION")}.randomElement()?.contentItems.first?.valueText ?? " ")
            let ctaTBVButtonText = AppTextService.get(.daily_brief_section_my_best_button_my_tbv)
            meAtMyBestList.append(MeAtMyBestCellViewModel(title: createMeAtMyBestTitle,
                                                          intro: tbvIntro,
                                                          tbvStatement: tbvSentence,
                                                          intro2: tbvIntro2,
                                                          buttonText: ctaTBVButtonText,
                                                          domainModel: meAtMyBest))
            return meAtMyBestList
        }

    }

    // MARK: - Big Thoughts
    func createThoughtsToPonder(thoughtsToPonderBucket thoughtsToPonder: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createThoughtsToPonderList: [BaseDailyBriefViewModel] = []

        guard let collection = thoughtsToPonder.contentCollections?.first else {
            createThoughtsToPonderList.append(ThoughtsCellViewModel(title: "",
                                                                    thought: "",
                                                                    author: "String?",
                                                                    domainModel: thoughtsToPonder))
            return createThoughtsToPonderList}
        createThoughtsToPonderList.append(ThoughtsCellViewModel(title: AppTextService.get(.daily_brief_section_big_thoughts_title),
                                                                thought: collection.contentItems.first?.valueText ?? "",
                                                                author: collection.author ?? "",
                                                                domainModel: thoughtsToPonder))
        return createThoughtsToPonderList
    }

    // MARK: - Good to Know
    func createGoodToKnow(createGoodToKnowBucket createGoodToKnow: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createGoodToKnowList: [BaseDailyBriefViewModel] = []
        guard let collection = createGoodToKnow.contentCollections?.first else {
            createGoodToKnowList.append(GoodToKnowCellViewModel(title: "",
                                                                fact: "",
                                                                copyright: "",
                                                                domainModel: createGoodToKnow))
            return createGoodToKnowList }
        createGoodToKnowList.append(GoodToKnowCellViewModel(title: AppTextService.get(.daily_brief_section_good_to_know_title),
                                                            fact: collection.contentItems.first?.valueText,
                                                            copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                            domainModel: createGoodToKnow))
        return createGoodToKnowList
    }

    // MARK: - Latest What's hot
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

    // MARK: - From My Tignum Coach
    func createFromMyCoachModel(fromCoachBucket fromCoach: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var modelList: [BaseDailyBriefViewModel] = []
        var messageModels: [FromMyCoachCellViewModel.FromMyCoachMessage] = []
        fromCoach.coachMessages?.forEach {(message) in
            if let date = message.issueDate, let text = message.body {
                let formattedDate = DateFormatter.messageDate.string(from: date)
                messageModels.append(FromMyCoachCellViewModel.FromMyCoachMessage(date: formattedDate, text: text))
            }
        }

        if !messageModels.isEmpty {
            let detailTitle = AppTextService.get(.daily_brief_section_from_my_tignum_coach_title)
            let url = URL(string: fromCoach.coachMessages?.last?.coachProfileImageUrl ?? "")
            let detail = FromMyCoachCellViewModel.FromMyCoachDetail(imageUrl: url, title: detailTitle)
            let model = FromMyCoachCellViewModel(detail: detail, messages: messageModels, domainModel: fromCoach)
            modelList.append(model)
        }
        return modelList
    }

    // MARK: - My sprints
    func createSprintChallenge(bucket sprintBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createSprintChallengeList: [BaseDailyBriefViewModel] = []

        guard sprintBucket.sprint != nil else {
            let relatedStrategiesModels = [SprintChallengeViewModel.RelatedItemsModel()]
            createSprintChallengeList.append(SprintChallengeViewModel(bucketTitle: "",
                                                                       sprintTitle: "",
                                                                       sprintInfo: "",
                                                                       sprintStepNumber: 0,
                                                                       relatedStrategiesModels: relatedStrategiesModels,
                                                                       domainModel: sprintBucket,
                                                                       sprint: sprintBucket.sprint!))
            return createSprintChallengeList
        }
        let searchTag: String = "SPRINT_BUCKET_DAY_" + String(sprintBucket.sprint?.currentDay ?? 0)
        let sprintTag = sprintBucket.sprint?.sprintCollection?.searchTags.filter({ $0 != "SPRINT_REPORT"}).first ?? ""
        let sprintInfo = getSprintInfo(sprintBucket, sprintTag, searchTag)
        var relatedItemsModels: [SprintChallengeViewModel.RelatedItemsModel] = []
        sprintBucket.sprint?.dailyBriefRelatedContents.forEach {(content) in
            relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(content.title,
                                                                                      content.durationString,
                                                                                      content.remoteID ?? 0,
                                                                                      nil,
                                                                                      content.section,
                                                                                      content.contentItems.first?.format,
                                                                                      content.contentItems.count,
                                                                                      nil))
        }
//        adding applinks
        sprintBucket.contentCollections?.filter { $0.searchTags.contains(sprintTag) && $0.searchTags.contains(searchTag)
        }.first?.links.forEach {(link) in
            relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel("action description goes here",
                                                                                 nil,
                                                                                 link.remoteID,
                                                                                 nil,
                                                                                 .Unkown,
                                                                                 .unknown,
                                                                                 1,
                                                                                 link))
        }
        sprintBucket.sprint?.dailyBriefRelatedContentItems.forEach { (contentItem) in
            relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(contentItem.valueText,
                                                                                           contentItem.durationString,
                                                                                           nil,
                                                                                           contentItem.remoteID,
                                                                                           .Unkown,
                                                                                           contentItem.format,
                                                                                           1,
                                                                                           nil))
        }

        createSprintChallengeList.append(SprintChallengeViewModel(bucketTitle: AppTextService.get(.daily_brief_section_sprint_challenge_title),
                                                                   sprintTitle: sprintBucket.sprint?.title,
                                                                   sprintInfo: sprintInfo,
                                                                   sprintStepNumber: sprintBucket.sprint?.currentDay,
                                                                   relatedStrategiesModels: relatedItemsModels,
                                                                   domainModel: sprintBucket,
                                                                   sprint: sprintBucket.sprint!))
        return createSprintChallengeList
    }
}
