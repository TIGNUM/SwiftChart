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
    }
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - DailyBriefInteractorInterface

extension DailyBriefInteractor: DailyBriefInteractorInterface {

    func updateViewModelList(_ list: [BaseDailyBriefViewModel]) {
        viewModelOldList = list
    }

    func getDailyBriefBucketsForViewModel() {
        var viewModelNewList: [BaseDailyBriefViewModel] = []
        worker.getDailyBriefBucketsForViewModel { (bucketsList) in
            bucketsList.forEach { (bucket) in
                switch bucket.bucketName {
                case .DAILY_CHECK_IN_1?:
                    viewModelNewList.append(self.createImpactReadinessCell(impactReadinessBucket: bucket))
                case .DAILY_CHECK_IN_2?:
                    viewModelNewList.append(self.createDailyCheckIn2(dailyCheckIn2Bucket: bucket))
                case .EXPLORE?:
                    viewModelNewList.append(self.createExploreModel(exploreBucket: bucket))
                case .ME_AT_MY_BEST?:
                    viewModelNewList.append(self.createMeAtMyBest(meAtMyBestBucket: bucket))
                case .GET_TO_LEVEL_5?:
                    viewModelNewList.append(self.createLevel5Model(level5Bucket: bucket))
                case .QUESTION_WITHOUT_ANSWER?:
                    viewModelNewList.append(self.createQuestionsWithoutAnswer(questionsWithoutAnswerBucket: bucket))
                case .LATEST_WHATS_HOT?:
                    viewModelNewList.append(self.createLatestWhatsHot(whatsHotLatestCell: bucket))
                case .THOUGHTS_TO_PONDER?:
                    viewModelNewList.append(self.createThoughtsToPonder(thoughtsToPonderBucket: bucket))
                case .GOOD_TO_KNOW?:
                    viewModelNewList.append(self.createGoodToKnow(createGoodToKnowBucket: bucket))
                case .FROM_TIGNUM?:
                    viewModelNewList.append(self.createFromTignum(fromTignum: bucket))
                case .BESPOKE?:
                    viewModelNewList.append(self.createBeSpokeModel(beSpokeModelBucket: bucket))
                case .DEPARTURE_INFO?:
                    viewModelNewList.append(self.createDepatureInfo(depatureInfoBucket: bucket))
                case .LEADERS_WISDOM?:
                    viewModelNewList.append(self.createLeaderWisdom(createLeadersWisdom: bucket))
                case .FEAST_OF_YOUR_EYES?:
                    viewModelNewList.append(self.createFeastForEyesModel(feastForEyesBucket: bucket))
                case .WEATHER?:
                    print("TODO")
                case .FROM_MY_COACH?:
                    viewModelNewList.append(self.createFromMyCoachModel(fromCoachBucket: bucket))
                case .MY_PEAK_PERFORMANCE?:
                    viewModelNewList.append(self.createMyPeakPerformanceModel(myPeakPerformanceBucket: bucket))
                case .SPRINT_CHALLENGE?:
                    viewModelNewList.append(self.createSprintChallenge(bucket: bucket))
                case .ABOUT_ME?:
                    viewModelNewList.append(self.createAboutMe(aboutMeBucket: bucket))
                case .SOLVE_REFLECTION?:
                    viewModelNewList.append(self.createSolveViewModel(bucket: bucket))
                default:
                    print("Default")
                }
            }
            let changeset = StagedChangeset(source: self.viewModelOldList, target: viewModelNewList)
            self.presenter.updateView(changeset)
        }
    }
    var rowCount: Int {
        return worker.rowCount
    }
    var rowViewModelCount: Int {
        return viewModelOldList.count
    }

    var shpiAnswer: QDMDailyCheckInAnswer? {
        return worker.shpiAnswer
    }

    var peakPerformanceCount: Int? {
        return worker.peakPerformanceCount
    }

    var lastEstimatedLevel: Int? {
        return worker.lastEstimatedLevel
    }

