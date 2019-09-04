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
    func openToolFromSprint(toolID: Int?)
    func openStrategyFromSprint(strategyID: Int?)
    func didPressGotItSprint(sprint: QDMSprint)
    func showDailyCheckIn()
    func showSolveResults(solve: QDMSolve)
    func presentMyToBeVision()
    func showCustomizeTarget()
    func customzieSleepQuestion(completion: @escaping (RatingQuestionViewModel.Question?) -> Void)
    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) // Save Get To Level 5 Answer Value
    func saveTargetValue(value: Int?) //save sleep target
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?, pageName: PageName)
    func openPreparation(_ qdmUserPreparation: QDMUserPreparation)
    func presentCopyRight(copyrightURL: String?)
    func reloadSprintCell(cell: UITableViewCell)
    func didUpdateLevel5()
    func displayCoachPreparationScreen()
    func openGuidedTrackAppLink(_ appLink: String?)
    func presentMyDataScreen()
}

protocol PopUpCopyRightViewControllerProtocol: class {
     func cancelAction()
}

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: UIViewController, ScreenZLevelBottom, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    var interactor: DailyBriefInteractorInterface?
    private var latestWhatsHotModel: WhatsHotLatestCellViewModel?
    private var selectedStrategyID: Int?
    private var selectedToolID: Int?
    private var selectedStrategySprintsID: Int?
    private var selectedToolSprintsID: Int?
    private var showSteps = false
    private var impactReadinessScore: Int?
    var sectionDataList: [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>] = []
    private var navBarHeader: NavBarTableViewCell?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDailyBriefFromNotification(_:)),
                                               name: .didUpdateDailyBriefBuckets, object: nil)
        self.showLoadingSkeleton(with: [.dailyBrief])
        navBarHeader = NavBarTableViewCell.instantiateFromNib(title: R.string.localized.dailyBriefTitle(), tapLeft: { [weak self] in
            self?.delegate?.moveToCell(item: 0)
            }, tapRight: { [weak self] in
                self?.delegate?.moveToCell(item: 2)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getDailyBriefBucketsForViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeLoadingSkeleton()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.rowViewSectionCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = interactor?.bucketViewModelNew()?.at(index: section) else {
            return 0
        }
        return sections.elements.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return navBarHeader
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return navBarHeader?.bounds.height ?? 0
        }
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // UIView with sand40 background for section-separators as Section Footer
        if section == (interactor?.rowViewSectionCount ?? 1) - 1 {
            let sectionColor = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
            sectionColor.backgroundColor = .carbon
            return sectionColor
        } else {
            let sectionColor = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            sectionColor.backgroundColor = .sand40
            return sectionColor
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Section Footer height
        if section == (interactor?.rowViewSectionCount ?? 1) - 1 {
            return 100
        } else { return 1.0 }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dailyBriefCell = cell as? BaseDailyBriefCell else {
            return
        }
        interactor?.startTimer(forCell: dailyBriefCell, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dailyBriefCell = cell as? BaseDailyBriefCell else {
            return
        }
        interactor?.invalidateTimer(forCell: dailyBriefCell)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bucketModel = interactor?.bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        let bucketItem = bucketList?[indexPath.row]
        switch bucketItem?.domainModel?.bucketName {
        case .DAILY_CHECK_IN_1?:
            if (bucketItem as? ImpactReadinessCellViewModel) != nil {
                guard let impactReadinessCellViewModel = bucketItem as? ImpactReadinessCellViewModel else { return UITableViewCell()}
                return getImpactReadinessCell(tableView, indexPath, impactReadinessCellViewModel)
            } else if (bucketItem as? ImpactReadinessScoreViewModel) != nil {
                guard let impactReadinessScoreViewModel = bucketItem as? ImpactReadinessScoreViewModel else { return UITableViewCell()}
                return getImpactReadinessScoreCell(tableView, indexPath, impactReadinessScoreViewModel)
            }
            return UITableViewCell()
        case .DAILY_CHECK_IN_2?:
            guard let dailyCheckIn2ViewModel = bucketItem as? DailyCheckin2ViewModel else {
                return UITableViewCell()}
            switch dailyCheckIn2ViewModel.type {
            case .TBV?:
                return getDailyCheckIn2TBVCell(tableView,
                                               indexPath,
                                               dailyCheckIn2ViewModel.dailyCheckIn2TBVModel)
            case .PEAKPERFORMANCE?:
                return getDailyCheckIn2PeakPerformanceCell(tableView,
                                                           indexPath,
                                                           dailyCheckIn2ViewModel.dailyCheckIn2PeakPerformanceModel)
            case .SHPI?:
                return getDailyCheckinInsightsSHPICell(tableView,
                                                       indexPath, dailyCheckIn2ViewModel.dailyCheck2SHPIModel)
            case .none:
                return UITableViewCell()
            }
        case .EXPLORE?:
            guard let exploreViewModel = bucketItem as? ExploreCellViewModel else {return UITableViewCell()}
            return getExploreCell(tableView, indexPath, exploreViewModel)
        case .SPRINT_CHALLENGE?:
            guard let sprintChallengeModel = bucketItem as? SprintChallengeViewModel else {return UITableViewCell()}
            return getSprints(tableView, indexPath, sprintChallengeModel)
        case .ME_AT_MY_BEST?:
            if bucketItem?.domainModel?.toBeVision == nil {
                guard  let meAtMyBestCellEmptyViewModel = bucketItem as? MeAtMyBestCellEmptyViewModel else {return UITableViewCell() }
                return getMeAtMyBestEmpty(tableView, indexPath, meAtMyBestCellEmptyViewModel)
            } else {
                guard let meAtMyBestCellViewModel = bucketItem as? MeAtMyBestCellViewModel else {return UITableViewCell()}
                return getMeAtMyBest(tableView, indexPath, meAtMyBestCellViewModel)
            }
        case .ABOUT_ME?:
            guard let aboutMeModel = bucketItem as? AboutMeViewModel else {return UITableViewCell()}
            return getAboutMeCell(tableView, indexPath, aboutMeModel)
        case .SOLVE_REFLECTION?:
            if (bucketItem as? SolveReminderCellViewModel) != nil {
                guard let solveReminderCellViewModel = bucketItem as? SolveReminderCellViewModel else { return UITableViewCell()}
                return getSolveReminder(tableView, indexPath, solveReminderCellViewModel)
            } else if (bucketItem as? SolveReminderTableCellViewModel) != nil {
                guard let solveReminderTableCellViewModel = bucketItem as? SolveReminderTableCellViewModel else { return UITableViewCell()}
                return getSolveReminderTableCell(tableView, indexPath, solveReminderTableCellViewModel)
            }
            return UITableViewCell()
        case .GET_TO_LEVEL_5?:
            guard let level5ViewModel = bucketItem as? Level5ViewModel else { return UITableViewCell()}
            return getlevel5(tableView, indexPath, level5ViewModel)
        case .QUESTION_WITHOUT_ANSWER?:
            guard let questionCellViewModel = bucketItem as? QuestionCellViewModel else {return UITableViewCell()}
            return getRandomQuestionCell(tableView, indexPath, questionCellViewModel)
        case .LATEST_WHATS_HOT?:
            guard let whatsHotCellViewModel = bucketItem as? WhatsHotLatestCellViewModel else {return UITableViewCell()}
            return getWhatsHot(tableView, indexPath, whatsHotCellViewModel)
        case .THOUGHTS_TO_PONDER?:
            guard let thoughtCellViewModel = bucketItem as? ThoughtsCellViewModel else { return UITableViewCell()}
            return getThoughtsCell(tableView, indexPath, thoughtCellViewModel)
        case .GOOD_TO_KNOW?:
            guard let goodToKnow = bucketItem as? GoodToKnowCellViewModel else { return UITableViewCell() }
            return getGoodToKnowCell(tableView, indexPath, goodToKnow)
        case .FROM_MY_COACH?:
            guard let coachMessageCellViewModel = bucketItem as? FromMyCoachCellViewModel else { return UITableViewCell() }
            return getCoachMessageCell(tableView, indexPath, coachMessageCellViewModel)
        case .FROM_TIGNUM?:
            guard let fromTignum = bucketItem as? FromTignumCellViewModel else { return UITableViewCell()}
            return getFromTignumMessageCell(tableView, indexPath, fromTignum)
        case .BESPOKE?:
            guard let beSpokeViewModel = bucketItem as? BeSpokeCellViewModel else { return UITableViewCell() }
            return getBeSpokeCell(tableView, indexPath, beSpokeViewModel)
        case .DEPARTURE_INFO?:
            guard let departureInfoViewModel = bucketItem as? DepartureInfoCellViewModel else { return UITableViewCell()}
            return getDepartureInfoCell(tableView, indexPath, departureInfoViewModel)
        case .LEADERS_WISDOM?:
            guard let leadersWisdomViewModel = bucketItem as? LeaderWisdomCellViewModel else { return UITableViewCell()}
            return getLeadersWisdom(tableView, indexPath, leadersWisdomViewModel)
        case .FEAST_OF_YOUR_EYES?:
            guard let feastForEyesViewModel = bucketItem as? FeastCellViewModel else { return UITableViewCell()}
            return getFeastForEyesCell(tableView, indexPath, feastForEyesViewModel)
        case .MY_PEAK_PERFORMANCE?:
            guard let myPeakPerformanceViewModel = bucketItem as? MyPeakPerformanceCellViewModel else { return UITableViewCell()}
            return getMyPeakPerformance(tableView, indexPath, myPeakPerformanceViewModel)
        case .GUIDE_TRACK?:
            guard let guidedtrackModel = bucketItem as? GuidedTrackViewModel else { return UITableViewCell()}
            return getGuidedTrack(tableView, indexPath, guidedtrackModel)
        default:
           return UITableViewCell()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let bar = navBarHeader {
            bar.updateAlpha(basedOn: scrollView.contentOffset.y)
        }
        delegate?.handlePan(offsetY: scrollView.contentOffset.y)
    }
}

// MARK: Daily Brief Update Notification
private extension DailyBriefViewController {
    @objc func updateDailyBriefFromNotification(_ notification: NSNotification) {
        interactor?.getDailyBriefBucketsForViewModel()
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
        let cell: ImpactReadiness1 = tableView.dequeueCell(for: indexPath)
        cell.configure(viewModel: impactReadinessCellViewModel)
        if impactReadinessCellViewModel?.readinessScore == 0 {
            cell.impactReadinessButton.setTitle(R.string.localized.impactReadinessCellButtonGetStarted(), for: .normal)
        } else {
            cell.impactReadinessButton.setTitle(R.string.localized.impactReadinessCellButtonExplore(), for: .normal)
            cell.impactReadinessButton.setImage(UIImage(named: "arrowDown.png"), for: .normal)
        }
        cell.backgroundColor = .carbon
        cell.delegate = self
        return cell
    }

    func getImpactReadinessScoreCell(_ tableView: UITableView,
                                _ indexPath: IndexPath,
                                _ impactReadinessScoreViewModel: ImpactReadinessScoreViewModel?) -> UITableViewCell {
        let cell: ImpactReadinessCell2 = tableView.dequeueCell(for: indexPath)
        cell.configure(viewModel: impactReadinessScoreViewModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
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
        cell.delegate = self
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
        cell.delegate = self
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
        cell.delegate = self
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
        cell.delegate = self
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
     * Method name: getSolveReminderTableCell.
     * Description: Placeholder to display the Solve Reminder Table Cell.
     * Parameters: [tableView], [IndexPath]
     */
    func getSolveReminderTableCell(_ tableView: UITableView,
                          _ indexPath: IndexPath,
                          _ solveReminderTableCellViewModel: SolveReminderTableCellViewModel?) -> UITableViewCell {
        let cell: SolveTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: solveReminderTableCellViewModel?.title, date: solveReminderTableCellViewModel?.date, solve: solveReminderTableCellViewModel?.solve)
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
                   _ level5ViewModel: Level5ViewModel?) -> UITableViewCell {
        let cell: Level5Cell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: level5ViewModel!)
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
        cell.delegate = self
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
            cell.delegate = self
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
            cell.strategyView.addGestureRecognizer(gesture)
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           labelPosition: CGFloat(exploreViewModel?.labelPosition ?? 0),
                           bucketTitle: exploreViewModel?.bucketTitle ?? "")
        } else if exploreViewModel?.section == .QOTLibrary {
            self.selectedToolID = exploreViewModel?.remoteID
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openTool))
            cell.strategyView.addGestureRecognizer(gesture)
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           labelPosition: CGFloat(exploreViewModel?.labelPosition ?? 0),
                           bucketTitle: exploreViewModel?.bucketTitle ?? "")
        }
        cell.backgroundColor = .carbon
        return cell
    }

    /**
     * Method name: getGuidedTrack.
     * Description: Placeholder to display the Guided Track Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getGuidedTrack(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ guidedtrackModel: GuidedTrackViewModel?) -> UITableViewCell {
        if guidedtrackModel?.type == GuidedTrackItemType.SECTION {
            let cell: GuidedTrackSectionCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: guidedtrackModel)
            cell.backgroundColor = .carbon
            return cell
        }
        let cell: GuidedTrackRowCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: guidedtrackModel)
        cell.delegate = self
        cell.backgroundColor = .carbon
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, .greatestFiniteMagnitude)
        return cell
    }
}

// MARK: - DumViewControllerInterface

extension  DailyBriefViewController: DailyBriefViewControllerInterface {

    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>) {
        tableView.reload(using: differenceList, with: .middle) { data in
            self.interactor?.updateViewModelListNew(data)
        }
    }

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
        self.removeLoadingSkeleton()
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
        tableView.registerDequeueable(SolveReminderCell.self)
        tableView.registerDequeueable(SprintChallengeCell.self)
        tableView.registerDequeueable(GuidedTrackTableViewCell.self)
        tableView.registerDequeueable(GuidedTrackSectionCell.self)
        tableView.registerDequeueable(GuidedTrackRowCell.self)
        tableView.registerDequeueable(ImpactReadiness1.self)
        tableView.registerDequeueable(ImpactReadinessCell2.self)
        tableView.registerDequeueable(SolveTableViewCell.self)
    }
}

extension DailyBriefViewController: DailyBriefViewControllerDelegate {

    func openGuidedTrackAppLink(_ appLink: String?) {
        interactor?.openGuidedTrackAppLink(appLink)
    }

    func displayCoachPreparationScreen() {
        interactor?.displayCoachPreparationScreen()
    }

    func presentMyDataScreen() {
        interactor?.presentMyDataScreen()
    }

    func didUpdateLevel5() {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
    }

    func didPressGotItSprint(sprint: QDMSprint) {
        interactor?.didPressGotItSprint(sprint: sprint)
    }

    func reloadSprintCell(cell: UITableViewCell) {
        if let cellIndexPath = tableView.indexPath(for: cell) {
            self.tableView.reloadRows(at: [cellIndexPath], with: .none)
        }
    }

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

    func presentCopyRight(copyrightURL: String?) {
        interactor?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func openStrategyFromSprint(strategyID: Int?) {
        interactor?.presentStrategyList(selectedStrategyID: strategyID ?? 0)
    }

    func openToolFromSprint(toolID: Int?) {
        interactor?.presentToolsItems(selectedToolID: toolID ?? 0)
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

extension DailyBriefViewController: PopUpCopyrightViewControllerProtocol {

    func cancelAction() {
         self.dismiss(animated: true, completion: nil)
    }
}
