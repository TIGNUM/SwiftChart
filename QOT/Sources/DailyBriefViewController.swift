//
//  DailyBriefViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal
import DifferenceKit

protocol DailyBriefViewControllerDelegate: class {
    func showDailyCheckIn()
    func showSolveResults(solve: QDMSolve)
    func presentMyToBeVision()
    func showCustomizeTarget()
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) // Save Get To Level 5 Answer Value
    func changedGetToLevel5Value(_ value: Int, from cell: UITableViewCell) // Update Selection of Get To Level 5 Answer Value
    func saveTargetValue(value: Int?) //save sleep target
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?, pageName: PageName)
    func openPreparation(_ qdmUserPreparation: QDMUserPreparation)
}

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: UIViewController, ScreenZLevel1, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var interactor: DailyBriefInteractorInterface?
    private var latestWhatsHotModel: WhatsHotLatestCellViewModel?
    private var selectedStrategyID: Int?
    private var selectedToolID: Int?
    private var impactReadinessScore: Int?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 900
        interactor?.viewDidLoad()
        self.showLoadingSkeleton(with: [.dailyBrief])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getDailyBriefBucketsForViewModel()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowViewModelCount ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModelBucket = interactor?.bucketViewModel(at: indexPath.row)
        switch viewModelBucket?.domainModel?.bucketName {
        case .DAILY_CHECK_IN_1?:
            NotificationCenter.default.addObserver(self, selector: #selector(updateTargetValue), name: .didPickTarget, object: nil)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let viewModelBucket = interactor?.bucketViewModel(at: indexPath.row)
        switch viewModelBucket?.domainModel?.bucketName {
        case .DAILY_CHECK_IN_1?:
            NotificationCenter.default.removeObserver(self, name: .didPickTarget, object: nil)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModelBucket = interactor?.bucketViewModel(at: indexPath.row)
        switch viewModelBucket?.domainModel?.bucketName {
        case .DAILY_CHECK_IN_1?:
            let impactReadinessCellViewModel = viewModelBucket as? ImpactReadinessCellViewModel
            return getImpactReadinessCell(tableView, indexPath, impactReadinessCellViewModel)
        case .DAILY_CHECK_IN_2?:
            let dailyCheckIn2ViewModel = viewModelBucket as? DailyCheckin2ViewModel
            switch dailyCheckIn2ViewModel?.type {
            case .TBV?:
                return getDailyCheckIn2TBVCell(tableView,
                                               indexPath,
                                               dailyCheckIn2ViewModel?.dailyCheckIn2TBVModel)
            case .PEAKPERFORMANCE?:
                return getDailyCheckIn2PeakPerformanceCell(tableView,
                                                           indexPath,
                                                           dailyCheckIn2ViewModel?.dailyCheckIn2PeakPerformanceModel)
            case .SHPI?:
                return getDailyCheckinInsightsSHPICell(tableView,
                                                       indexPath, dailyCheckIn2ViewModel?.dailyCheck2SHPIModel)
            default:
                return UITableViewCell()
            }
        case .EXPLORE?:
            let exploreViewModel = viewModelBucket as? ExploreCellViewModel
            return getExploreCell(tableView, indexPath, exploreViewModel)
        case .SPRINT_CHALLENGE?:
            let sprintChallengeModel = viewModelBucket as? SprintChallengeViewModel
            return getSprints(tableView, indexPath, sprintChallengeModel)
        case .ME_AT_MY_BEST?:
            if viewModelBucket?.domainModel?.toBeVision == nil {
                let meAtMyBestCellEmptyViewModel = viewModelBucket as? MeAtMyBestCellEmptyViewModel
                return getMeAtMyBestEmpty(tableView, indexPath, meAtMyBestCellEmptyViewModel)
            } else {
                let meAtMyBestCellViewModel = viewModelBucket as? MeAtMyBestCellViewModel
                return getMeAtMyBest(tableView, indexPath, meAtMyBestCellViewModel)
            }
        case .ABOUT_ME?:
            let aboutMeModel = viewModelBucket as? AboutMeViewModel
            return getAboutMeCell(tableView, indexPath, aboutMeModel)
        case .SOLVE_REFLECTION?:
            let solveReminderViewModel = viewModelBucket as? SolveReminderCellViewModel
            return getSolveReminder(tableView, indexPath, solveReminderViewModel)
        case .GET_TO_LEVEL_5?:
            let level5ViewModel = viewModelBucket as? Level5CellViewModel
            return getlevel5(tableView, indexPath, level5ViewModel)
        case .QUESTION_WITHOUT_ANSWER?:
            let questionCellViewModel = viewModelBucket as? QuestionCellViewModel
            return getRandomQuestionCell(tableView, indexPath, questionCellViewModel)
        case .LATEST_WHATS_HOT?:
            let whatsHotCellViewModel = viewModelBucket as? WhatsHotLatestCellViewModel
            return getWhatsHot(tableView, indexPath, whatsHotCellViewModel)
        case .THOUGHTS_TO_PONDER?:
            let thoughtCellViewModel = viewModelBucket as? ThoughtsCellViewModel
            return getThoughtsCell(tableView, indexPath, thoughtCellViewModel)
        case .GOOD_TO_KNOW?:
            let goodToKnowCellViewModel = viewModelBucket as? GoodToKnowCellViewModel
            return getGoodToKnowCell(tableView, indexPath, goodToKnowCellViewModel!)
        case .FROM_MY_COACH?:
            // TODO remove the !
            let coachMessageCellViewModel = viewModelBucket as? FromMyCoachCellViewModel
            return getCoachMessageCell(tableView, indexPath, coachMessageCellViewModel!)
        case .FROM_TIGNUM?:
            let fromTignumMessageViewModel = viewModelBucket as? FromTignumCellViewModel
            return getFromTignumMessageCell(tableView, indexPath, fromTignumMessageViewModel)
        case .BESPOKE?:
            let beSpokeViewModel = viewModelBucket as? BeSpokeCellViewModel
            return getBeSpokeCell(tableView, indexPath, beSpokeViewModel)
        case .DEPARTURE_INFO?:
            let departureInfoViewModel = viewModelBucket as? DepartureInfoCellViewModel
            return getDepartureInfoCell(tableView, indexPath, departureInfoViewModel)
        case .LEADERS_WISDOM?:
            let leadersWisdomViewModel = viewModelBucket as? LeaderWisdomCellViewModel
            return getLeadersWisdom(tableView, indexPath, leadersWisdomViewModel)
        case .FEAST_OF_YOUR_EYES?:
            let feastForEyesViewModel = viewModelBucket as? FeastCellViewModel
            return getFeastForEyesCell(tableView, indexPath, feastForEyesViewModel)
        case .MY_PEAK_PERFORMANCE?:
            let myPeakPerformanceViewModel = viewModelBucket as? MyPeakPerformanceCellViewModel
            return getMyPeakPerformance(tableView, indexPath, myPeakPerformanceViewModel)
        case .WEATHER?:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
}

private extension DailyBriefViewController {

    /**
     * Method name: impactReadinessCell.
     * Description: Placeholder to display the Random Question Cell Information.
     * Parameters: [tableView], [IndexPath]
     */

    func getImpactReadinessCell(_ tableView: UITableView,
                                _ indexPath: IndexPath,
                                _ impactReadinessCellViewModel: ImpactReadinessCellViewModel?) -> UITableViewCell {
        let cell: ImpactReadinessCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: impactReadinessCellViewModel)
        if impactReadinessCellViewModel?.readinessScore == 0 {
            cell.readinessExploreButton.setTitle("Start your Daily check-in", for: .normal)
        } else { cell.readinessExploreButton.setTitle("Explore your score", for: .normal)
        }
        cell.backgroundColor = .carbon
        cell.tableView.reloadData()
        cell.delegate = self
        return cell
    }

    /**
     * Method name: getRandomQuestionCell.
     * Description: Placeholder to display the Random Question Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getRandomQuestionCell(_ tableView: UITableView, _ indexPath: IndexPath,
                               _ questionCellViewModel: QuestionCellViewModel?) -> UITableViewCell {
        let cell: QuestionCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: questionCellViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getThoughtsCell.
     * Description: Placeholder to display the Random Question Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getThoughtsCell(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ thoughtsCellViewModel: ThoughtsCellViewModel?) -> UITableViewCell {
        let cell: ThoughtsCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: thoughtsCellViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getGoodToKnowCell.
     * Description: Placeholder to display the Random Good To Know Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getGoodToKnowCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           _ goodToKnowCellViewModel: GoodToKnowCellViewModel) -> UITableViewCell {
        let cell: GoodToKnowCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: goodToKnowCellViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getFromTignumMessageCell.
     * Description: Placeholder to display the Frojm Tignum Message Cell Information.
     * Parameters: [tableView], [IndexPath]
     */

    func getFromTignumMessageCell(_ tableView: UITableView,
                                  _ indexPath: IndexPath,
                                  _ fromTignumMessageViewModel: FromTignumCellViewModel?) -> UITableViewCell {
        let cell: FromTignumCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: fromTignumMessageViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getDepartureInfoCell.
     * Description: Placeholder to display the Random Departure Info Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getDepartureInfoCell(_ tableView: UITableView,
                              _ indexPath: IndexPath,
                              _ departureInfoViewModel: DepartureInfoCellViewModel?) -> UITableViewCell {
        let cell: DepartureInfoCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: departureInfoViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getCoachMessageCell.
     * Description: Placeholder to display the Random Departure Info Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getCoachMessageCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             _ coachMessageModel: FromMyCoachCellViewModel) -> UITableViewCell {
        let cell: FromMyCoachCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: coachMessageModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getFeastForEyesCell.
     * Description: Placeholder to display the Feast For Eyes Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getFeastForEyesCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             _ feastForEyesViewModel: FeastCellViewModel?) -> UITableViewCell {
        let cell: FeastCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: feastForEyesViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getBeSpokeCell.
     * Description: Placeholder to display the Be Spoke Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getBeSpokeCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ beSpokeViewModel: BeSpokeCellViewModel?) -> UITableViewCell {
        let cell: BeSpokeCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: beSpokeViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getAboutMeCell.
     * Description: Placeholder to display the About me Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getAboutMeCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ aboutMeViewModel: AboutMeViewModel?) -> UITableViewCell {
        let cell: AboutMeCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: aboutMeViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getMeAtMyBest.
     * Description: Placeholder to display the Me At My Best Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getMeAtMyBest(_ tableView: UITableView,
                       _ indexPath: IndexPath,
                       _ meAtMyBestViewModel: MeAtMyBestCellViewModel?) -> UITableViewCell {
        let cell: MeAtMyBestCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: meAtMyBestViewModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getMeAtMyBest.
     * Description: Placeholder to display the Me At My Best Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getMeAtMyBestEmpty(_ tableView: UITableView,
                            _ indexPath: IndexPath,
                            _ meAtMyBestCellEmptyViewModel: MeAtMyBestCellEmptyViewModel?) -> UITableViewCell {
        let cell: MeAtMyBestEmptyCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: meAtMyBestCellEmptyViewModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getSprints.
     * Description: Placeholder to display the Me At My Best Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getSprints(_ tableView: UITableView,
                    _ indexPath: IndexPath,
                    _ sprintChallengeModel: SprintChallengeViewModel?) -> UITableViewCell {
        let cell: SprintChallengeCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: sprintChallengeModel)
        cell.backgroundColor = .carbon
        cell.delegate = self
        return cell
    }
    /**
     * Method name: getWhatsHot.
     * Description: Placeholder to display the Whats Hot Information.
     * Parameters: [tableView], [IndexPath]
     */

    func getWhatsHot(_ tableView: UITableView,
                     _ indexPath: IndexPath,
                     _ whatsHotViewModel: WhatsHotLatestCellViewModel?) -> UITableViewCell {
        //check this for some reasons there is null pointer exceoption
        let cell: WhatsHotLatestCell = tableView.dequeueCell(for: indexPath)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.checkAction))
        cell.addGestureRecognizer(gesture)
        cell.configure(with: whatsHotViewModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getSolveReminder.
     * Description: Placeholder to display the Me At My Best Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getSolveReminder(_ tableView: UITableView,
                          _ indexPath: IndexPath,
                          _ solveReminderViewModel: SolveReminderCellViewModel?) -> UITableViewCell {
        let cell: SolveReminderCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: solveReminderViewModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getLevel 5.
     * Description: Placeholder to display the Level 5 Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getlevel5(_ tableView: UITableView,
                   _ indexPath: IndexPath,
                   _ level5ViewModel: Level5CellViewModel?) -> UITableViewCell {
        let cell: Level5Cell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: level5ViewModel)
        cell.backgroundColor = .carbon
        cell.delegate = self
        return cell
    }

    /**
     * Method name: getLeadersWisdom.
     * Description: Placeholder to display the leaders wisdom Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getLeadersWisdom(_ tableView: UITableView,
                          _ indexPath: IndexPath,
                          _ leadersWisdomViewModel: LeaderWisdomCellViewModel?) -> UITableViewCell {
        let cell: LeaderWisdomTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: leadersWisdomViewModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getDailyCheckinInsightsSHPICell.
     * Description: Placeholder to display the getDailyCheckinInsightsSHPICell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getDailyCheckinInsightsSHPICell(_ tableView: UITableView,
                                         _ indexPath: IndexPath,
                                         _ dailyCheck2SHPIModel: DailyCheck2SHPIModel?) -> UITableViewCell {
        let cell: DailyCheckinInsightsSHPICell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: dailyCheck2SHPIModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getDailyCheckIn2TBVCell.
     * Description: Placeholder to display the getDailyCheckIn2TBV Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getDailyCheckIn2TBVCell(_ tableView: UITableView,
                                 _ indexPath: IndexPath,
                                 _ dailyCheckIn2TBVModel: DailyCheckIn2TBVModel?) -> UITableViewCell {
        let cell: DailyCheckinInsightsTBVCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: dailyCheckIn2TBVModel)
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getDailyCheckIn2PeakPerformanceModel.
     * Description: Placeholder to display the getDailyCheckIn2TBV Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getDailyCheckIn2PeakPerformanceCell(_ tableView: UITableView,
                                             _ indexPath: IndexPath,
                                             _ dailyCheckIn2PeakPerformanceModel: DailyCheckIn2PeakPerformanceModel?) ->
        UITableViewCell {
            let cell: DailyCheckinInsightsPeakPerformanceCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: dailyCheckIn2PeakPerformanceModel)
            cell.backgroundColor = .carbon
            return cell
    }

    /**
     * Method name: getMyPeakPerformance.
     * Description: Placeholder to display the peak performance Information.
     * Parameters: [tableView], [IndexPath]
     */

    func getMyPeakPerformance(_ tableView: UITableView,
                              _ indexPath: IndexPath,
                              _ peakPerformanceModel: MyPeakPerformanceCellViewModel?) -> UITableViewCell {
        let cell: MyPeakPerformanceTableCell = tableView.dequeueCell(for: indexPath)
        let peakPerformanceList = peakPerformanceModel?.peakPerformanceSectionList ?? []
        let tableViewHeight = getPeakPerformanceTableViewHeight(peakPerformanceList, peakPerformanceModel)
        cell.peakPerformanceList = peakPerformanceList
        cell.configure(with: peakPerformanceModel,
                       tableViewHeight: tableViewHeight)
        cell.delegate = self
        return cell
    }

    func getPeakPerformanceTableViewHeight(_ modelItems: [MyPerformanceModelItem],
                                           _ peakPerformanceModel: MyPeakPerformanceCellViewModel?) -> CGFloat {
        let headerHeight: CGFloat = 78
        let rowHeight: CGFloat = 99 * CGFloat(modelItems.filter { $0.type == .ROW }.count)
        let sections = peakPerformanceModel?.peakPerformanceSectionList.filter { $0.type == .SECTION }
        let sectionHeight: CGFloat = 200 * CGFloat(sections?.count ?? 0)
        return headerHeight + rowHeight + sectionHeight
    }

    /**
     * Method name: getExploreCell.
     * Description: Placeholder to display the leaders wisdom Information.
     * Parameters: [?tableView], [IndexPath]
     */

    func getExploreCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ exploreViewModel: ExploreCellViewModel?) -> UITableViewCell {
        let cell: ExploreCell = tableView.dequeueCell(for: indexPath)
        if exploreViewModel?.section == .LearnStrategies {
            self.selectedStrategyID = exploreViewModel?.remoteID
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openStrategy))
            cell.addGestureRecognizer(gesture)
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           labelPosition: CGFloat(exploreViewModel?.labelPosition ?? 0))
        } else if exploreViewModel?.section == .QOTLibrary {
            self.selectedToolID = exploreViewModel?.remoteID
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openTool))
            cell.addGestureRecognizer(gesture)
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           labelPosition: CGFloat(exploreViewModel?.labelPosition ?? 0) )
        }
        cell.backgroundColor = .carbon
        return cell
    }
}