    func bucket(at row: Int) -> QDMDailyBriefBucket? {
        return worker.bucket(at: row)
    }

    func bucketViewModel(at row: Int) -> BaseDailyBriefViewModel? {
        return viewModelOldList.at(index: row)
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

    func getReferenceValues(completion: @escaping ([String]?) -> Void) {
        worker.getReferenceValues(completion: completion)
    }

    func presentStrategyList(selectedStrategyID: Int) {
        router.presentStrategyList(selectedStrategyID: selectedStrategyID)
    }

    func presentToolsItems(selectedToolID: Int?) {
        router.presentToolsItems(selectedToolID: selectedToolID)
    }

    func createLatestWhatsHotModel(completion: @escaping ((WhatsHotLatestCellViewModel?)) -> Void) {
        worker.createLatestWhatsHotModel(completion: completion)
    }

    func showCustomizeTarget() {
        worker.customzieSleepQuestion { [weak self] (model) in
            self?.router.showCustomizeTarget(model)
        }
    }

    func createSprintChallenge(bucket sprintBucket: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard sprintBucket.sprint != nil else {
            return SprintChallengeViewModel(bucketTitle: "",
                                            sprintTitle: "",
                                            sprintInfo: "",
                                            sprintStepNumber: 0,
                                            relatedStrategiesModels: [SprintChallengeViewModel
                                                .RelatedStrategiesModel(title: "", durationString: "", remoteID: 2)],
                                            domainModel: sprintBucket)
        }
        return SprintChallengeViewModel(bucketTitle: sprintBucket.bucketText?.contentItems.first?.valueText,
                                        sprintTitle: sprintBucket.sprint?.title,

                                        //                                         SprintInfo to change to text related to day of sprint
            sprintInfo: sprintBucket.sprint?.subtitle,
            sprintStepNumber: sprintBucket.sprint?.currentDay,
            relatedStrategiesModels: [SprintChallengeViewModel.RelatedStrategiesModel(title: "",
                                                                                      durationString: "", remoteID: 2)],
            domainModel: sprintBucket)
    }

    func createFromTignum(fromTignum: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = fromTignum.contentCollections?.first else { return
            FromTignumCellViewModel(title: "", text: "", domainModel: fromTignum)
        }
        return FromTignumCellViewModel(title: fromTignum.bucketText?.contentItems.first?.valueText ?? "",
                                       text: collection.contentItems.first?.valueText ?? "",
                                       domainModel: fromTignum)
    }

    func createLeaderWisdom(createLeadersWisdom leadersWisdom: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = leadersWisdom.contentCollections?.first else { return
            LeaderWisdomCellViewModel(title: "",
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
                                      domainModel: nil) }
        return LeaderWisdomCellViewModel(title: leadersWisdom.bucketText?.contentItems.first?.valueText ?? "",
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
            domainModel: leadersWisdom)
    }

    func createMeAtMyBest(meAtMyBestBucket meAtMyBest: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        let createMeAtMyBestTitle = meAtMyBest.bucketText?.title ?? "Testing Me AT MY BEST"


        if meAtMyBest.toBeVision != nil {
            let tbvEmptyIntro = meAtMyBest.contentItems?.filter {$0.searchTags.contains("intro_empty")}.first?.valueText ?? "This is sample intro empty"
            let ctaTBVButtonText = meAtMyBest.contentItems?.filter {$0.searchTags.contains("cta_empty")}.first?.valueText ?? "Create your to be vision"
            return MeAtMyBestCellViewModel(title: createMeAtMyBestTitle, intro: tbvEmptyIntro, tbvStatement: "", intro2: "", buttonText: ctaTBVButtonText, domainModel: meAtMyBest)

        } else {
            let tbvIntro = meAtMyBest.contentItems?.filter {$0.searchTags.contains("intro")}.first?.valueText ?? "This is sample intro"
            let tbvSentence = meAtMyBest.toBeVisionTrack?.sentence ?? ""
            let tbvIntro2 = meAtMyBest.contentItems?.filter {$0.searchTags.contains("intro2")}.first?.valueText ?? "This is sample intro 2 "
            let ctaTBVButtonText = meAtMyBest.contentItems?.filter {$0.searchTags.contains("cta_tbv")}.first?.valueText ?? "Rate"
            return MeAtMyBestCellViewModel(title: createMeAtMyBestTitle, intro: tbvIntro, tbvStatement: tbvSentence, intro2: tbvIntro2, buttonText: ctaTBVButtonText, domainModel: meAtMyBest)
        }

    }

    func createThoughtsToPonder(thoughtsToPonderBucket thoughtsToPonder: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = thoughtsToPonder.contentCollections?.first else { return ThoughtsCellViewModel(title: "",
                                                                                                              thought: "",
                                                                                                              author: "String?",
                                                                                                              domainModel: thoughtsToPonder)}
        return ThoughtsCellViewModel(title: thoughtsToPonder.bucketText?.contentItems.first?.valueText,
                                     thought: collection.contentItems.first?.valueText ?? "",
                                     author: collection.author ?? "",
                                     domainModel: thoughtsToPonder)
    }

    func createGoodToKnow(createGoodToKnowBucket createGoodToKnow: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = createGoodToKnow.contentCollections?.first else { return GoodToKnowCellViewModel(title: "",
                                                                                                                fact: "",
                                                                                                                image: URL(string: ""),
                                                                                                                domainModel: createGoodToKnow)}
        return GoodToKnowCellViewModel(title: createGoodToKnow.bucketText?.contentItems.first?.valueText,
                                       fact: collection.contentItems.first?.valueText,
                                       image: URL(string: (collection.thumbnailURLString ?? "")),
                                       domainModel: createGoodToKnow)
    }

    func createLatestWhatsHot(whatsHotLatestCell whatsHotLatest: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = whatsHotLatest.contentCollections?.first else {
            return WhatsHotLatestCellViewModel(bucketTitle: "",
                                               title: "",
                                               image: URL(string: "") ?? URL(string: "")!,
                                               author: "", publisheDate: Date(), timeToRead: 0,
                                               isNew: false, remoteID: 0,
                                               domainModel: whatsHotLatest)
        }
        return WhatsHotLatestCellViewModel(bucketTitle: "test",
                                           title: collection.title,
                                           image: URL(string: collection.thumbnailURLString ?? "") ?? URL(string: "")!,
                                           author: collection.author ?? "",
                                           publisheDate: collection.contentItems.first?.createdAt ?? Date(),
                                           timeToRead: collection.secondsRequired,
                                           isNew: self.isNew(collection),
                                           remoteID: collection.remoteID ?? 0,
                                           domainModel: whatsHotLatest)
    }

    func createFeastForEyesModel(feastForEyesBucket feastForEyes: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = feastForEyes.contentCollections?.first else { return FeastCellViewModel(title: "",
                                                                                                       image: "",
                                                                                                       remoteID: 1,
                                                                                                       domainModel: feastForEyes)}
        return FeastCellViewModel(title: feastForEyes.bucketText?.contentItems.first?.valueText,
                                  image: collection.thumbnailURLString ?? "",
                                  remoteID: collection.contentItems.first?.remoteID,
                                  domainModel: feastForEyes)
    }

    func createFromMyCoachModel(fromCoachBucket fromCoach: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        var messageModels: [FromMyCoachCellViewModel.FromMyCoachMessage] = []
        fromCoach.coachMessages?.forEach {(message) in
            messageModels.append(FromMyCoachCellViewModel.FromMyCoachMessage(date: DateFormatter.messageDate.string(from: message.issueDate!), text: message.body ?? ""))
        }
        return FromMyCoachCellViewModel(detail: FromMyCoachCellViewModel.FromMyCoachDetail(imageUrl: URL(string: fromCoach.coachMessages?.last?.coachProfileImageUrl ?? ""),
                                                                                           title: fromCoach.bucketText?.contentItems.first?.valueText ?? "FROM MY COACH"),
                                        messages: messageModels,
                                        domainModel: fromCoach)
    }

    func createBeSpokeModel(beSpokeModelBucket beSpoke: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = beSpoke.contentCollections?.first else {
            return BeSpokeCellViewModel(bucketTitle: "", title: "", description: "", image: "", domainModel: nil)

        }
        return BeSpokeCellViewModel(bucketTitle: beSpoke.bucketText?.contentItems.first?.valueText,
                                    title: collection.title,
                                    description: collection.contentItems.first?.valueText,
                                    image: collection.thumbnailURLString ?? "",
                                    domainModel: beSpoke)
    }

    func isNew(_ collection: QDMContentCollection) -> Bool {
        var isNewArticle = collection.viewedAt == nil
        if let firstInstallTimeStamp = self.firstInstallTimeStamp {
            isNewArticle = collection.viewedAt == nil && collection.modifiedAt ?? collection.createdAt ?? Date() > firstInstallTimeStamp
        }
        return isNewArticle
    }

    func createImpactReadinessCell(impactReadinessBucket impactReadiness: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        var models: [ImpactReadinessCellViewModel.ImpactDataViewModel] = []
        guard let collections = impactReadiness.contentCollections else {
            return ImpactReadinessCellViewModel(title: "",
                                                dailyCheckImageView: URL(string: ""),
                                                howYouFeelToday: "",
                                                asteriskText: "",
                                                readinessScore: 66,
                                                impactDataModels: [ImpactReadinessCellViewModel.ImpactDataViewModel(title: "",
                                                                                                                    subTitle: "",
                                                                                                                    averageValue: 0,
                                                                                                                    targetRefValue: "")],
                                                readinessIntro: "",
                                                domainModel: impactReadiness)
        }
        collections.filter {$0.searchTags.contains("TITLE") }.forEach {(collection) in
            models.append(ImpactReadinessCellViewModel.ImpactDataViewModel(title: collection.title,
                                                                           subTitle: collection.contentItems.first?.valueText,
                                                                           averageValue: 0,
                                                                           targetRefValue: ""))
        }
        // if readiness score is nil, readinessIntro: impactReadiness.bucketText?.contentItems.filter{$0.format== .paragraph}.first?.valueText
        return ImpactReadinessCellViewModel(title: impactReadiness.bucketText?.contentItems.first?.valueText,
                                            dailyCheckImageView: URL(string: impactReadiness.toBeVision?.profileImageResource?.remoteURLString ?? ""),
                                            howYouFeelToday: collections.filter {$0.searchTags.contains("rolling_data_intro")}.first?.contentItems.first?.valueText,
                                            asteriskText: collections.filter {$0.searchTags.contains("additional")}.first?.contentItems.first?.valueText,
                                            readinessScore: 87,
                                            impactDataModels: models,
                                            readinessIntro: "",
                                            domainModel: impactReadiness)
    }

    func saveAnswerValue(_ value: Int) {
        worker.saveAnswerValue(value)
    }

    func saveUpdateGetToLevel5Selection(_ value: Int) {
        let bucketViewModel = self.viewModelOldList.filter { $0.domainModel?.bucketName == .GET_TO_LEVEL_5 }.first as? Level5CellViewModel
        bucketViewModel?.currentLevel = value
    }

    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        worker.customzieSleepQuestion(completion: completion)
    }

