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

        // Listen about Expend/Collapse
        NotificationCenter.default.addObserver(self, selector: #selector(didGetImpactReadinessCellSizeChanges(_ :)),
                                               name: .dispayDailyCheckInScore, object: nil)

        // Listen about Expend/Collapse of Closed Guided Track
        NotificationCenter.default.addObserver(self, selector: #selector(didGuidedClosedCellSizeChanges(_ :)),
                                               name: .displayGuidedTrackRows, object: nil)

        getDailyBriefBucketsForViewModel()
    }
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: Notification Listeners
extension DailyBriefInteractor {
    @objc func didGetImpactReadinessCellSizeChanges(_ notification: Notification) {
        expendImpactReadiness = !expendImpactReadiness
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didUpdateDailyBriefBuckets, object: nil)
        }
    }
//  Display the expand/collapse of the guided close track
    @objc func didGuidedClosedCellSizeChanges(_ notification: Notification) {
        guidedClosedTrack = !guidedClosedTrack
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didUpdateDailyBriefBuckets, object: nil)
        }
    }
}

// MARK: - DailyBriefInteractorInterface

extension DailyBriefInteractor: DailyBriefInteractorInterface {

    func showPrepareScreen() {

    }

    func updateViewModelList(_ list: [BaseDailyBriefViewModel]) {
        viewModelOldList = list
    }