// MARK: - DumViewControllerInterface

extension  DailyBriefViewController: DailyBriefViewControllerInterface {

    @objc func updateTargetValue(_ notification: NSNotification) {
        guard let value = notification.object as? Double else {
            return
        }
        interactor?.saveUpdatedDailyCheckInSleepTarget(value)
        tableView.reloadData()
    }

    @objc func checkAction(sender: UITapGestureRecognizer) {
        interactor?.createLatestWhatsHotModel(completion: { [weak self] (model) in
            self?.interactor?.presentWhatsHotArticle(selectedID: model?.remoteID ?? 0)
        })
    }

    @objc func openStrategy(sender: UITapGestureRecognizer) {
        interactor?.presentStrategyList(selectedStrategyID: selectedStrategyID ?? 0)
    }

    @objc func openTool(sender: UITapGestureRecognizer) {
        interactor?.presentToolsItems(selectedToolID: selectedToolID ?? 0)
    }

    func updateView(_ differenceList: StagedChangeset<[BaseDailyBriefViewModel]>) {
        self.removeLoadingSkeleton()
        tableView.reload(using: differenceList, with: .fade) { data in
            interactor?.updateViewModelList(data)
        }
    }

    func setupView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.registerDequeueable(WhatsHotLatestCell.self)
        tableView.registerDequeueable(QuestionCell.self)
        tableView.registerDequeueable(ThoughtsCell.self)
        tableView.registerDequeueable(GoodToKnowCell.self)
        tableView.registerDequeueable(FromTignumCell.self)
        tableView.registerDequeueable(DepartureInfoCell.self)
        tableView.registerDequeueable(FeastCell.self)
        tableView.registerDequeueable(ImpactReadinessCell.self)
        tableView.registerDequeueable(BeSpokeCell.self)
        tableView.registerDequeueable(DailyCheckinInsightsTBVCell.self)
        tableView.registerDequeueable(DailyCheckinInsightsSHPICell.self)
        tableView.registerDequeueable(DailyCheckinInsightsPeakPerformanceCell.self)
        tableView.registerDequeueable(ExploreCell.self)
        tableView.registerDequeueable(AboutMeCell.self)
        tableView.registerDequeueable(MeAtMyBestCell.self)
        tableView.registerDequeueable(Level5Cell.self)
        tableView.registerDequeueable(FromMyCoachCell.self)
        tableView.registerDequeueable(LeaderWisdomTableViewCell.self)
        tableView.registerDequeueable(MyPeakPerformanceTableCell.self)
        tableView.registerDequeueable(MeAtMyBestEmptyCell.self)
        tableView.registerDequeueable(MeAtMyBestCell.self)
        tableView.registerDequeueable(SolveReminderCell.self)
        tableView.registerDequeueable(SprintChallengeCell.self)
    }
}