    func saveTargetValue(value: Int?) {
        worker.saveTargetValue(value: value)
    }

    func createLevel5Model(level5Bucket level5: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
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
        return Level5CellViewModel(title: title,
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
        )
    }

    func createDepatureInfo(depatureInfoBucket depatureInfo: QDMDailyBriefBucket) -> BaseDailyBriefViewModel {
        guard let collection = depatureInfo.contentCollections?.first else {
            return DepartureInfoCellViewModel(title: "",
                                              subtitle: "",
                                              text: "",
                                              image: "",
                                              link: "",
                                              domainModel: depatureInfo)
        }
        return DepartureInfoCellViewModel(title: depatureInfo.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                          subtitle: depatureInfo.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                          text: collection.contentItems.first?.valueText,
                                          image: collection.thumbnailURLString ?? "",
                                          link: collection.shareableLink,
                                          domainModel: depatureInfo)
    }

    func createSolveViewModel(bucket solveBucket: QDMDailyBriefBucket) -> SolveReminderCellViewModel {
        guard (solveBucket.solves?.first) != nil else {
            return SolveReminderCellViewModel(bucketTitle: "",
                                              twoDayAgo: "",
                                              question1: "",
                                              question2: "",
                                              question3: "",
                                              solveViewModels: [SolveReminderCellViewModel.SolveViewModel(title: "", date: "", solve: nil)],
                                              domainModel: solveBucket)
        }
        var solveModels: [SolveReminderCellViewModel.SolveViewModel] = []
        solveBucket.solves?.forEach {(solve) in
            solveModels.append(SolveReminderCellViewModel.SolveViewModel(title: solve.solveTitle,
                                                                         date: DateFormatter.whatsHot.string(from: solve.createdAt ?? Date()),
                                                                         solve: nil))
        }

        return SolveReminderCellViewModel(bucketTitle: solveBucket.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                          twoDayAgo: solveBucket.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                          question1: solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }.first?.valueText,
                                          question2: solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }[1].valueText,
                                          question3: solveBucket.bucketText?.contentItems.filter { $0.format == .textQuote }.last?.valueText,
                                          solveViewModels: solveModels,
                                          domainModel: solveBucket)
    }

    func createQuestionsWithoutAnswer(questionsWithoutAnswerBucket questionsWithoutAnswer: QDMDailyBriefBucket) -> QuestionCellViewModel {
        guard let collection = questionsWithoutAnswer.contentCollections?.first else {
            return QuestionCellViewModel(title: "", text: "", domainModel: questionsWithoutAnswer)
        }
        return QuestionCellViewModel(title: questionsWithoutAnswer.bucketText?.contentItems.first?.valueText,
                                     text: collection.contentItems.first?.valueText,
                                     domainModel: questionsWithoutAnswer)
    }

    func createExploreModel(exploreBucket explore: QDMDailyBriefBucket) -> ExploreCellViewModel {
        let date = Date()
        let dateComponents = Calendar.current.dateComponents([.hour], from: date)
        guard let exploreContentCollections = explore.contentCollections else {
            return ExploreCellViewModel(bucketTitle: "", title: "", introText: "", labelPosition: 0, remoteID: 0, domainModel: explore, section: ContentSection.Unkown)
        }
        if let hour = dateComponents.hour {
            if 6 <= hour && hour < 12 {
                return ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                            title: exploreContentCollections.first?.title,
                                            introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                            labelPosition: 40,
                                            remoteID: exploreContentCollections.first?.remoteID,
                                            domainModel: explore,
                                            section: exploreContentCollections.first?.section ?? ContentSection.Unkown)
            } else if 12 <= hour && hour < 18 {
                return ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                            title: exploreContentCollections.at(index: 1)?.title,
                                            introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                            labelPosition: 125,
                                            remoteID: exploreContentCollections.at(index: 1)?.remoteID,
                                            domainModel: explore,
                                            section: exploreContentCollections.at(index: 1)?.section ?? ContentSection.Unkown)

            } else if 18 <= hour && hour <= 24 || hour < 6 {
                return ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.filter { $0.format == .title }.first?.valueText,
                                            title: exploreContentCollections.last?.title,
                                            introText: explore.bucketText?.contentItems.filter { $0.format == .paragraph }.first?.valueText,
                                            labelPosition: 230,
                                            remoteID: exploreContentCollections.last?.remoteID,
                                            domainModel: explore,
                                            section: exploreContentCollections.last?.section ?? ContentSection.Unkown)            }
        }
        return ExploreCellViewModel(bucketTitle: explore.bucketText?.contentItems.first?.valueText,
                                    title: "", introText: "",
                                    labelPosition: 0, remoteID: 666,
                                    domainModel: explore,
                                    section: ContentSection.Unkown)
    }

    func createMyPeakPerformanceModel(myPeakPerformanceBucket myPeakperformance: QDMDailyBriefBucket) -> MyPeakPerformanceCellViewModel {
        let peakPerformanceViewModel = MyPeakPerformanceCellViewModel(domainModel: myPeakperformance)
        let calendar = Calendar.current
        myPeakperformance.bucketText?.contentItems.forEach({ (contentItem) in
            var localPreparationList = [QDMUserPreparation]()

            if contentItem.searchTags.contains(obj: "IN THREE DAYS") {
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInYesterday($0.eventDate ?? Date())
                }) ?? [QDMUserPreparation]()
            } else if contentItem.valueText == "TOMORROW" {
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInTomorrow($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()

            } else if contentItem.valueText == "TODAY" {
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInToday($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()

            } else if contentItem.valueText == "REFLECT" {
                localPreparationList = myPeakperformance.preparations?.filter({
                    calendar.isDateInYesterday($0.eventDate ?? Date()) }) ?? [QDMUserPreparation]()
            }

            if localPreparationList.count > 0 {
                //                add the tile cell
                peakPerformanceViewModel.peakPerformanceSectionList.append(MypeakperformanceTitleModel(title: "MY PEAK PERFORMANCE"))
                peakPerformanceViewModel.peakPerformanceSectionList.append(MyPeakPerformanceSectionModel(sectionSubtitle: contentItem.valueDescription, sectionContent: "TODO Content from collection"))
                localPreparationList.forEach({ (localPreparationList) in
                    peakPerformanceViewModel.peakPerformanceSectionList.append(MyPeakPerformanceRowModel(title: localPreparationList.name, subtitle: localPreparationList.eventType))
                })
            }
        })
        return peakPerformanceViewModel
    }

    func createDailyCheckIn2(dailyCheckIn2Bucket dailyCheckIn2: QDMDailyBriefBucket) -> DailyCheckin2ViewModel {
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
            dailyCheckIn2ViewModel.dailyCheck2SHPIModel = DailyCheck2SHPIModel(title: shpiTitle, shpiContent: shpiContent, shpiRating: 0)
        } else {
            // peak performance
            let peakPerformanceTitle = dailyCheckIn2.bucketText?.contentItems.first?.valueText ?? ""
            let peakPerformanceIntroText  = dailyCheckIn2.contentCollections?.filter {$0.searchTags.contains("intro")}.first?.contentItems.first?.valueText
            let performanceCount = dailyCheckIn2.dailyCheckInAnswers?.first?.PeakPerformanceCount ?? 0
            let performanceTag = "\(performanceCount)_performances"
            let performanceContentItem = dailyCheckIn2.contentCollections?.filter { $0.searchTags.contains(performanceTag) }.first?.contentItems.first
            _ = performanceContentItem?.valueText
            let model = DailyCheckIn2PeakPerformanceModel(title: peakPerformanceTitle, intro: peakPerformanceIntroText)
            dailyCheckIn2ViewModel.dailyCheckIn2PeakPerformanceModel = model
        }
        return dailyCheckIn2ViewModel
    }

    func createAboutMe(aboutMeBucket aboutMe: QDMDailyBriefBucket) -> AboutMeViewModel {
        //        Todo remove the testing about me and send the default.
        let aboutMeBucketTitle = aboutMe.bucketText?.contentItems.first?.valueText ?? "Testing About Me"
        let aboutMeContent = aboutMe.stringValue ?? ""
        //        TODO About me additional text should be part of content collection for testing purpose we are sending * value for now
        let aboutMeAdditionalContent = "todo additional text for the About me"
        return AboutMeViewModel(title: aboutMeBucketTitle, aboutMeContent: aboutMeContent, aboutMeMoreInfo: aboutMeAdditionalContent, domainModel: aboutMe)
    }
}