    func updateViewModelListNew(_ list: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]) {
        viewModelOldListModels = list
    }

    func getDailyBriefBucketsForViewModel() {
        var sectionDataList: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
        worker.getDailyBriefBucketsForViewModel { (bucketsList) in
            bucketsList.forEach { (bucket) in
                switch bucket.bucketName {
                case .DAILY_CHECK_IN_1?:
                    sectionDataList.append(ArraySection(model: .dailyCheckIn1, elements: self.createImpactReadinessCell(impactReadinessBucket: bucket)))
                case .DAILY_CHECK_IN_2?:
                    sectionDataList.append(ArraySection(model: .dailyCheckIn2, elements: self.createDailyCheckIn2(dailyCheckIn2Bucket: bucket)))
                case .EXPLORE?:
                    sectionDataList.append(ArraySection(model: .explore, elements: self.createExploreModel(exploreBucket: bucket)))
                case .ME_AT_MY_BEST?:
                    sectionDataList.append(ArraySection(model: .meAtMyBest, elements: self.createMeAtMyBest(meAtMyBestBucket: bucket)))
                case .GET_TO_LEVEL_5?:
                    sectionDataList.append(ArraySection(model: .getToLevel5, elements: self.createLevel5Model(level5Bucket: bucket)))
                case .QUESTION_WITHOUT_ANSWER?:
                    sectionDataList.append(ArraySection(model: .questionWithoutAnswer, elements: self.createQuestionsWithoutAnswer(questionsWithoutAnswerBucket: bucket)))
                case .LATEST_WHATS_HOT?:
                    sectionDataList.append(ArraySection(model: .whatsHotLatest, elements: self.createLatestWhatsHot(whatsHotLatestCell: bucket)))
                case .THOUGHTS_TO_PONDER?:
                    sectionDataList.append(ArraySection(model: .thoughtsToPonder, elements: self.createThoughtsToPonder(thoughtsToPonderBucket: bucket)))
                case .GOOD_TO_KNOW?:
                    sectionDataList.append(ArraySection(model: .goodToKnow, elements: self.createGoodToKnow(createGoodToKnowBucket: bucket)))
                case .FROM_TIGNUM?:
                    sectionDataList.append(ArraySection(model: .fromTignum, elements: self.createFromTignum(fromTignum: bucket)))
                case .BESPOKE?:
                    sectionDataList.append(ArraySection(model: .bespoke, elements: self.createBeSpokeModel(beSpokeModelBucket: bucket)))
                case .DEPARTURE_INFO?:
                    sectionDataList.append(ArraySection(model: .departureInfo, elements: self.createDepatureInfo(depatureInfoBucket: bucket)))
                case .LEADERS_WISDOM?:
                    sectionDataList.append(ArraySection(model: .leaderswisdom, elements: self.createLeaderWisdom(createLeadersWisdom: bucket)))
                case .FEAST_OF_YOUR_EYES?:
                    sectionDataList.append(ArraySection(model: .feastForYourEyes, elements: self.createFeastForEyesModel(feastForEyesBucket: bucket)))
                case .FROM_MY_COACH?:
                    sectionDataList.append(ArraySection(model: .fromMyCoach, elements: self.createFromMyCoachModel(fromCoachBucket: bucket)))
                case .MY_PEAK_PERFORMANCE?:
                    sectionDataList.append(ArraySection(model: .myPeakPerformance, elements: self.createMyPeakPerformanceModel(myPeakPerformanceBucket: bucket)))
                case .SPRINT_CHALLENGE?:
                    if let sprint = bucket.sprint {
                        sectionDataList.append(ArraySection(model: .sprint, elements: self.createSprintChallenge(bucket: bucket)))
                    }
                case .ABOUT_ME?:
                    sectionDataList.append(ArraySection(model: .aboutMe, elements: self.createAboutMe(aboutMeBucket: bucket)))
                case .SOLVE_REFLECTION?:
                    sectionDataList.append(ArraySection(model: .solveReflection, elements: self.createSolveViewModel(bucket: bucket)))
//               case .GUIDED_TRACK?:
//                    sectionDataList.append(ArraySection(model: .guidedTrack, elements: self.createGuidedTrack(guidedTrackBucket: bucket)))
                default:
                    print(bucket.bucketName)
                    print("Default")
                }
            }
            let changeSet = StagedChangeset(source: self.viewModelOldListModels, target: sectionDataList)
            self.presenter.updateViewNew(changeSet)
        }
    }

    func presentCopyRight(copyrightURL: String?) {
        router.presentCopyRight(copyrightURL: copyrightURL)
    }

    var rowCount: Int {
        return worker.rowCount
    }
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

    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return worker.bucket(at: row)
    }

    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel? {
        return viewModelOldList.at(index: row)
    }

    func bucketViewModelNew() -> [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]? {
        return viewModelOldListModels
    }

    func latestWhatsHotCollectionID(completion: @escaping ((Int?) -> Void)) {
        worker.latestWhatsHotCollectionID(completion: completion)
    }

    func latestWhatsHotContent(completion: @escaping ((QDMContentItem?) -> Void)) {
        worker.latestWhatsHotContent(completion: completion)
    }
    func getContentCollection(completion: @escaping ((QDMContentCollection?) -> Void)) {
        worker.getContentCollection(completion: completion)
    }

    func presentWhatsHotArticle(selectedID: Int) {
        router.presentWhatsHotArticle(selectedID: selectedID)
    }

    func getToBeVisionImage(completion: @escaping (URL?) -> Void) {
        worker.getToBeVisionImage(completion: completion)
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

    func showSolveResults(solve: QDMSolve) {
        router.showSolveResults(solve: solve)
    }

    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void) {
        worker.createLatestWhatsHotModel(completion: completion)
    }

    func showCustomizeTarget() {
        worker.customzieSleepQuestion { [weak self] (model) in
            self?.router.showCustomizeTarget(model)
        }
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
                                                                                           content.contentItems.first?.durationString,
                                                                                           content.remoteID ?? 0,
                                                                                           content.section,
                                                                                           content.contentItems.first?.format,
                                                                                           content.contentItems.count))
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

    func getSprintInfo(_ bucket: QDMDailyBriefBucket, _ tag1: String, _ tag2: String) -> String {
        return bucket.contentCollections?.filter {
            $0.searchTags.contains(tag1) && $0.searchTags.contains(tag2)
            }.first?.contentItems.first?.valueText ?? ""
    }

    func createFromTignum(fromTignum: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromTignumList: [BaseDailyBriefViewModel] = []
        let bucketTitle = fromTignum.bucketText?.contentItems.first?.valueText ?? ""
        guard (fromTignum.contentCollections?.first) != nil else {
            createFromTignumList.append( FromTignumCellViewModel(title: "", text: "", subtitle: "", domainModel: fromTignum))
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
        if meAtMyBest.toBeVision == nil {
            let tbvEmptyIntro = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_NULL_STATE_INTRO")}.first?.valueText ?? "intro_empty"
            let ctaTBVButtonText = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_NULL_STATE_CTA")}.first?.valueText ?? "Create your To Be  Vision"
            meAtMyBestList.append( MeAtMyBestCellViewModel(title: createMeAtMyBestTitle, intro: tbvEmptyIntro, tbvStatement: "", intro2: "", buttonText: ctaTBVButtonText, domainModel: meAtMyBest))
            return meAtMyBestList
        } else {
            let tbvIntro = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_INTRO")}.first?.valueText ?? "intro"
            let tbvSentence = meAtMyBest.toBeVisionTrack?.sentence ?? ""
            let tbvIntro2 = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_INTRO_2")}.first?.valueText ?? "intro2 "
            let ctaTBVButtonText = meAtMyBest.bucketText?.contentItems.filter {$0.searchTags.contains("ME_AT_MY_BEST_CTA")}.first?.valueText ?? "Rate"
            meAtMyBestList.append(MeAtMyBestCellViewModel(title: createMeAtMyBestTitle, intro: tbvIntro, tbvStatement: tbvSentence, intro2: tbvIntro2, buttonText: ctaTBVButtonText, domainModel: meAtMyBest))
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
                                                             domainModel: feastForEyes))
            return createFeastForEyesList

        }
        createFeastForEyesList.append(FeastCellViewModel(title: feastForEyes.bucketText?.contentItems.first?.valueText,
                                                         image: collection.thumbnailURLString ?? "",
                                                         remoteID: collection.contentItems.first?.remoteID,
                                                         domainModel: feastForEyes))
        return createFeastForEyesList
    }

    func createFromMyCoachModel(fromCoachBucket fromCoach: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createFromMyCoachModelList: [BaseDailyBriefViewModel] = []
        var messageModels: [FromMyCoachCellViewModel.FromMyCoachMessage] = []
        fromCoach.coachMessages?.forEach {(message) in
            messageModels.append(FromMyCoachCellViewModel.FromMyCoachMessage(date: DateFormatter.messageDate.string(from: message.issueDate!), text: message.body ?? ""))
        }
        createFromMyCoachModelList.append(FromMyCoachCellViewModel(detail: FromMyCoachCellViewModel.FromMyCoachDetail(imageUrl: URL(string: fromCoach.coachMessages?.last?.coachProfileImageUrl ?? ""), title: fromCoach.bucketText?.contentItems.first?.valueText ?? "FROM MY COACH"), messages: messageModels, domainModel: fromCoach))
        return createFromMyCoachModelList
    }

    func createBeSpokeModel(beSpokeModelBucket beSpoke: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createBeSpokeModelList: [BaseDailyBriefViewModel] = []

        guard let collection = beSpoke.contentCollections?.first else {
            createBeSpokeModelList.append(BeSpokeCellViewModel(bucketTitle: "", title: "", description: "", image: "", domainModel: nil))
            return createBeSpokeModelList

        }
        createBeSpokeModelList.append(BeSpokeCellViewModel(bucketTitle: beSpoke.bucketText?.contentItems.first?.valueText,
                                                           title: collection.title,
                                                           description: collection.contentItems.first?.valueText,
                                                           image: collection.thumbnailURLString ?? "",
                                                           domainModel: beSpoke))
        return createBeSpokeModelList
    }

    func isNew(_ collection: QDMContentCollection) -> Bool {
        var isNewArticle = collection.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = collection.viewedAt == nil && collection.modifiedAt ?? collection.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }

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
        if impactReadiness.dailyCheckInResult?.impactReadiness == nil {
            readinessIntro = impactReadiness.bucketText?.contentItems.filter {$0.format == .paragraph}.first?.valueText
        } else { readinessIntro = impactReadiness.contentCollections?.filter {$0.searchTags.contains("impact_readiness_score")}
            .first?.contentItems.at(index: (responseIndex - 1))?.valueText
        }