extension DailyBriefViewController: DailyBriefViewControllerDelegate {

    func showSolveResults(solve: QDMSolve) {
        interactor?.showSolveResults(solve: solve)
    }

    func presentMyToBeVision() {
        interactor?.presentMyToBeVision()
    }

    func showCustomizeTarget() {
        interactor?.showCustomizeTarget()
    }

    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) {
        interactor?.saveAnswerValue(value)
        if let cellIndexPath = tableView.indexPath(for: cell) {
            self.tableView.reloadRows(at: [cellIndexPath], with: .automatic)
        }
    }

    func changedGetToLevel5Value(_ value: Int, from cell: UITableViewCell) {
        interactor?.saveUpdateGetToLevel5Selection(value)
        if let cellIndexPath = tableView.indexPath(for: cell) {
            self.tableView.reloadRows(at: [cellIndexPath], with: .none)
        }
    }

    func saveTargetValue(value: Int?) {
        interactor?.saveTargetValue(value: value)
    }

    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void) {
        interactor?.customzieSleepQuestion(completion: completion)
    }
    // TODO Set correct pageName
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?, pageName: PageName) {
        stream(videoURL: videoURL ?? URL(string: "")!, contentItem: contentItem, pageName)
    }

    func openPreparation(_ qdmUserPreparation: QDMUserPreparation) {
        let configurator = PrepareResultsConfigurator.configurate(qdmUserPreparation, [], canDelete: false)
        let controller = PrepareResultsViewController(configure: configurator)
        present(controller, animated: true)
    }

    func showDailyCheckIn() {
        interactor?.showDailyCheckIn()
    }
}

extension DailyBriefViewController: QuestionnaireAnswer {

    func isPresented(for questionIdentifier: Int?, from viewController: UIViewController) {
    }

    func isSelecting(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
    }

    func didSelect(answer: Int, for questionIdentifier: Int?, from viewController: UIViewController) {
        let index = 0
        if index == NSNotFound { return }
        interactor?.customzieSleepQuestion(completion: {(question) in
            let answers = question?.answers?.count ?? 0
            question?.selectedAnswerIndex = (answers - 1) - answer
        })
    }
}
