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
    internal var viewModelOldListModels: [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>] = []
    internal var isCalculatingImpactReadiness: Bool = false
    internal var teamHeaderItems = [Team.Item]()

    internal var isLoadingBuckets: Bool = false
    internal var needToLoadBuckets: Bool = false

    internal let dailyCheckInResultRequestTimeOut: Int = 20 // seconds
    internal var dailyCheckInResultRequestCheckTimer: Timer?
    internal var targetBucketName: DailyBriefBucketName?
    internal weak var detailsDelegate: BaseDailyBriefDetailsViewControllerInterface?

    var didDailyCheckIn = false
    var hasSiriShortcuts = false
    var hasToBeVision = false
    var hasConnectedWearable = false
    var hasPreparation = false

    internal lazy var firstInstallTimeStamp = UserDefault.firstInstallationTimestamp.object as? Date
    internal lazy var worker = DailyBriefWorker(questionService: QuestionService.main,
                                               userService: UserService.main,
                                               settingService: SettingService.main)

    internal var butcketsToMarkAsSeen = [QDMDailyBriefBucket]()
    internal var markAsSeenBuketTimer: Timer?

    internal func isCelsius() -> Bool {
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: 911, unit: UnitTemperature.celsius)
        let localTemperature = formatter.string(from: measurement)
        let isCelsius =  localTemperature.uppercased().contains("C") ? true : false
        return isCelsius
    }

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
        worker.hasPreparation(completion: {(hasPrep) in
            self.hasPreparation = hasPrep == true
        })

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
                dailyBriefViewModels.append(contentsOf: strongSelf.createGuidedTrack(guidedTrackBucket: bucket,
                                                                                     hasToBeVision: bucket.toBeVision != nil,
                                                                                     hasSeenFoundations: UserDefault.allFoundationsSeen.boolValue))
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

    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation) {
        worker.declineTeamInvite(invitation) {(_) in
        }
    }

    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation) {
        worker.joinTeamInvite(invitation) {(_) in
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
}