//        If the dailyCheck is not done
        guard impactReadiness.dailyCheckInResult != nil else {
            expendImpactReadiness = false
            impactReadinessList.append(ImpactReadinessCellViewModel(title: "",
                                                                    dailyCheckImageView: URL(string: ""),
                                                                    readinessScore: 0, readinessIntro: readinessIntro,
                                                                    domainModel: impactReadiness))
            return impactReadinessList
        }

//If the daily check in completed update the ImpactReadinessCellViewModel
        let bucketTitle = impactReadiness.bucketText?.contentItems.first?.valueText
        let impactReadinessImage = URL(string: impactReadiness.toBeVision?.profileImageResource?.remoteURLString ?? "")
        let readinessscore = Int(round(impactReadiness.dailyCheckInResult?.impactReadiness ?? 0) * 10)

        impactReadinessList.append(ImpactReadinessCellViewModel.init(title: bucketTitle, dailyCheckImageView: impactReadinessImage, readinessScore: readinessscore, readinessIntro: readinessIntro, domainModel: impactReadiness))

        guard expendImpactReadiness == true else {
            return impactReadinessList
        }
//        If the daily check in completed update the ImpactReadinessScoreViewModel which contains all the impact readiness score

        let howYouFeelToday = impactReadiness.contentCollections?.filter {$0.searchTags.contains("rolling_data_intro")}.first?.contentItems.first?.valueText
        let asteriskText = impactReadiness.contentCollections?.filter {$0.searchTags.contains("additional")}.first?.contentItems.first?.valueText
        let sleepQuantity = impactReadiness.dailyCheckInResult?.fiveDaysSleepQuantity ?? 0
        let sleepQuality = impactReadiness.dailyCheckInResult?.fiveDaysSleepQuality ?? 0
        let load = impactReadiness.dailyCheckInResult?.fiveDaysload ?? 0
        let futureLoad = impactReadiness.dailyCheckInResult?.tenDaysFutureLoad ?? 0
        let targetSleepQuantity = impactReadiness.dailyCheckInResult?.targetSleepQuantity ?? 0
        let sleepQualityReference = impactReadiness.dailyCheckInResult?.sleepQualityReference ?? 0
        let loadReference = impactReadiness.dailyCheckInResult?.loadReference ?? 0
        let futureLoadReference = impactReadiness.dailyCheckInResult?.futureLoadReference ?? 0

        impactReadiness.contentCollections?.filter {$0.searchTags.contains("TITLE") }.forEach {(collection) in
            models.append(ImpactReadinessScoreViewModel.ImpactDataViewModel(title: collection.title, subTitle: collection.contentItems.first?.valueText))
        }
         impactReadinessList.append(ImpactReadinessScoreViewModel.init(howYouFeelToday: howYouFeelToday, asteriskText: asteriskText, sleepQuantityValue: sleepQuantity, sleepQualityValue: sleepQuality, loadValue: load, futureLoadValue: futureLoad, targetSleepQuality: targetSleepQuantity, sleepQualityReference: sleepQualityReference, loadReference: loadReference, futureLoadReference: futureLoadReference, impactDataModels: models, domainModel: impactReadiness, "detail"))
        return impactReadinessList
    }

    func saveAnswerValue(_ value: Int) {
        worker.saveAnswerValue(value)
    }

    func saveUpdateGetToLevel5Selection(_ value: Int) {
        let bucketViewModel = self.viewModelOldList.filter { $0.domainModel?.bucketName == .GET_TO_LEVEL_5 }.first as? Level5CellViewModel
        bucketViewModel?.currentLevel = value
    }

    func saveUpdatedDailyCheckInSleepTarget(_ value: Double) {
        let bucketViewModel = self.viewModelOldList.filter { $0.domainModel?.bucketName == .DAILY_CHECK_IN_1 }.first as? ImpactReadinessCellViewModel
//        check this implementation
//        bucketViewModel?.targetReferenceArray![0] = (60 + value * 30) * 5 / 60
    }

    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customzieSleepQuestion(completion: completion)
    }

    func saveTargetValue(value: Int?) {
        worker.saveTargetValue(value: value)
    }

    func createLevel5Model(level5Bucket level5: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var createLevel5List: [BaseDailyBriefViewModel] = []
        let title = level5.bucketText?.contentItems.first?.valueText ?? ""
        let intro = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("intro")}.first?.valueText ?? ""
        let question = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("question1")}.first?.valueText ?? ""
        let youRatedPart1 = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("you_rated_part1")}.first?.valueText ?? ""
        let youRatedPart2 = level5.contentCollections?.filter {$0.searchTags.contains("INTRO")}.first?.contentItems.filter {$0.searchTags.contains("you_rated_part2")}.first?.valueText ?? ""
        let level1Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_1")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level2Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_2")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level3Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_3")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level4Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_4")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level5Title = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_5")}.first?.contentItems.filter {$0.searchTags.contains("item_title")}.first?.valueText ?? ""
        let level1Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_1")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let level2Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_2")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let level3Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_3")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let level4Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_4")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let level5Text = level5.contentCollections?.filter {$0.searchTags.contains("LEVEL_5")}.first?.contentItems.filter {$0.searchTags.contains("item_text")}.first?.valueText ?? ""
        let comeBackText = level5.bucketText?.contentItems.filter {$0.searchTags.contains("COME_BACK")}.first?.valueText ?? "Noted! Come back in 1 month."
        var lastEstimatedLevel: Int?
        lastEstimatedLevel = level5.latestGetToLevel5Value
        var questionLevel: String?
        if lastEstimatedLevel != nil {
            questionLevel = youRatedPart1 + " " + String(lastEstimatedLevel ?? 0) + " " + youRatedPart2
        } else {
            questionLevel = question
        }
        createLevel5List.append(Level5CellViewModel(title: title,
                                                    intro: intro,
                                                    question: questionLevel,
                                                    youRatedPart1: youRatedPart1,
                                                    youRatedPart2: youRatedPart2,
                                                    level1Title: level1Title,
                                                    level2Title: level2Title,
                                                    level3Title: level3Title,
                                                    level4Title: level4Title,
                                                    level5Title: level5Title,
                                                    level1Text: level1Text,
                                                    level2Text: level2Text,
                                                    level3Text: level3Text,
                                                    level4Text: level4Text,
                                                    level5Text: level5Text,
                                                    comeBackText: comeBackText,
                                                    domainModel: level5
        ))
        return createLevel5List
    }

    func createDepatureInfo(depatureInfoBucket depatureInfo: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var departureInfoList: [BaseDailyBriefViewModel] = []
        guard let collection = depatureInfo.contentCollections?.first else {
            departureInfoList.append( DepartureInfoCellViewModel(title: "",
                                                                 subtitle: "",
                                                                 text: "",
                                                                 image: "",
                                                                 link: "",
                                                                 copyright: "",
                                                                 domainModel: depatureInfo))
            return departureInfoList
        }
        departureInfoList.append(DepartureInfoCellViewModel(title: depatureInfo.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                                            subtitle: depatureInfo.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                                            text: collection.contentItems.first?.valueText,
                                                            image: collection.thumbnailURLString ?? "",
                                                            link: collection.shareableLink,
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
            exploreModelList.append(ExploreCellViewModel(bucketTitle: "", title: "", introText: "", labelPosition: 0, remoteID: 0, domainModel: explore, section: ContentSection.Unkown))
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
        let peakPerformanceViewModel = MyPeakPerformanceCellViewModel(domainModel: myPeakperformance)
        let bucketTitle: String = myPeakperformance.bucketText?.contentItems.first?.valueText ?? ""
        let calendar = Calendar.current
        var contentSentence: String = ""
        myPeakperformance.bucketText?.contentItems.forEach({ (contentItem) in
            var localPreparationList = [QDMUserPreparation]()
            if contentItem.searchTags.contains(obj: "IN_THREE_DAYS") {
                contentSentence = myPeakperformance.contentCollections?.filter {$0.searchTags.contains("MY_PEAK_PERFORMANCE_3_DAYS_BEFORE")}.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter({
                    let inThreeDaysDate = $0.eventDate ?? Date()
                    if 2..<3 ~= inThreeDaysDate.daysTo() {
                        return true
                    }
                    return false
                }) ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "TOMORROW") {
                contentSentence = myPeakperformance.contentCollections?.filter {$0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_BEFORE")}.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInTomorrow($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "TODAY") {
                contentSentence = myPeakperformance.contentCollections?.filter {$0.searchTags.contains("MY_PEAK_PERFORMANCE_SAME_DAY")}.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInToday($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()
            } else if contentItem.searchTags.contains(obj: "REFLECT") {
                contentSentence = myPeakperformance.contentCollections?.filter {$0.searchTags.contains("MY_PEAK_PERFORMANCE_1_DAY_AFTER")}.randomElement()?.contentItems.first?.valueText ?? ""
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInYesterday($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()
            }
            if localPreparationList.count > 0 {
                // add the tile cell
                peakPerformanceViewModel.peakPerformanceSectionList.append(MypeakperformanceTitleModel(title: bucketTitle))
                peakPerformanceViewModel.peakPerformanceSectionList.append(MyPeakPerformanceSectionModel(sectionSubtitle: contentItem.valueDescription, sectionContent: contentSentence))
                localPreparationList.forEach({ (localPreparationList) in
                    let subtitle: String = localPreparationList.eventType ?? "" + DateFormatter.tbvTracker.string(from: localPreparationList.eventDate ?? Date())
                    peakPerformanceViewModel.peakPerformanceSectionList.append(
                        MyPeakPerformanceRowModel(qdmUserPreparation: localPreparationList,
                                                  title: localPreparationList.name,
                                                  subtitle: subtitle))
                })
            }
        })
        createMyPeakPerformanceList.append(peakPerformanceViewModel)
        return createMyPeakPerformanceList
    }

    func createDailyCheckIn2(dailyCheckIn2Bucket dailyCheckIn2: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var dailyCheckIn2List: [BaseDailyBriefViewModel] = []
        let dailyCheckIn2ViewModel = DailyCheckin2ViewModel(domainModel: dailyCheckIn2)
        if dailyCheckIn2.toBeVisionTrackId != nil {
            // for TBV
            let title: String = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let intro: String = dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro")}.first?.contentItems.first?.valueText ?? ""
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
            dailyCheckIn2ViewModel.dailyCheck2SHPIModel = DailyCheck2SHPIModel(title: shpiTitle, shpiContent: shpiContent, shpiRating: 0)
        } else {
            // peak performance
            let peakPerformanceTitle = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let peakPerformanceIntroText  = dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro")}.first?.contentItems.first?.valueText
            let performanceCount = dailyCheckIn2.dailyCheckInAnswers?.first?.PeakPerformanceCount ?? 0
            let performanceTag = "\(performanceCount)_performances"
            let performanceString = dailyCheckIn2.contentCollections?.filter { $0.searchTags.contains(performanceTag) }.first?.contentItems.first?.valueText
            let model = DailyCheckIn2PeakPerformanceModel(title: peakPerformanceTitle, intro: performanceString)
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
        let aboutMeAdditionalContent = "*QOT doesn't have enough data to show a correct average. Make sure to do the Daily Check-in in daily basis"
        aboutMeList.append(AboutMeViewModel(title: aboutMeBucketTitle, aboutMeContent: aboutMeContent, aboutMeMoreInfo: aboutMeAdditionalContent, domainModel: aboutMeModel))
        return aboutMeList
    }

//    TODO the values are hard coded and will changed once the database returns the relevant bucket information
    /**
     * Method name: createGuidedTrack.
     * Description: Method which returns the GuidedTrack Model required for the tableview.
     * Parameters: [guidedTrackBucket]
     */

    func createGuidedTrack(guidedTrackBucket guidedTrack: QDMDailyBriefBucket) -> [BaseDailyBriefViewModel] {
        var guidedtrackList: [BaseDailyBriefViewModel] = []
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "Guided Track Bucket",
                                                    content: "You’ve read about the importance of being courageous, rebellious and imaginative.You’ve read about the importance of being courageous, rebellious and imaginative.",
                                                    buttonText: "Create your To Be Vision",
                                                    type: GuidedTrackItemType.SECTION,
                                                    domain: guidedTrack))
        guard guidedClosedTrack == true else {
            return guidedtrackList
        }
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "step: 1",
                                                    content: "Vides about read about the importance of courageous, rebellious and imaginative.",
                                                    buttonText: "Watch",
                                                    type: GuidedTrackItemType.ROW,
                                                    domain: guidedTrack))
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "step: 2",
                                                    content: "Your To Be Vision is about read about the importa nce of courageous, rebelli ous and imaginative.",
                                                    buttonText: "Explore",
                                                    type: GuidedTrackItemType.ROW,
                                                    domain: guidedTrack))
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "step: 3",
                                                    content: "Event is about read about the importa nce of courageous, rebelli ous and imaginative.",
                                                    buttonText: "Watch",
                                                    type: GuidedTrackItemType.ROW,
                                                    domain: guidedTrack))
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "step: 4",
                                                    content: "Event is about read about the importa nce of courageous, rebelli ous and imaginative.",
                                                    buttonText: "Fine Tune",
                                                    type: GuidedTrackItemType.ROW,
                                                    domain: guidedTrack))
        guidedtrackList.append(GuidedTrackViewModel(bucketTitle: "step: 5",
                                                    content: "Event is about read about the importa nce of courageous, rebelli ous and imaginative.",
                                                    buttonText: "Prepare",
                                                    type: GuidedTrackItemType.ROW,
                                                    domain: guidedTrack))
        return guidedtrackList

    }

    func showDailyCheckIn() {
        router.showDailyCheckIn()
    }

    func didPressGotItSprint(sprint: QDMSprint) {
        worker.didPressGotItSprint(sprint: sprint)
    }
}
