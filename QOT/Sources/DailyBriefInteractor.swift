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
    static let didRateTBV = Notification.Name("didRateTBV")
}

final class DailyBriefInteractor {

    // MARK: - Properties
    private let presenter: DailyBriefPresenterInterface
    private var viewModelOldListModels: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>] = []
    private var isCalculatingImpactReadiness: Bool = false
    private var teamHeaderItems = [Team.Item]()

    private var isLoadingBuckets: Bool = false
    private var needToLoadBuckets: Bool = false

    private let dailyCheckInResultRequestTimeOut: Int = 20 // seconds
    private var dailyCheckInResultRequestCheckTimer: Timer?
    private var targetBucketName: DailyBriefBucketName?
    private weak var detailsDelegate: BaseDailyBriefDetailsViewControllerInterface?

    var didDailyCheckIn = false
    var hasSiriShortcuts = false
    var hasToBeVision = false
    var hasConnectedWearable = false

    private lazy var firstInstallTimeStamp = UserDefault.firstInstallationTimestamp.object as? Date
    private lazy var worker = DailyBriefWorker(questionService: QuestionService.main,
                                               userService: UserService.main,
                                               settingService: SettingService.main)

    private var butcketsToMarkAsSeen = [QDMDailyBriefBucket]()
    private var markAsSeenBuketTimer: Timer?

    // MARK: - Init
    init(presenter: DailyBriefPresenterInterface) {
        self.presenter = presenter
        addObservers()
        getDailyBriefBucketsForViewModel()
    }

    // MARK: - Life Cycle
    func viewDidLoad() {
        presenter.setupView()
        getDailyBriefDummySectionModels()
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
                butcketsToMarkAsSeen.append(bucket)
            }
            markAsSeenBuketTimer?.invalidate()
            markAsSeenBuketTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false, block: { (_) in
                DailyBriefService.main.markAsSeenBuckets(self.butcketsToMarkAsSeen)
                self.butcketsToMarkAsSeen.removeAll()
            })
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

    func addObservers() {
        // Listen about UpSync Daily Check In User Answers
        _ = NotificationCenter.default.addObserver(forName: .requestSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didGetDataSyncRequest(notification)
        }

        _ = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didGetDataSyncRequest(notification)
        }

        _ = NotificationCenter.default.addObserver(forName: .scrollToBucket,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didGetScrollNotificationToBucket(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .userLogout,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didLogout(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .automaticLogout,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didLogout(notification)
        }
    }
}

// MARK: Notification Listeners
extension DailyBriefInteractor {
    @objc func didGetDataSyncRequest(_ notification: Notification) {
        guard let request = notification.object as? SyncRequestContext else { return }
        switch request.dataType {
        case .DAILY_CHECK_IN where request.syncRequestType == .UP_SYNC, .TEAM:
            updateDailyBriefBucket()
        default:
            break
        }

    }

    @objc func didGetDataSyncResult(_ notification: Notification) {
        guard let request = notification.object as? SyncResultContext else { return }
        switch request.dataType {
        case .DAILY_CHECK_IN_RESULT where request.syncRequestType == .DOWN_SYNC:
            updateDailyBriefBucket()
        default:
            break
        }

    }

    @objc func didGetImpactReadinessCellSizeChanges(_ notification: Notification) {
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

    @objc func didLogout(_ notification: Notification) {
        markAsSeenBuketTimer?.invalidate()
        markAsSeenBuketTimer = nil
    }
}

// MARK: - DailyBriefInteractorInterface
extension DailyBriefInteractor: DailyBriefInteractorInterface {
    func setDetailsDelegate(_ delegate: BaseDailyBriefDetailsViewControllerInterface) {
        self.detailsDelegate = delegate
    }

    func getTeamTBVPoll(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        worker.getCurrentTeamToBeVisionPoll(for: team, completion)
    }

    // MARK: - Properties
    var rowViewSectionCount: Int {
        return viewModelOldListModels.count
    }

    // MARK: - Retrieve methods
    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return worker.bucket(at: row)
    }

    func bucketViewModelNew() -> [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]? {
        return viewModelOldListModels
    }

    func getDailyBriefDummySectionModels() {
        var sectionDataList: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>] = []
        sectionDataList.append(ArraySection.init(model: DailyBriefSectionModel.init(title: nil, sortOrder: 0),
                                                 elements: []))
        sectionDataList.append(ArraySection.init(model: DailyBriefSectionModel.init(title: nil, sortOrder: 1),
                                                 elements: []))
        let changeSet = StagedChangeset(source: viewModelOldListModels, target: sectionDataList)
        presenter.updateViewNew(changeSet)
    }

    func getDailyBriefBucketsForViewModel() {
        guard UIApplication.shared.applicationState == .active else {
            needToLoadBuckets = false
            isLoadingBuckets = false
            return
        }

        if isLoadingBuckets {
            needToLoadBuckets = true
            return
        }

        isLoadingBuckets = true
        var dailyBriefViewModels: [BaseDailyBriefViewModel] = []
        var sectionDataList: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>] = []

        worker.getDailyBriefBucketsForViewModel { [weak self] (bucketsList) in
            guard let strongSelf = self,
                bucketsList.filter({ $0.bucketName == .DAILY_CHECK_IN_1 }).first != nil else {
                self?.isLoadingBuckets = false
                if self?.needToLoadBuckets == true {
                    self?.needToLoadBuckets = false
                    self?.getDailyBriefBucketsForViewModel()
                }
                return
            }

            strongSelf.worker.getDailyBriefClusterConfig { (clusterConfig) in
                strongSelf.worker.hasConnectedWearable { (hasConnected) in
                    strongSelf.hasConnectedWearable = hasConnected
                }
                strongSelf.worker.hasSiriShortcuts { (hasShortcuts) in
                    strongSelf.hasSiriShortcuts = hasShortcuts
                }

                dailyBriefViewModels = strongSelf.addBucketModels(from: bucketsList)

                for cluster in clusterConfig {
                    var elements: [BaseDailyBriefViewModel] = []

                    //add all buckets that match the corresponding name to the array
                    for bucket in cluster.buckets where bucket.enabled {
                        let dailyBriefFilteredBuckets = dailyBriefViewModels.filter { $0.domainModel?.bucketName == bucket.name }
                        elements.append(contentsOf: dailyBriefFilteredBuckets)
                    }

                    //create a section model with the previously added elements
                    let clusterTitle = AppTextService.get(AppTextKey.init(cluster.titleKey ?? ""))

                    if cluster.enabled && elements.count > 0 {
                        sectionDataList.append(ArraySection.init(model: DailyBriefSectionModel.init(title: clusterTitle, sortOrder: cluster.sortOrder),
                                                                 elements: elements))
                    }
                }

                sectionDataList = sectionDataList.sorted { $0.model.sortOrder < $1.model.sortOrder }

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
                if changeSet.count == 0 {
                    requestSynchronization(.BUCKET_RECORD, .UP_SYNC)
                }
            }
        }
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        worker.getToBeVisionImage(completion: completion)
    }

    // MARK: Save methods

    func saveTargetValue(value: Int?) {
        worker.saveTargetValue(value: value)
    }

    func customizeSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customizeSleepQuestion(completion: completion)
    }

    func updateViewModelListNew(_ list: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]) {
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
    func addBucketModels(from bucketsList: [QDMDailyBriefBucket]) -> [BaseDailyBriefViewModel] {
        var dailyBriefViewModels: [BaseDailyBriefViewModel] = []
        bucketsList.forEach { [weak self] (bucket) in
            guard let strongSelf = self else {
                self?.isLoadingBuckets = false
                if self?.needToLoadBuckets == true {
                    self?.needToLoadBuckets = false
                    self?.getDailyBriefBucketsForViewModel()
                }
                return
            }
            guard let bucketName = bucket.bucketName else { return }
            switch bucketName {
            case .GUIDE_TRACK:
                dailyBriefViewModels.append(contentsOf: strongSelf.createGuidedTrack(guidedTrackBucket: bucket))
            case .DAILY_CHECK_IN_1:
                strongSelf.hasToBeVision = (bucket.toBeVision != nil)
                strongSelf.didDailyCheckIn = (bucket.dailyCheckInAnswerIds?.isEmpty == false)
                dailyBriefViewModels.append(contentsOf: strongSelf.createImpactReadinessCell(impactReadinessBucket: bucket))
            case .DAILY_CHECK_IN_2:
                dailyBriefViewModels.append(contentsOf: strongSelf.createDailyCheckIn2(dailyCheckIn2Bucket: bucket))
            case .EXPLORE:
                dailyBriefViewModels.append(contentsOf: strongSelf.createExploreModel(exploreBucket: bucket))
            case .ME_AT_MY_BEST:
                dailyBriefViewModels.append(contentsOf: strongSelf.createMeAtMyBest(meAtMyBestBucket: bucket))
            case .GET_TO_LEVEL_5:
                dailyBriefViewModels.append(contentsOf: strongSelf.createLevel5Cell(level5Bucket: bucket))
            case .QUESTION_WITHOUT_ANSWER:
                dailyBriefViewModels.append(contentsOf: strongSelf.createQuestionsWithoutAnswer(questionsWithoutAnswerBucket: bucket))
            case .LATEST_WHATS_HOT:
                dailyBriefViewModels.append(contentsOf: strongSelf.createLatestWhatsHot(whatsHotLatestCell: bucket))
            case .THOUGHTS_TO_PONDER:
                dailyBriefViewModels.append(contentsOf: strongSelf.createThoughtsToPonder(thoughtsToPonderBucket: bucket))
            case .GOOD_TO_KNOW:
                dailyBriefViewModels.append(contentsOf: strongSelf.createGoodToKnow(createGoodToKnowBucket: bucket))
            case .FROM_TIGNUM:
                dailyBriefViewModels.append(contentsOf: strongSelf.createFromTignum(fromTignum: bucket))
            case .LEADERS_WISDOM:
                dailyBriefViewModels.append(contentsOf: strongSelf.createLeaderWisdom(createLeadersWisdom: bucket))
            case .EXPERT_THOUGHTS:
                dailyBriefViewModels.append(contentsOf: strongSelf.createExpertThoughts(createExpertThoughts: bucket))
            case .FROM_MY_COACH:
                dailyBriefViewModels.append(contentsOf: strongSelf.createFromMyCoachModel(fromCoachBucket: bucket))
            case .MY_PEAK_PERFORMANCE:
                dailyBriefViewModels.append(contentsOf: strongSelf.createMyPeakPerformanceModel(myPeakPerformanceBucket: bucket))
            case .SPRINT_CHALLENGE:
                guard bucket.sprint != nil else { break }
                dailyBriefViewModels.append(contentsOf: strongSelf.createSprintChallenge(bucket: bucket))
            case .ABOUT_ME:
                dailyBriefViewModels.append(contentsOf: strongSelf.createAboutMe(aboutMeBucket: bucket))
            case .SOLVE_REFLECTION:
                dailyBriefViewModels.append(contentsOf: strongSelf.createSolveViewModel(bucket: bucket))
            case .WEATHER:
                dailyBriefViewModels.append(contentsOf: strongSelf.createWeatherViewModel(weatherBucket: bucket))
            case .MINDSET_SHIFTER:
                dailyBriefViewModels.append(contentsOf: strongSelf.createMindsetShifterViewModel(mindsetBucket: bucket))
            case .TEAM_TO_BE_VISION:
                dailyBriefViewModels.append(contentsOf: strongSelf.createTeamToBeVisionViewModel(teamVisionBucket: bucket))
            case .TEAM_VISION_SUGGESTION:
                dailyBriefViewModels.append(contentsOf: strongSelf.createTeamVisionSuggestionModel(teamVisionBucket: bucket))
            case .TEAM_INVITATION:
                dailyBriefViewModels.append(contentsOf: strongSelf.createTeamInvitation(invitationBucket: bucket))
            case .TEAM_NEWS_FEED:
                let elements = strongSelf.createTeamNewsFeedViewModel(with: bucket)
                guard elements.isEmpty == false else { break }
                dailyBriefViewModels.append(contentsOf: elements)
            case .TEAM_TOBEVISION_GENERATOR_POLL:
                dailyBriefViewModels.append(contentsOf: strongSelf.createPollOpen(pollBucket: bucket))
            case .TEAM_TOBEVISION_TRACKER_POLL :
                dailyBriefViewModels.append(contentsOf: strongSelf.createRate(rateBucket: bucket))
            default:
                print("Default : \(bucket.bucketName ?? "" )")
            }
        }
        return dailyBriefViewModels
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
    /*
     * Method name:  createImpactReadinessCell.
     * Description: Create the impact readiness model which is required for the dailyCheck in Bucket.
     * Parameters: [QDMDailyBriefBucket]
     */

    // MARK: - Guided tour
    func createGuidedTrack(guidedTrackBucket guidedTrack: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var guidedTrackList: [GuidedTrackViewModel] = []
        let title = AppTextService.get(.daily_brief_section_guided_track_title)
        var items: [GuidedTrackItem] = []

        guidedTrack.contentCollections?.forEach { (contentItem) in
            var title: String = ""
            var image: String = ""
            if let qdmAppLink = contentItem.links.first {
                switch contentItem.searchTags.first {
                case "DB_GUIDED_TRACK_1":
                    title = AppTextService.get(AppTextKey.daily_brief_section_guided_track_video)
                    image = "get-started-video"
                    items.append(GuidedTrackItem.init(title: title,
                                                      image: image,
                                                      appLink: qdmAppLink))
                case "DB_GUIDED_TRACK_2":
                    title = AppTextService.get(AppTextKey.daily_brief_section_guided_track_tbv)
                    image = "get-started-tbv"
                    items.append(GuidedTrackItem.init(title: title,
                                                      image: image,
                                                      appLink: qdmAppLink))
                case "DB_GUIDED_TRACK_4":
                    title = AppTextService.get(AppTextKey.daily_brief_section_guided_track_prepare)
                    image = "get-started-prepare"
                    items.append(GuidedTrackItem.init(title: title,
                                                      image: image,
                                                      appLink: qdmAppLink))
                default:
                    break
                }
            }
        }

        let guidedTrackViewModel = GuidedTrackViewModel.init(title: title,
                                                             items: items,
                                                             domain: guidedTrack)
        guidedTrackList.append(guidedTrackViewModel)

        return guidedTrackList
    }

    // MARK: - Impact Readiness
    func createImpactReadinessCell(impactReadinessBucket impactReadiness: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var impactReadinessList: [BaseDailyBriefViewModel] = []
        var readinessIntro: String? = ""
        var feedback: String? = ""
        var models: [ImpactReadinessScoreViewModel.ImpactDataViewModel] = []
        let impactReadinessImageURL = impactReadiness.toBeVision?.profileImageResource?.url()
        if impactReadiness.dailyCheckInResult?.impactReadiness == nil, impactReadiness.dailyCheckInAnswers == nil {
            readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_empty_body)
        }

        let bucketTitle = AppTextService.get(.daily_brief_section_impact_readiness_title).lowercased().capitalizingFirstLetter()
        var show5DaysImpactReadiness = true
        //If the daily check in completed update the ImpactReadinessCellViewModel
        let readinessscore = Int(impactReadiness.dailyCheckInResult?.impactReadiness ?? -1)
        var enableButton = true
        if impactReadiness.dailyCheckInAnswerIds?.isEmpty != false,
            impactReadiness.dailyCheckInResult == nil {
            show5DaysImpactReadiness = false
            isCalculatingImpactReadiness = false
            dailyCheckInResultRequestCheckTimer?.invalidate()
            dailyCheckInResultRequestCheckTimer = nil
        }

        // check request time for result
        if let answerDate = impactReadiness.dailyCheckInAnswers?.first?.createdOnDevice,
            impactReadiness.dailyCheckInResult == nil {
            readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_loading_body)
            isCalculatingImpactReadiness = true
            if QOTReachability().isReachable == false {
                readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_network_error_body)
                dailyCheckInResultRequestCheckTimer?.invalidate()
                dailyCheckInResultRequestCheckTimer = nil
                show5DaysImpactReadiness = false
                isCalculatingImpactReadiness = false
                enableButton = false
            }
            // if it took longer than dailyCheckInResultRequestTimeOut and still we don't have result
            else if answerDate.dateAfterSeconds(dailyCheckInResultRequestTimeOut) < Date() {
                readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_load_error_body)
                dailyCheckInResultRequestCheckTimer?.invalidate()
                dailyCheckInResultRequestCheckTimer = nil
                show5DaysImpactReadiness = false
                isCalculatingImpactReadiness = false
                enableButton = false
            } else if dailyCheckInResultRequestCheckTimer == nil { // if timer is not triggered.
                dailyCheckInResultRequestCheckTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(2),
                                                                           repeats: true) { (timer) in
                    // try it again
                    log("DailyBriefInteractor: Retry to get Impact Readiness Score", level: .info)
                    requestSynchronization(.DAILY_CHECK_IN, .UP_SYNC)
                    requestSynchronization(.DAILY_CHECK_IN_RESULT, .DOWN_SYNC)
                    self.updateDailyBriefBucket()
                }
            }
        } else if impactReadiness.dailyCheckInResult != nil { // if we got the result.
            dailyCheckInResultRequestCheckTimer?.invalidate()
            dailyCheckInResultRequestCheckTimer = nil
            feedback = impactReadiness.dailyCheckInResult?.feedback
            readinessIntro = AppTextService.get(.daily_brief_section_impact_readiness_intro)
            show5DaysImpactReadiness = true
            isCalculatingImpactReadiness = false
        }

        let impactReadinessModel = ImpactReadinessCellViewModel.init(title: bucketTitle,
                                                                     feedback: feedback,
                                                                     feedbackRelatedLink: impactReadiness.dailyCheckInResult?.feedbackContentItem?.links.first,
                                                                     image: impactReadiness.bucketImages?.first?.mediaUrl,
                                                                     linkCTA: impactReadiness.dailyCheckInResult?.feedbackContentItem?.links.first?.description,
                                                                     dailyCheckImageURL: impactReadinessImageURL,
                                                                     readinessScore: readinessscore,
                                                                     readinessIntro: readinessIntro,
                                                                     isCalculating: isCalculatingImpactReadiness,
                                                                     enableButton: enableButton,
                                                                     domainModel: impactReadiness)
        impactReadinessList.append(impactReadinessModel)
        detailsDelegate?.didUpdateImpactReadiness(with: impactReadinessModel)

        let howYouFeelToday = AppTextService.get(.daily_brief_section_impact_readiness_section_five_days_rolling_body_explainer)
        let sleepQuantity = impactReadiness.dailyCheckInResult?.fiveDaysSleepQuantity ?? 0
        let roundedSleepQuantity = round(10*sleepQuantity)/10
        let sleepQuality = min(impactReadiness.dailyCheckInResult?.fiveDaysSleepQuality ?? 0, 10)
        let maxTrackingDays = impactReadiness.dailyCheckInResult?.maxTrackingDays
        let load = impactReadiness.dailyCheckInResult?.fiveDaysload ?? 0
        let futureLoad = impactReadiness.dailyCheckInResult?.tenDaysFutureLoad ?? 0
        let targetSleepQuantity = impactReadiness.dailyCheckInResult?.targetSleepQuantity ?? 0
        impactReadiness.contentCollections?.filter {$0.searchTags.contains("TITLE") }.forEach {(collection) in
            models.append(ImpactReadinessScoreViewModel.ImpactDataViewModel(title: collection.title,
                                                                            subTitle: collection.contentItems.first?.valueText))
        }
        if show5DaysImpactReadiness {
            let asteriskText = AppTextService.get(.daily_brief_section_impact_readiness_body_missing_five_days_data)
            let hasFullLoadData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForLoad
            let hasFullSleepQuantityData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForSleepQuantity
            let hasFullSleepQualityData = impactReadiness.dailyCheckInResult?.hasFiveDaysDataForSleepQuality

            impactReadinessList.append(ImpactReadinessScoreViewModel.init(howYouFeelToday: howYouFeelToday,
                                                                          asteriskText: asteriskText,
                                                                          image: impactReadiness.bucketImages?.first?.mediaUrl,
                                                                          sleepQuantityValue: roundedSleepQuantity,
                                                                          hasFiveDaySleepQuantityValues: hasFullSleepQuantityData,
                                                                          sleepQualityValue: sleepQuality,
                                                                          hasFiveDaySleepQualityValue: hasFullSleepQualityData,
                                                                          loadValue: load,
                                                                          hasFiveDayLoadValue: hasFullLoadData,
                                                                          futureLoadValue: futureLoad,
                                                                          targetSleepQuantity: targetSleepQuantity,
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
            dailyCheckIn2ViewModel.caption = title
            dailyCheckIn2ViewModel.title = tbvSentence
            dailyCheckIn2ViewModel.body = intro
            dailyCheckIn2ViewModel.image = dailyCheckIn2.bucketImages?.first?.mediaUrl
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
            dailyCheckIn2ViewModel.caption = shpiTitle
            dailyCheckIn2ViewModel.title = question
            dailyCheckIn2ViewModel.body = shpiContent
            dailyCheckIn2ViewModel.image = dailyCheckIn2.bucketImages?.first?.mediaUrl
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
            dailyCheckIn2ViewModel.caption = peakPerformanceTitle
            dailyCheckIn2ViewModel.title = performanceString
            dailyCheckIn2ViewModel.body = performanceBody
            dailyCheckIn2ViewModel.image = dailyCheckIn2.bucketImages?.first?.mediaUrl
            let model = DailyCheckIn2PeakPerformanceModel(title: peakPerformanceTitle, intro: performanceBody, hasNoPerformance: hasNoPerformance)
            dailyCheckIn2ViewModel.dailyCheckIn2PeakPerformanceModel = model
            dailyCheckIn2ViewModel.type = DailyCheckIn2ModelItemType.PEAKPERFORMANCE
        }
        dailyCheckIn2List.append(dailyCheckIn2ViewModel)
        return dailyCheckIn2List
    }

    // MARK: - Explore
    func createExploreModel(exploreBucket explore: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var exploreModelList: [BaseDailyBriefViewModel] = []
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        guard let exploreContentCollections = explore.contentCollections else {

            return exploreModelList
        }
        if let hour = dateComponents.hour {
            if 6 <= hour && hour < 12 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title_new),
                                                             title: exploreContentCollections.first?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.first?.remoteID,
                                                             duration: exploreContentCollections.first?.durationString,
                                                             image: explore.bucketImages?.first?.mediaUrl,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.first?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 12 <= hour && hour < 18 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title_new),
                                                             title: exploreContentCollections.at(index: 1)?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.at(index: 1)?.remoteID,
                                                             duration: exploreContentCollections.first?.durationString,
                                                             image: explore.bucketImages?.first?.mediaUrl,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.at(index: 1)?.section ?? ContentSection.Unkown))
                return exploreModelList
            } else if 18 <= hour && hour <= 24 || hour < 6 {
                exploreModelList.append(ExploreCellViewModel(bucketTitle: AppTextService.get(.daily_brief_section_explore_title_new),
                                                             title: exploreContentCollections.last?.title,
                                                             introText: AppTextService.get(.daily_brief_section_explore_body),
                                                             remoteID: exploreContentCollections.last?.remoteID,
                                                             duration: exploreContentCollections.first?.durationString,
                                                             image: explore.bucketImages?.first?.mediaUrl,
                                                             domainModel: explore,
                                                             section: exploreContentCollections.last?.section ?? ContentSection.Unkown))
                return exploreModelList }
        }
        exploreModelList.append(ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.first?.valueText,
                                                     title: "", introText: "",
                                                     remoteID: 666,
                                                     duration: exploreContentCollections.first?.durationString,
                                                     image: explore.bucketImages?.first?.mediaUrl,
                                                     domainModel: explore,
                                                     section: ContentSection.Unkown))
        return exploreModelList
    }

    // MARK: - Level up
    func createLevel5Cell(level5Bucket level5: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createLevel5List: [BaseDailyBriefViewModel] = []
        var levelMessageModels: [Level5ViewModel.LevelDetail] = []
        let caption = AppTextService.get(.daily_brief_section_level_5_title_new)
        let intro = AppTextService.get(.daily_brief_section_level_5_body)
        let question = AppTextService.get(.daily_brief_section_level_5_question)
        let youRatedPart1 = AppTextService.get(.daily_brief_section_level_5_question_with_data_one)
        let youRatedPart2 = AppTextService.get(.daily_brief_section_level_5_question_with_data_two)
        let confirmationMessage =  AppTextService.get(.daily_brief_section_level_5_alert_body)
        let level1Title = AppTextService.get(.daily_brief_section_level_5_level_1_title)
        let level1Text = AppTextService.get(.daily_brief_section_level_5_level_1_body)
        let comeBackText = level5.bucketText?.contentItems.filter {$0.searchTags.contains("COME_BACK")}.first?.valueText ?? "Noted! Come back in 1 month."
        var questionLevel: String?
        if let lastValue = level5.latestGetToLevel5Value, lastValue > 0 {
            questionLevel = youRatedPart1 + " " + String(lastValue) + " " + youRatedPart2
        } else {
            questionLevel = question
        }

        levelMessageModels.append(Level5ViewModel.LevelDetail.init(levelTitle: question, levelContent: intro))
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

        createLevel5List.append(Level5ViewModel(caption: caption,
                                                intro: intro,
                                                question: questionLevel,
                                                image: level5.bucketImages?.first?.mediaUrl,
                                                youRatedPart1: youRatedPart1,
                                                youRatedPart2: youRatedPart2,
                                                comeBackText: comeBackText,
                                                levelMessages: levelMessageModels,
                                                confirmationMessage: confirmationMessage,
                                                latestSavedValue: level5.latestGetToLevel5Value,
                                                domainModel: level5))
        return createLevel5List
    }

    // MARK: - Tobevision
    func createMeAtMyBest(meAtMyBestBucket meAtMyBest: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var meAtMyBestList: [BaseDailyBriefViewModel] = []
        let createMeAtMyBestTitle = AppTextService.get(.daily_brief_section_my_best_title_new)
        guard createMeAtMyBestTitle.isEmpty == false else { return meAtMyBestList }
        if meAtMyBest.toBeVisionTrack?.sentence?.isEmpty != false {
            let tbvEmptyIntro = AppTextService.get(.daily_brief_section_my_best_empty_body)
            let ctaTBVButtonText = AppTextService.get(.daily_brief_section_my_best_empty_button_create_tbv)
            guard tbvEmptyIntro.isEmpty == false, ctaTBVButtonText.isEmpty == false else { return [] }
            let model = MeAtMyBestCellEmptyViewModel(title: createMeAtMyBestTitle,
                                                     intro: tbvEmptyIntro,
                                                     buttonText: ctaTBVButtonText,
                                                     image: meAtMyBest.toBeVision?.profileImageResource?.urlString() ?? meAtMyBest.bucketImages?.first?.mediaUrl,
                                                     domainModel: meAtMyBest)
            meAtMyBestList.append(model)
            return meAtMyBestList
        } else {
            let tbvIntro = AppTextService.get(.daily_brief_section_my_best_body)
            let tbvSentence = meAtMyBest.toBeVisionTrack?.sentence ?? ""
            let tbvIntro2 = DailyBriefAtMyBestWorker().storedText(meAtMyBest.contentCollections?.filter {$0.searchTags.contains("ME_AT_MY_BEST_REFLECTION")}.randomElement()?.contentItems.first?.valueText ?? " ")
            let ctaTBVButtonText = AppTextService.get(.daily_brief_section_my_best_button_my_tbv)
            if tbvIntro.isEmpty && tbvSentence.isEmpty && tbvIntro2.isEmpty && ctaTBVButtonText.isEmpty {
                return []
            }
            meAtMyBestList.append(MeAtMyBestCellViewModel(title: createMeAtMyBestTitle,
                                                          intro: tbvIntro,
                                                          tbvStatement: "”" + tbvSentence + "”",
                                                          intro2: tbvIntro2,
                                                          buttonText: ctaTBVButtonText,
                                                          image: meAtMyBest.toBeVision?.profileImageResource?.urlString() ?? meAtMyBest.bucketImages?.first?.mediaUrl,
                                                          domainModel: meAtMyBest))
            return meAtMyBestList
        }

    }

    // MARK: - Latest What's hot
    func createLatestWhatsHot(whatsHotLatestCell whatsHotLatest: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var latestWhatsHotList: [BaseDailyBriefViewModel] = []

        guard let collection = whatsHotLatest.contentCollections?.first else {
            return latestWhatsHotList
        }
        latestWhatsHotList.append(WhatsHotLatestCellViewModel(bucketTitle: "test",
                                                              title: collection.title,
                                                              image: collection.thumbnailURLString ?? whatsHotLatest.bucketImages?.first?.mediaUrl,
                                                              author: collection.author ?? "",
                                                              publisheDate: collection.publishedDate ?? Date(),
                                                              timeToRead: collection.durationString,
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
            let detailTitle = AppTextService.get(.daily_brief_section_from_my_tignum_coach_title_new)
            let url = URL(string: fromCoach.coachMessages?.last?.coachProfileImageUrl ?? "")
            let detail = FromMyCoachCellViewModel.FromMyCoachDetail(imageUrl: url, title: detailTitle)
            let model = FromMyCoachCellViewModel(detail: detail,
                                                 messages: messageModels,
                                                 image: fromCoach.bucketImages?.first?.mediaUrl,
                                                 domainModel: fromCoach)
            modelList.append(model)
        }
        return modelList
    }

    // MARK: - Leader Wisdom
    func createLeaderWisdom(createLeadersWisdom leadersWisdom: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var leadersWisdomList: [BaseDailyBriefViewModel] = []
        guard let collection = leadersWisdom.contentCollections?.first else {
            return leadersWisdomList
        }
        leadersWisdomList.append(LeaderWisdomCellViewModel(title: AppTextService.get(.daily_brief_section_leader_wisdom_title_new),
                                                           subtitle: collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_NAME")}.first?.valueText ?? "",
            description: collection.contentItems.filter {$0.searchTags.contains("LEADER_WISDOM_TRANSCRIPT")}.first?.valueText ?? "",
            image: leadersWisdom.bucketImages?.first?.mediaUrl,
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

    // MARK: - Expert Thoughts
    func createExpertThoughts(createExpertThoughts expertThoughts: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var expertThoughtsList: [BaseDailyBriefViewModel] = []
        guard let collection = expertThoughts.contentCollections?.first else {
            return expertThoughtsList
        }
        expertThoughtsList.append(ExpertThoughtsCellViewModel(title: AppTextService.get(.daily_brief_section_expert_thoughts_title_new),
                                                              subtitle: "",
            description: collection.contentItems.filter {$0.searchTags.contains("EXPERT_TRANSCRIPT")}.first?.valueText ?? "",
            image: expertThoughts.bucketImages?.first?.mediaUrl,
            audioTitle: collection.contentItems.filter {$0.searchTags.contains("EXPERT_FILE")}.first?.valueText ?? "",
            audioDuration: collection.contentItems.filter { $0.searchTags.contains("EXPERT_FILE")}.first?.valueDuration,
            audioLink: URL(string: collection.contentItems.filter {$0.searchTags.contains("EXPERT_FILE")}.first?.valueMediaURL ?? ""),
            format: collection.contentItems.filter { $0.searchTags.contains("EXPERT_FILE")}.first?.format ?? .unknown,
            remoteID: collection.contentItems.filter { $0.searchTags.contains("EXPERT_FILE")}.first?.remoteID ?? 0,
            durationString: collection.contentItems.filter { $0.searchTags.contains("EXPERT_FILE")}.first?.durationString ?? "",
            name: collection.contentItems.filter {$0.searchTags.contains("EXPERT_NAME")}.first?.valueText ?? "",
            domainModel: expertThoughts))
        return expertThoughtsList
    }

    // MARK: - Mindset Shifter
    func createMindsetShifterViewModel(mindsetBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var mindsetList: [BaseDailyBriefViewModel] = []
        guard let shifters = mindsetBucket.mindsetShifters else {
            return mindsetList
        }
        let date = Date(timeIntervalSince1970: 0)
        let mindsetShifter = shifters.sorted(by: {$0.createdAt ?? $0.createdOnDevice ?? date > $1.createdAt ?? $1.createdOnDevice ?? date }).first
        guard let createdDate = mindsetShifter?.createdAt,
            createdDate.dateAfterDays(1).isFuture() else {
                return mindsetList
        }
        let model = MindsetShifterViewModel(caption: AppTextService.get(.daily_brief_section_mindset_shifter_card_caption),
                                            title: AppTextService.get(.daily_brief_section_mindset_shifter_card_title),
                                            body: AppTextService.get(.daily_brief_section_mindset_shifter_card_body),
                                            image: mindsetBucket.bucketImages?.first?.mediaUrl,
                                            subtitle: AppTextService.get(.daily_brief_section_mindset_shifter_subtitle),
                                            mindsetShifter: mindsetShifter,
                                            domainModel: mindsetBucket)
        mindsetList.append(model)
        return mindsetList
    }

    // MARK: - My Peak Performances
    func createMyPeakPerformanceModel(myPeakPerformanceBucket myPeakperformance: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createMyPeakPerformanceList: [BaseDailyBriefViewModel] = []
        let bucketTitle = AppTextService.get(.daily_brief_section_my_peak_performances_title_new)
        var contentSentence = ""
        var contentSubtitle = ""
        let beginingOfToday = Date().beginingOfDate()
        let endOfToday = Date().endOfDay()
        let yesterday = -1, tomorrow = 1, threeDays = 3
        let tags: [MyPeakPerformanceBucketType] = [.TODAY, .TOMORROW, .IN_THREE_DAYS, .REFLECT]
        for tag in tags {
            var localPreparationList = [QDMUserPreparation]()
            switch tag {
            case .IN_THREE_DAYS:
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_3_DAYS_BEFORE")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    let remainingDays = beginingOfToday.days(to: date)
                    return remainingDays == threeDays
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_in_three_days_card_subtitle)
            case .TOMORROW:
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_BEFORE")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday.days(to: date) == tomorrow
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_tomorrow_label)
            case .TODAY:
                contentSentence = myPeakperformance.contentCollections?.filter {
                    $0.searchTags.contains("MY_PEAK_PERFORMANCE_SAME_DAY")
                }.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter {
                    guard let date = $0.eventDate else { return false }
                    return beginingOfToday == date.beginingOfDate()
                    } ?? [QDMUserPreparation]()
                contentSubtitle = AppTextService.get(.daily_brief_section_my_peak_performances_section_today_label)
            case .REFLECT:
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
                    let subtitle = prepareItem.eventType ?? ""  + DateFormatter.tbvTracker.string(from: prepareItem.eventDate ?? Date())
                    createMyPeakPerformanceList.append(PeakPerformanceViewModel.init(title: bucketTitle,
                                                                                     contentSubtitle: contentSubtitle,
                                                                                     contentSentence: contentSentence,
                                                                                     eventTitle: prepareItem.eventTitle ?? prepareItem.name,
                                                                                     eventSubtitle: subtitle,
                                                                                     image: myPeakperformance.bucketImages?.first?.mediaUrl,
                                                                                     qdmUserPreparation: prepareItem,
                                                                                     domainModel: myPeakperformance))
                })
            }
        }
        return createMyPeakPerformanceList
    }

    // MARK: - My Stats
    func createAboutMe(aboutMeBucket aboutMeModel: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var aboutMeList: [BaseDailyBriefViewModel] = []
        let aboutMeBucketTitle = AppTextService.get(.daily_brief_section_my_stats_title_new)
        let aboutMeContent = aboutMeModel.stringValue ?? ""
        let aboutMeAdditionalContent = aboutMeModel.additionalDescription

        aboutMeList.append(AboutMeViewModel(title: aboutMeBucketTitle,
                                            aboutMeContent: aboutMeContent,
                                            aboutMeMoreInfo: aboutMeAdditionalContent,
                                            image: aboutMeModel.bucketImages?.first?.mediaUrl,
                                            domainModel: aboutMeModel))
        return aboutMeList
    }

    // MARK: - Solve Reminder
    func createSolveViewModel(bucket solveBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createSolveList: [BaseDailyBriefViewModel] = []
        guard (solveBucket.solves?.first) != nil else {
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

    // MARK: - Good to Know
    func createGoodToKnow(createGoodToKnowBucket createGoodToKnow: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createGoodToKnowList: [BaseDailyBriefViewModel] = []
        guard let collection = createGoodToKnow.contentCollections?.first else {
            return createGoodToKnowList }
        createGoodToKnowList.append(GoodToKnowCellViewModel(title: AppTextService.get(.daily_brief_section_good_to_know_title_new),
                                                            fact: collection.contentItems.first?.valueText,
                                                            copyright: collection.contentItems.filter {$0.format == .subtitle }.first?.valueText,
                                                            image: createGoodToKnow.bucketImages?.first?.mediaUrl,
                                                            domainModel: createGoodToKnow))
        return createGoodToKnowList
    }

    // MARK: - Big questions
    func createQuestionsWithoutAnswer(questionsWithoutAnswerBucket questionsWithoutAnswer: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createQuestionWithoutAnswerList: [BaseDailyBriefViewModel] = []

        guard let collection = questionsWithoutAnswer.contentCollections?.first else {
            createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: "", text: "", image: nil, domainModel: questionsWithoutAnswer))
            return createQuestionWithoutAnswerList
        }
        createQuestionWithoutAnswerList.append(QuestionCellViewModel(title: AppTextService.get(.daily_brief_section_big_questions_title_new),
                                                                     text: collection.contentItems.first?.valueText,
                                                                     image: questionsWithoutAnswer.bucketImages?.first?.mediaUrl,
                                                                     domainModel: questionsWithoutAnswer))
        return createQuestionWithoutAnswerList
    }

    // MARK: - Big Thoughts
    func createThoughtsToPonder(thoughtsToPonderBucket thoughtsToPonder: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createThoughtsToPonderList: [BaseDailyBriefViewModel] = []

        guard let collection = thoughtsToPonder.contentCollections?.first else {
            createThoughtsToPonderList.append(ThoughtsCellViewModel(caption: AppTextService.get(.daily_brief_section_big_thoughts_title_new),
                                                                    thought: "",
                                                                    author: "",
                                                                    image: thoughtsToPonder.bucketImages?.first?.mediaUrl,
                                                                    domainModel: thoughtsToPonder))
            return createThoughtsToPonderList

        }
        createThoughtsToPonderList.append(ThoughtsCellViewModel(caption: AppTextService.get(.daily_brief_section_big_thoughts_title_new),
                                                                thought: collection.contentItems.first?.valueText ?? "",
                                                                author: collection.author ?? "",
                                                                image: thoughtsToPonder.bucketImages?.first?.mediaUrl,
                                                                domainModel: thoughtsToPonder))
        return createThoughtsToPonderList
    }

    // MARK: - Tignum Messages
    func createFromTignum(fromTignum: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromTignumList: [BaseDailyBriefViewModel] = []
        let bucketTitle = AppTextService.get(.daily_brief_section_from_tignum_title_new)
        guard (fromTignum.contentCollections?.first) != nil, isValidFromTignumBucket(fromTignum) else {
            return createFromTignumList
        }

        fromTignum.contentCollections?.forEach {(fromTignumModel) in
            createFromTignumList.append(FromTignumCellViewModel(title: bucketTitle,
                                                                text: fromTignumModel.contentItems.first?.valueText ?? "",
                                                                subtitle: fromTignumModel.title,
                                                                image: fromTignum.bucketImages?.first?.mediaUrl,
                                                                cta: fromTignumModel.contentItems.first?.links.first?.description,
                                                                link: fromTignumModel.contentItems.first?.links.first,
                                                                domainModel: fromTignum))
        }
        return createFromTignumList
    }

    // MARK: - My sprints
    func createSprintChallenge(bucket sprintBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createSprintChallengeList: [SprintChallengeViewModel] = []
        guard sprintBucket.sprint != nil else {
            return createSprintChallengeList
        }
        var relatedItemsModels: [SprintChallengeViewModel.RelatedItemsModel] = []
        for index in 0...5 {
            let searchTag: String = "SPRINT_BUCKET_DAY_" + String(index)
            let sprintTag = sprintBucket.sprint?.sprintCollection?.searchTags.filter({ $0 != "SPRINT_REPORT"}).first ?? ""
            let sprintContentCollections = sprintBucket.contentCollections?.filter {
                $0.searchTags.contains(searchTag) && $0.searchTags.contains(sprintTag)
            }
            let sprintContentItems = sprintContentCollections?.first?.contentItems
            let sprintInfo = sprintContentItems?.first?.valueText ?? ""
            if sprintContentItems?.count ?? 0 > 1, index == 0 {
                let sprintMedia = sprintContentItems?[1]
                relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(sprintMedia?.valueText,
                                                                                     sprintMedia?.durationString,
                                                                                     sprintMedia?.remoteID,
                                                                                     nil,
                                                                                     nil,
                                                                                     sprintMedia?.format,
                                                                                     1,
                                                                                     nil,
                                                                                     sprintMedia?.valueImageURL,
                                                                                     sprintMedia?.valueMediaURL,
                                                                                     searchTag))
            } else {
                sprintContentCollections?.forEach {(collection) in
                    // Related ContentItems
                    collection.relatedContentItems.forEach {(contentItem) in
                        relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(contentItem.valueText,
                                                                                             contentItem.durationString,
                                                                                             nil,
                                                                                             contentItem.remoteID,
                                                                                             .Unkown,
                                                                                             contentItem.format,
                                                                                             1,
                                                                                             nil,
                                                                                             nil,
                                                                                             nil,
                                                                                             searchTag))
                    }
                    // Related Applinks
                    collection.links.forEach {(link) in
                        relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(link.description,
                                                                                             nil,
                                                                                             link.remoteID,
                                                                                             nil,
                                                                                             .Unkown,
                                                                                             .unknown,
                                                                                             1,
                                                                                             link,
                                                                                             nil,
                                                                                             nil,
                                                                                             searchTag))
                    }
                    // Related Contents
                    sprintBucket.sprint?.dailyBriefRelatedContent[index]?.forEach {(relatedContent) in
                        relatedItemsModels.append(SprintChallengeViewModel.RelatedItemsModel(relatedContent.title,
                                                                                             relatedContent.durationString,
                                                                                             relatedContent.remoteID ?? 0,
                                                                                             nil,
                                                                                             relatedContent.section,
                                                                                             relatedContent.contentItems.first?.format,
                                                                                             relatedContent.contentItems.count,
                                                                                             nil,
                                                                                             nil,
                                                                                             nil,
                                                                                             searchTag))
                    }
                }
            }
            let imageTag = "DAY_" + String(index)
            let image = sprintBucket.bucketImages?.filter({ $0.label == imageTag }).first?.mediaUrl
            createSprintChallengeList.append(SprintChallengeViewModel(bucketTitle: AppTextService.get(.daily_brief_section_sprint_challenge_title),
                                                                      sprintTitle: sprintBucket.sprint?.title,
                                                                      sprintInfo: sprintInfo,
                                                                      image: image,
                                                                      sprintStepNumber: index,
                                                                      relatedStrategiesModels: relatedItemsModels,
                                                                      domainModel: sprintBucket,
                                                                      sprint: sprintBucket.sprint!))
        }
        return [SprintsCollectionViewModel.init(items: createSprintChallengeList, domainModel: sprintBucket)]
    }

    // MARK: - New TeamToBeVision
    func createTeamToBeVisionViewModel(teamVisionBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var visionList: [BaseDailyBriefViewModel] = []
        var visionAndDates: [(QDMTeamToBeVision, Date)] = [(QDMTeamToBeVision(), Date())]
        teamVisionBucket.teamToBeVisions?.forEach { (vision) in
            let dates: [Date] = [vision.createdAt ?? Date.distantPast,
                                 vision.modifiedAt ?? Date.distantPast,
                                 vision.modifiedOnDevice ?? Date.distantPast,
                                 vision.createdOnDevice ?? Date.distantPast]
            let mostRecentDate = dates.max()
            guard let recentDate = mostRecentDate else { return }
            let dateVision = (vision, recentDate)
            visionAndDates.append(dateVision)
        }
        visionAndDates.removeFirst()
        let beginingOfDay = Date().beginingOfDate()
        visionAndDates = visionAndDates.filter({ $0.1 > beginingOfDay })
        visionAndDates.sort(by: {$0.1 > $1.1})
        let latestVision = visionAndDates.first?.0
        let imageURL = latestVision?.profileImageResource?.remoteURLString == nil ? teamVisionBucket.bucketImages?.first?.mediaUrl : latestVision?.profileImageResource?.remoteURLString
        let visionText = latestVision?.text
        let team = teamVisionBucket.myTeams?.filter { $0.qotId == latestVision?.teamQotId }.first
        let title = AppTextService.get(.daily_brief_vision_suggestion_caption).replacingOccurrences(of: "${team}", with: team?.name ?? "")
        guard visionText?.isEmpty == false else {
            return visionList
        }
        let quotesVision = "\"" + (visionText ?? "") + "\""
        let model = TeamToBeVisionCellViewModel(title: title, teamVision: quotesVision, team: team, imageURL: imageURL, domainModel: teamVisionBucket)
        visionList.append(model)
        return visionList
    }

    // MARK: - TeamToBeVision Sentence
    func createTeamVisionSuggestionModel(teamVisionBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var teamVisionList: [BaseDailyBriefViewModel] = []
        guard let collections = teamVisionBucket.contentCollections else {
            return teamVisionList
        }
        let date = Date(timeIntervalSince1970: 0)
        let vision = teamVisionBucket.teamToBeVisions?.sorted(by: { $0.createdAt ?? date > $1.createdAt ?? date }).first
        guard vision != nil else { return teamVisionList }
        let imageURL = vision?.profileImageResource?.remoteURLString == nil ? teamVisionBucket.bucketImages?.first?.mediaUrl : vision?.profileImageResource?.remoteURLString
        let team = teamVisionBucket.myTeams?.filter { $0.qotId == vision?.teamQotId }.first
        let visionSentence = "\"" + (vision?.sentences.first?.sentence ?? "") + "\""
        let title = AppTextService.get(.my_x_team_tbv_new_section_header_title).replacingOccurrences(of: "{$TEAM_NAME}", with: team?.name ?? "").uppercased()
        let suggestion = DailyBriefAtMyBestWorker().storedTeamVisionText(collections.randomElement()?.contentItems.first?.valueText ?? " ")
        let model = TeamVisionSuggestionModel(title: title, team: team, tbvSentence: visionSentence, adviceText: suggestion, imageURL: imageURL, domainModel: teamVisionBucket)
        teamVisionList.append(model)
        return teamVisionList
    }

    // MARK: - Team Invitation
    func createTeamInvitation(invitationBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var invitationList: [BaseDailyBriefViewModel] = []
        let teamOwner = invitationBucket.teamInvitations?.first?.sender
        var teamNames: [String] = []
        invitationBucket.teamInvitations?.forEach {(invitation) in
            teamNames.append(invitation.team?.name ?? "")
        }
        let inviteCount = teamNames.count
        let multipleInvitesTitle = AppTextService.get(.daily_brief_team_invitation_multiple_teams_title)
            .replacingOccurrences(of: "${invitations_count}", with: String(describing: inviteCount))
        let singleInviteTitle = AppTextService.get(.daily_brief_single_team_invitation_title)
            .replacingOccurrences(of: "${team}", with: teamNames.first?.uppercased() ?? "")
        let title = inviteCount > 1 ? multipleInvitesTitle : singleInviteTitle
        let model = TeamInvitationModel(title: title, teamOwner: teamOwner, teamNames: teamNames, teamInvitations: invitationBucket.teamInvitations, image: invitationBucket.bucketImages?.first?.mediaUrl, domainModel: invitationBucket)
        invitationList.append(model)
        return invitationList
    }

    // MARK: - Poll is Open
    func createPollOpen(pollBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var openPollList: [BaseDailyBriefViewModel] = []
        let openPolls = pollBucket.teamToBeVisionPolls?.filter { $0.open == true }
        openPolls?.forEach { (openPoll) in
            guard openPoll.creator == false,
                  openPoll.userDidVote == false,
                  let team = pollBucket.myTeams?.filter({ $0.qotId == openPoll.teamQotId }).first else { return }
            let teamOwner = team.members?.filter { $0.isTeamOwner == true }.first
            let teamVision = pollBucket.teamToBeVisions?.filter { $0.teamQotId == openPoll.teamQotId }
            let teamImage = teamVision?.first?.profileImageResource?.remoteURLString
            let image = teamImage == nil ? pollBucket.bucketImages?.first?.mediaUrl : teamImage
            let model = PollOpenModel(team: team, teamAdmin: teamOwner?.email, imageURL: image, domainModel: pollBucket)
            openPollList.append(model)
        }
        return openPollList
    }

    // MARK: - Rate is Open
    func createRate(rateBucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var ratingBucketList: [BaseDailyBriefViewModel] = []
        let openRatings = rateBucket.teamToBeVisionTrackerPolls?.filter { $0.open == true }
        openRatings?.forEach { (openRatings) in
            if openRatings.didVote == false {
                guard openRatings.creator == false,
                      let team = rateBucket.myTeams?.filter({ $0.qotId == openRatings.teamQotId }).first else { return }
                let teamVision = rateBucket.teamToBeVisions?.filter { $0.teamQotId == openRatings.teamQotId }.first
                let imageURL = teamVision?.profileImageResource?.remoteURLString == nil ? rateBucket.bucketImages?.first?.mediaUrl : teamVision?.profileImageResource?.remoteURLString
                let teamOwner = team.members?.filter { $0.isTeamOwner == true }.first
                let openRateModel = RateOpenModel(team: team, ownerEmail: teamOwner?.email, imageURL: imageURL, domainModel: rateBucket)
                ratingBucketList.append(openRateModel)
            }
        }
        let finishedRatings = rateBucket.teamToBeVisionTrackerPolls?.filter { $0.open == false }
        finishedRatings?.forEach {(closedRating) in
            guard let team = rateBucket.myTeams?.filter({ $0.qotId == closedRating.teamQotId }).first else { return }
            guard let ratingFeedback = closedRating.feedback, let averageValue = closedRating.averageValue else { return }
            let teamVision = rateBucket.teamToBeVisions?.filter { $0.teamQotId == closedRating.teamQotId }.first
            let imageURL = teamVision?.profileImageResource?.remoteURLString == nil ? rateBucket.bucketImages?.first?.mediaUrl : teamVision?.profileImageResource?.remoteURLString
            let feedbackModel = RatingFeedbackModel(team: team, feedback: ratingFeedback, averageValue: averageValue, imageURL: imageURL, domainModel: rateBucket)
            ratingBucketList.append(feedbackModel)
        }
        return ratingBucketList
    }

    // MARK: - Weather
    func createWeatherViewModel(weatherBucket: QDMDailyBriefBucket?) -> [BaseDailyBriefViewModel] {
        var weatherList: [BaseDailyBriefViewModel] = []
        let title = weatherBucket?.bucketName?.lowercased().capitalizingFirstLetter() ?? ""

        let intro = weatherBucket?.bucketText?.contentItems.filter({
            $0.searchTags.contains(obj: "BUCKET_INTRO")
        }).first?.valueText ?? "BUCKET_INTRO"

        let requestLocationPermissionDescription = AppTextService.get(.daily_brief_section_weather_empty_body_under_pic)
        let deniedLocationPermissionDescription = AppTextService.get(.daily_brief_section_weather_empty_body_under_pic)
        let accessLocationPermissionTitle = AppTextService.get(.daily_brief_section_weather_card_title)
        let celciusImageUrl = weatherBucket?.bucketImages?.filter ({$0.label == "CELSIUS"}).first?.mediaUrl
        let fahrenheitImageUrl = weatherBucket?.bucketImages?.filter ({$0.label == "FAHRENHEIT"}).first?.mediaUrl
        let image = isCelsius() ? celciusImageUrl : fahrenheitImageUrl
        let locationPermission = AppCoordinator.permissionsManager?.currentStatusFor(for: .location) ?? .notDetermined
        weatherList.append(WeatherViewModel(bucketTitle: title,
                                            intro: intro,
                                            requestLocationPermissionDescription: requestLocationPermissionDescription,
                                            deniedLocationPermissionDescription: deniedLocationPermissionDescription,
                                            accessLocationPermissionTitle: accessLocationPermissionTitle,
                                            locationName: weatherBucket?.weather?.locationName,
                                            locationPermissionStatus: locationPermission,
                                            weatherImage: image,
                                            domain: weatherBucket))

        return weatherList
    }

    // MARK: - Team News Feed
    func createTeamNewsFeedViewModel(with bucket: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        let libraryFeeds = bucket.teamNewsFeeds?.filter({
            $0.teamNewsFeedActionType == .STORAGE_ADDED && $0.teamStorage?.isMine == false
        }) ?? []
        guard libraryFeeds.isEmpty == false else { return [] }
        let teamQotIds = Set(libraryFeeds.compactMap({ $0.teamStorage?.teamQotId })).sorted()
        var models: [BaseDailyBriefViewModel] = []
        for teamQotId in teamQotIds {
            let filteredFeeds = libraryFeeds.filter({ $0.teamQotId == teamQotId })
            if let firstFeed = filteredFeeds.first,
               let team = firstFeed.team,
               let vision = bucket.teamToBeVisions?.filter({ $0.teamId == team.remoteID }).first,
               let imageURL = vision.profileImageResource?.remoteURLString == nil ? bucket.bucketImages?.first?.mediaUrl : vision.profileImageResource?.remoteURLString,
               firstFeed.teamStorage != nil {
                models.append(TeamNewsFeedDailyBriefViewModel(team: team,
                                                              title: AppTextService.get(.daily_brief_news_feed_title),
                                                              itemsAdded: filteredFeeds.count,
                                                              imageURL: imageURL,
                                                              domainModel: bucket))
            }
        }
        return models
    }

    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation) {
        worker.declineTeamInvite(invitation) {(teams) in
        }
    }

    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation) {
        worker.joinTeamInvite(invitation) {(teams) in
            NotificationCenter.default.post(name: .changedInviteStatus,
                                            object: nil,
                                            userInfo: nil)
        }
    }

    func markAsRead(teamNewsFeed: QDMTeamNewsFeed?, _ completion: @escaping () -> Void) {
        worker.markAsRead(teamNewsFeed: teamNewsFeed) {
            completion()
        }
    }

    private func isCelsius() -> Bool {
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: 911, unit: UnitTemperature.celsius)
        let localTemperature = formatter.string(from: measurement)
        let isCelsius =  localTemperature.uppercased().contains("C") ? true : false
        return isCelsius
    }
}
