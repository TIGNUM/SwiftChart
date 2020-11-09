//
//  DailyBriefViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import DifferenceKit
import SafariServices

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: BaseWithTableViewController, ScreenZLevelBottom, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    typealias SectionData = [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]
    weak var delegate: CoachCollectionViewControllerDelegate?
    var interactor: DailyBriefInteractorInterface!
    var sectionDataList: SectionData = []
    private weak var navBarHeader: NavBarTableViewCell?
    private var selectedStrategyID: Int?
    private var selectedToolID: Int?
    private lazy var router = DailyBriefRouter(viewController: self)
    private var isDragging = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        navigationController?.navigationBar.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        interactor.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateBuckets),
                                               name: .didRateTBV, object: nil)
        _ = NotificationCenter.default.addObserver(forName: .didUpdateDailyBriefBuckets,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.updateDailyBriefFromNotification(notification)

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.getDailyBriefBucketsForViewModel()
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        trackPage()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DailyBriefViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.rowViewSectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.bucketViewModelNew()?.at(index: section)?.elements.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 44 : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = R.nib.newDailyBriefTableViewHeader(owner: self)
        headerView?.configure(tapLeft: { [weak self] in
            self?.delegate?.moveToCell(item: 0)
        }, tapRight: { [weak self] in
            self?.delegate?.moveToCell(item: 2)
        })
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(origin: .zero, size: tableView.frame.size))

        if section == interactor.rowViewSectionCount - 1 {
            footer.backgroundColor = ThemeView.level1.color
            return footer
        }

        footer.backgroundColor = .sand10
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == interactor.rowViewSectionCount - 1) ? 100 : 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dailyBriefCell = cell as? BaseDailyBriefCell {
            interactor.startTimer(forCell: dailyBriefCell, at: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dailyBriefCell = cell as? BaseDailyBriefCell {
            interactor.invalidateTimer(forCell: dailyBriefCell)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section),
                let domainModel = bucketModel.elements[indexPath.row].domainModel else {
            switch indexPath.section {
            case 0:
                return getImpactReadinessCell(tableView, indexPath, nil)
            case 1:
                return getDailyCheckIn2TBVCell(tableView, indexPath, nil)
            case 2:
                return getRandomQuestionCell(tableView, indexPath, nil)
            case 3:
                return getMeAtMyBestEmpty(tableView, indexPath, nil)
            case 4:
                return getGoodToKnowCell(tableView, indexPath, nil)
            case 5:
                return getExploreCell(tableView, indexPath, nil)
            case 6:
                return getLeadersWisdom(tableView, indexPath, nil)
            case 7:
                return getDepartureBespokeFeastCell(tableView, indexPath, nil)
            case 8:
                return getThoughtsCell(tableView, indexPath, nil)
            case 9:
                return getDepartureBespokeFeastCell(tableView, indexPath, nil)
            case 10:
                return getAboutMeCell(tableView, indexPath, nil)
            case 11:
                return getWhatsHot(tableView, indexPath, nil)
            case 12:
                return getlevel5(tableView, indexPath, nil)
            case 13:
                return getFromTignumMessageCell(tableView, indexPath, nil)
            case 14:
                return getWeatherCell(tableView, indexPath, nil)
            case 15:
                return getMindsetShifterCell(tableView, indexPath, nil)
            case 16:
                return getExpertThoughts(tableView, indexPath, nil)
            case 17:
                return getTeamToBeVisionCell(tableView, indexPath, nil)
            case 18:
                return getTeamVisionSuggestionCell(tableView, indexPath, nil)
            case 19:
                return getTeamInvitationCell(tableView, indexPath, nil)
            case 20:
                return getOpenPollCell(tableView, indexPath, nil)
            case 21:
                return getOpenRateCell(tableView, indexPath, nil)
            default:
                return UITableViewCell()
            }
        }
        let bucketList = bucketModel.elements
        let bucketItem = bucketList[indexPath.row]

        switch domainModel.bucketName {
        case .DAILY_CHECK_IN_1?:
            if (bucketItem as? ImpactReadinessCellViewModel) != nil,
                let impactReadinessCellViewModel = bucketItem as? ImpactReadinessCellViewModel {
                    return getImpactReadinessCell(tableView, indexPath, impactReadinessCellViewModel)
            } else if (bucketItem as? ImpactReadinessScoreViewModel) != nil,
                let impactReadinessScoreViewModel = bucketItem as? ImpactReadinessScoreViewModel {
                    return getImpactReadinessScoreCell(tableView, indexPath, impactReadinessScoreViewModel)
            }
            return getImpactReadinessCell(tableView, indexPath, nil)
        case .DAILY_CHECK_IN_2?:
            guard let dailyCheckIn2ViewModel = bucketItem as? DailyCheckin2ViewModel else {
                return getDailyCheckIn2TBVCell(tableView, indexPath, nil)
            }
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
            return getExploreCell(tableView, indexPath, bucketItem as? ExploreCellViewModel)
        case .SPRINT_CHALLENGE?:
            return getSprints(tableView, indexPath, bucketItem as? SprintChallengeViewModel)
        case .ME_AT_MY_BEST?:
            if bucketItem.domainModel?.toBeVisionTrack?.sentence?.isEmpty != false {
                return getMeAtMyBestEmpty(tableView, indexPath, bucketItem as? MeAtMyBestCellEmptyViewModel)
            }
            return getMeAtMyBest(tableView, indexPath, bucketItem as? MeAtMyBestCellViewModel)
        case .ABOUT_ME?:
            return getAboutMeCell(tableView, indexPath, bucketItem as? AboutMeViewModel)
        case .SOLVE_REFLECTION?:
            if (bucketItem as? SolveReminderCellViewModel) != nil {
                return getSolveReminder(tableView, indexPath, bucketItem as? SolveReminderCellViewModel)
            } else if (bucketItem as? SolveReminderTableCellViewModel) != nil {
                return getSolveReminderTableCell(tableView, indexPath, bucketItem as? SolveReminderTableCellViewModel)
            }
            return UITableViewCell()
        case .GET_TO_LEVEL_5?:
            return getlevel5(tableView, indexPath, bucketItem as? Level5ViewModel)
        case .QUESTION_WITHOUT_ANSWER?:
            return getRandomQuestionCell(tableView, indexPath, bucketItem as? QuestionCellViewModel)
        case .LATEST_WHATS_HOT?:
            return getWhatsHot(tableView, indexPath, bucketItem as? WhatsHotLatestCellViewModel)
        case .THOUGHTS_TO_PONDER?:
            return getThoughtsCell(tableView, indexPath, bucketItem as? ThoughtsCellViewModel)
        case .GOOD_TO_KNOW?:
            return getGoodToKnowCell(tableView, indexPath, bucketItem as? GoodToKnowCellViewModel)
        case .FROM_MY_COACH?:
            return getCoachMessageCell(tableView, indexPath, bucketItem as? FromMyCoachCellViewModel)
        case .FROM_TIGNUM?:
            return getFromTignumMessageCell(tableView, indexPath, bucketItem as? FromTignumCellViewModel)
        case .BESPOKE?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .DEPARTURE_INFO?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .LEADERS_WISDOM?:
            return getLeadersWisdom(tableView, indexPath, bucketItem as? LeaderWisdomCellViewModel)
        case .EXPERT_THOUGHTS?:
            return getExpertThoughts(tableView, indexPath, bucketItem as? ExpertThoughtsCellViewModel)
        case .FEAST_OF_YOUR_EYES?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .MY_PEAK_PERFORMANCE?:
            return getMyPeakPerformance(tableView, indexPath, bucketItem as? MyPeakPerformanceCellViewModel)
        case .GUIDE_TRACK?:
            let showDivider = indexPath.row == bucketList.count - 1
            return getGuidedTrack(tableView, indexPath, showDivider, bucketItem as? GuidedTrackViewModel)
        case .WEATHER?:
            return getWeatherCell(tableView, indexPath, bucketItem as? WeatherViewModel)
        case .MINDSET_SHIFTER?:
            return getMindsetShifterCell(tableView, indexPath, bucketItem as? MindsetShifterViewModel)
        case .TEAM_TO_BE_VISION?:
            return getTeamToBeVisionCell(tableView, indexPath, bucketItem as? TeamToBeVisionCellViewModel)
        case .TEAM_VISION_SUGGESTION?:
            return getTeamVisionSuggestionCell(tableView, indexPath, bucketItem as? TeamVisionSuggestionModel)
        case .TEAM_INVITATION?:
            return getTeamInvitationCell(tableView, indexPath, bucketItem as? TeamInvitationModel)
        case .TEAM_NEWS_FEED?:
            return getTeamNewsFeed(tableView, indexPath, bucketItem as? TeamNewsFeedDailyBriefViewModel)
        case .TEAM_TOBEVISION_GENERATOR_POLL?:
            return getOpenPollCell(tableView, indexPath, bucketItem as? PollOpenModel)
        case .TEAM_TOBEVISION_TRACKER_POLL?:
            if (bucketItem as? RateOpenModel) != nil,
               let rateViewModel = bucketItem as? RateOpenModel {
                return getOpenRateCell(tableView, indexPath, rateViewModel)
            } else if (bucketItem as? RatingFeedbackModel ) != nil,
                      let feedbackModel = bucketItem as? RatingFeedbackModel {
                return getRatingFeedbackCell(tableView, indexPath, feedbackModel)
            }
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        let bucketItem = bucketList?[indexPath.row]

        guard let bucketName = bucketItem?.domainModel?.bucketName else { return }

        switch bucketName {
        case .DAILY_CHECK_IN_1:
            guard let impactReadinessCellViewModel = bucketItem as? ImpactReadinessCellViewModel else { break }
            if impactReadinessCellViewModel.readinessScore == -1 {
                showDailyCheckInQuestions()
            } else {
                router.presentDailyBriefDetailsScreen(model: impactReadinessCellViewModel)
            }
        case .LATEST_WHATS_HOT:
             didSelectRow(at: indexPath)
             guard let whatsHotArticleId = bucketItem?.domainModel?.contentCollectionIds?.first else { break }
             router.presentContent(whatsHotArticleId)
        case .SOLVE_REFLECTION:
            didSelectRow(at: indexPath)
            if (bucketItem as? SolveReminderTableCellViewModel) != nil {
                let model = bucketItem as? SolveReminderTableCellViewModel
                guard let solve = model?.solve else { break }
                showSolveResults(solve: solve)
            }
        case .TEAM_NEWS_FEED:
            guard let viewModel = bucketItem as? TeamNewsFeedDailyBriefViewModel else { break }
            handleTableViewRowSelection(with: viewModel, at: indexPath)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.setSelected(false, animated: true)
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navBarHeader?.updateAlpha(basedOn: scrollView.contentOffset.y)
        delegate?.handlePan(offsetY: scrollView.contentOffset.y,
                            isDragging: isDragging,
                            isScrolling: scrollView.isDragging || scrollView.isDecelerating)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
        scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)
    }
}

// MARK: - IBActions
private extension DailyBriefViewController {
    @IBAction func didTapLeftArrowButton(_ sender: Any?) {
        delegate?.moveToCell(item: 0)
    }

    @IBAction func didTapRightArrowButton(_ sender: Any?) {
        delegate?.moveToCell(item: 2)
    }
}

// MARK: - Daily Brief Update Notification
private extension DailyBriefViewController {
    @objc func updateDailyBriefFromNotification(_ notification: Notification) {
        interactor.getDailyBriefBucketsForViewModel()
    }

    @objc func updateBuckets() {
        interactor.getDailyBriefBucketsForViewModel()
    }
}

// MARK: - Get TableViewCells
private extension DailyBriefViewController {

    /**
     * Method name: impactReadinessCell.
     * Description: Placeholder to display the Random Question Cell Information.
     * Parameters: [tableView], [IndexPath]
     */

    func getImpactReadinessCell(_ tableView: UITableView,
                                _ indexPath: IndexPath,
                                _ impactReadinessCellViewModel: ImpactReadinessCellViewModel?) -> UITableViewCell {
//        let cell: ImpactReadiness1 = tableView.dequeueCell(for: indexPath)
//        cell.clickableLinkDelegate = self
//        cell.configure(viewModel: impactReadinessCellViewModel, tapLeft: { [weak self] in
//                        self?.delegate?.moveToCell(item: 0)
//                        }, tapRight: { [weak self] in
//                            self?.delegate?.moveToCell(item: 2)
//                    })
//        cell.delegate = self
        let cell: NewBaseDailyBriefCell = tableView.dequeueCell(for: indexPath)

        let standardModel1 = NewDailyBriefStandardModel.init(caption: impactReadinessCellViewModel?.title ?? "",
                                                             title: impactReadinessCellViewModel?.title ?? "",
                                                             body: impactReadinessCellViewModel?.feedback ?? "",
                                                             image: "",
                                                             domainModel: nil)
        cell.configure(with: [standardModel1])

        return cell
    }

    func getImpactReadinessScoreCell(_ tableView: UITableView,
                                     _ indexPath: IndexPath,
                                     _ impactReadinessScoreViewModel: ImpactReadinessScoreViewModel?)
        -> UITableViewCell {
            let cell: ImpactReadinessCell2 = tableView.dequeueCell(for: indexPath)
            cell.configure(viewModel: impactReadinessScoreViewModel)
            cell.delegate = self
            return cell
    }

    /**
     * Method name: getRandomQuestionCell.
     * Description: Placeholder to display the Random Question Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getRandomQuestionCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ questionCellViewModel: QuestionCellViewModel?) -> UITableViewCell {
        let cell: QuestionCell = tableView.dequeueCell(for: indexPath)
        cell.clickableLinkDelegate = self
        cell.configure(with: questionCellViewModel)
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
        cell.clickableLinkDelegate = self
        cell.configure(with: thoughtsCellViewModel)

        return cell
    }

    /**
     * Method name: getGoodToKnowCell.
     * Description: Placeholder to display the Random Good To Know Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getGoodToKnowCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           _ goodToKnowCellViewModel: GoodToKnowCellViewModel?) -> UITableViewCell {
        let cell: GoodToKnowCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: goodToKnowCellViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name: getCoachMessageCell.
     * Description: Placeholder to display the Random Departure Info Cell Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getCoachMessageCell(_ tableView: UITableView,
                             _ indexPath: IndexPath,
                             _ coachMessageModel: FromMyCoachCellViewModel?) -> UITableViewCell {
        let cell: FromMyCoachCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: coachMessageModel)
        cell.clickableLinkDelegate = self
        return cell
    }

    func getDepartureBespokeFeastCell(_ tableView: UITableView,
                              _ indexPath: IndexPath,
                              _ departureBespokeFeastModel: DepartureBespokeFeastModel?) -> UITableViewCell {
        let cell: DepartureBespokeFeastCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: departureBespokeFeastModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
        cell.configure(with: aboutMeViewModel)
        return cell
    }

    /**
     * Method name: getMindsetShifterCell.
     * Description: Placeholder to display the Mindset Shifter Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getMindsetShifterCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ mindsetShifterViewModel: MindsetShifterViewModel?) -> UITableViewCell {
        let cell: MindsetShifterCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: mindsetShifterViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
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
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        let cell: WhatsHotLatestCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: whatsHotViewModel)
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
        cell.delegate = self
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
        cell.configure(title: solveReminderTableCellViewModel?.title,
                       date: solveReminderTableCellViewModel?.date,
                       solve: solveReminderTableCellViewModel?.solve)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        cell.configure(with: level5ViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name: getLeadersWisdom.
     * Description: Placeholder to display the leaders wisdom Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getExpertThoughts(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           _ expertThoughtsViewModel: ExpertThoughtsCellViewModel?) -> UITableViewCell {
        let cell: ExpertThoughtsTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: expertThoughtsViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
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
        let cell: DailyCheckinSHPICell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: dailyCheck2SHPIModel)
        cell.clickableLinkDelegate = self
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
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name: getDailyCheckIn2PeakPerformanceModel.
     * Description: Placeholder to display the getDailyCheckIn2TBV Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getDailyCheckIn2PeakPerformanceCell(_ tableView: UITableView,
                                             _ indexPath: IndexPath,
                                             _ dailyCheckIn2PeakPerformanceModel: DailyCheckIn2PeakPerformanceModel?)
        -> UITableViewCell {
            let cell: DailyCheckinInsightsPeakPerformanceCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: dailyCheckIn2PeakPerformanceModel)
            cell.delegate = self
            cell.clickableLinkDelegate = self
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
        let cell: MyPeakPerformanceCell = tableView.dequeueCell(for: indexPath)
        cell.dailyBriefViewControllerDelegate = self
        cell.configure(with: peakPerformanceModel)
        cell.clickableLinkDelegate = self
        return cell
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
        cell.clickableLinkDelegate = self
        if exploreViewModel?.section == .LearnStrategies {
            self.selectedStrategyID = exploreViewModel?.remoteID
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           bucketTitle: exploreViewModel?.bucketTitle ?? "",
                           isStrategy: true,
                           remoteID: exploreViewModel?.remoteID)
            cell.delegate = self
        } else if exploreViewModel?.section == .QOTLibrary {
            self.selectedToolID = exploreViewModel?.remoteID
            cell.configure(title: exploreViewModel?.title,
                           introText: exploreViewModel?.introText ?? "",
                           bucketTitle: exploreViewModel?.bucketTitle ?? "",
                           isStrategy: false,
                           remoteID: exploreViewModel?.remoteID)
            cell.delegate = self
        }
        return cell
    }

    /**
     * Method name: getGuidedTrack.
     * Description: Placeholder to display the Guided Track Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getGuidedTrack(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ hideDivider: Bool,
                        _ guidedtrackModel: GuidedTrackViewModel?) -> UITableViewCell {
        if guidedtrackModel?.type == GuidedTrackItemType.SECTION {
            let cell: GuidedTrackSectionCell = tableView.dequeueCell(for: indexPath)
            cell.configure(with: guidedtrackModel)
            cell.button.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -8.0)
            return cell
        }
        let cell: GuidedTrackRowCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: guidedtrackModel, hideDivider)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }

    /**
     * Method name: getWeatherCellgetGuidedTrack.
     * Description: Placeholder to display the Weather Information.
     * Parameters: [tableView], [IndexPath]
     */
    func getWeatherCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ weatherModel: WeatherViewModel?) -> UITableViewCell {
        let cell: WeatherCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: weatherModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name :getTeamToBeVisionCell.
     * Description: Placeholder to display the latest Team To be Vision created.
     * Parameters: [tableView], [IndexPath]
     */
    func getTeamToBeVisionCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ teamVisionModel: TeamToBeVisionCellViewModel?) -> UITableViewCell {
        let cell: TeamToBeVisionCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: teamVisionModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name:getTeamVisionSuggestionCell.
     * Description: Placeholder to display the Team To Bbe Vision Suggestion.
     * Parameters: [tableView], [IndexPath]
     */
    func getTeamVisionSuggestionCell(_ tableView: UITableView,
                                     _ indexPath: IndexPath,
                                     _ teamVisionSuggestionModel: TeamVisionSuggestionModel?) -> UITableViewCell {
        let cell: TeamVisionSuggestionCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: teamVisionSuggestionModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name:getTeamInvitationCell.
     * Description: Placeholder to display the Team To Be Vision Suggestion.
     * Parameters: [tableView], [IndexPath]
     */
    func getTeamInvitationCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ teamInvitationModel: TeamInvitationModel?) -> UITableViewCell {
        let cell: TeamInvitationCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: teamInvitationModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name: getOpenPollCell.
     * Description: Placeholder to display that the TBV Poll is Open.
     * Parameters: [tableView], [IndexPath]
     */
    func getOpenPollCell(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ pollOpenModel: PollOpenModel?) -> UITableViewCell {
        let cell: PollOpenCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: pollOpenModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    /**
     * Method name: getOpenRateCell.
     * Description: Placeholder to display that the TBV Rating Tracker is Open.
     * Parameters: [tableView], [IndexPath]
     */
    func getOpenRateCell(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ rateOpenModel: RateOpenModel?) -> UITableViewCell {
        let cell: RateOpenCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: rateOpenModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getRatingFeedbackCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ ratingFeedbackModel: RatingFeedbackModel?) -> UITableViewCell {
        let cell: RatingFeedbackCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: ratingFeedbackModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }
}

// MARK: - DailyBriefViewControllerInterface
extension  DailyBriefViewController: DailyBriefViewControllerInterface {
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]>) {
        tableView.reload(using: differenceList, with: .fade) { data in
            self.interactor.updateViewModelListNew(data)
        }
    }

    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.registerDequeueable(WhatsHotLatestCell.self)
        tableView.registerDequeueable(QuestionCell.self)
        tableView.registerDequeueable(ThoughtsCell.self)
        tableView.registerDequeueable(GoodToKnowCell.self)
        tableView.registerDequeueable(FromTignumCell.self)
        tableView.registerDequeueable(DailyCheckinInsightsTBVCell.self)
        tableView.registerDequeueable(DailyCheckinSHPICell.self)
        tableView.registerDequeueable(DailyCheckinInsightsPeakPerformanceCell.self)
        tableView.registerDequeueable(ExploreCell.self)
        tableView.registerDequeueable(AboutMeCell.self)
        tableView.registerDequeueable(MeAtMyBestCell.self)
        tableView.registerDequeueable(Level5Cell.self)
        tableView.registerDequeueable(FromMyCoachCell.self)
        tableView.registerDequeueable(LeaderWisdomTableViewCell.self)
        tableView.registerDequeueable(MyPeakPerformanceCell.self)
        tableView.registerDequeueable(MeAtMyBestEmptyCell.self)
        tableView.registerDequeueable(SolveReminderCell.self)
        tableView.registerDequeueable(SprintChallengeCell.self)
        tableView.registerDequeueable(GuidedTrackSectionCell.self)
        tableView.registerDequeueable(GuidedTrackRowCell.self)
        tableView.registerDequeueable(ImpactReadiness1.self)
        tableView.registerDequeueable(ImpactReadinessCell2.self)
        tableView.registerDequeueable(SolveTableViewCell.self)
        tableView.registerDequeueable(WeatherCell.self)
        tableView.registerDequeueable(DepartureBespokeFeastCell.self)
        tableView.registerDequeueable(MindsetShifterCell.self)
        tableView.registerDequeueable(ExpertThoughtsTableViewCell.self)
        tableView.registerDequeueable(TeamToBeVisionCell.self)
        tableView.registerDequeueable(TeamVisionSuggestionCell.self)
        tableView.registerDequeueable(TeamInvitationCell.self)
        tableView.registerDequeueable(DailyBriefTeamNewsFeedHeaderCell.self)
        tableView.registerDequeueable(DailyBriefTeamNewsFeedFooterCell.self)
        tableView.registerDequeueable(ArticleBookmarkTableViewCell.self)
        tableView.registerDequeueable(VideoBookmarkTableViewCell.self)
        tableView.registerDequeueable(AudioBookmarkTableViewCell.self)
        tableView.registerDequeueable(NoteTableViewCell.self)
        tableView.registerDequeueable(DownloadTableViewCell.self)
        tableView.registerDequeueable(PollOpenCell.self)
        tableView.registerDequeueable(RateOpenCell.self)
        tableView.registerDequeueable(RatingFeedbackCell.self)
        tableView.registerDequeueable(NewBaseDailyBriefCell.self)
    }

    func scrollToSection(at: Int) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: at), at: .middle, animated: true)
    }

    @objc func dismissAlert() {
        QOTAlert.dismiss()
    }
}

// MARK: - DailyBriefViewControllerDelegate
extension DailyBriefViewController: DailyBriefViewControllerDelegate {
    func didChangeLocationPermission(granted: Bool) {
        if granted {
            requestSynchronization(.DAILY_BRIEF_WEATHER, .DOWN_SYNC)
        }
    }

    func didUpdateLevel5() {
        tableView.beginUpdates()
        tableView.setNeedsLayout()
        tableView.endUpdates()
    }

    func reloadSprintCell(cell: UITableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) {
        interactor.saveAnswerValue(value)
    }

    func saveTargetValue(value: Int?) {
        interactor.saveTargetValue(value: value)
    }

    func showAlert(message: String?) {
        let closeButtonItem = createCloseButton(#selector(dismissAlert))
        QOTAlert.show(title: nil, message: message, bottomItems: [closeButtonItem])
    }

    // TODO Set correct pageName
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?) {
        stream(videoURL: videoURL ?? URL(string: "")!, contentItem: contentItem)
    }

    func presentTeamPendingInvites() {
        router.presentTeamPendingInvites()
    }

    func showBanner(message: String) {
        let banner = NotificationBanner.shared
        banner.configure(message: message, isDark: false)
        banner.show(in: self.view)
    }

    func showTBV() {
        router.showTBV()
    }

    func showTeamTBV(_ team: QDMTeam) {
        interactor.getTeamTBVPoll(for: team) { [weak self] (poll) in
            self?.router.showTeamTBV(team, poll)
        }
    }

    func didSelectDeclineTeamInvite(invitation: QDMTeamInvitation) {
        interactor.didSelectDeclineTeamInvite(invitation: invitation)
    }

    func didSelectJoinTeamInvite(invitation: QDMTeamInvitation) {
        interactor.didSelectJoinTeamInvite(invitation: invitation)
    }

    func presentToBeVisionPoll(for team: QDMTeam) {
        router.showExplanation(team, type: .tbvPollUser)
    }

    func presentToBeVisionRate(for team: QDMTeam) {
        router.showExplanation(team, type: .ratingUser)
    }

    func presentRateHistory(for team: QDMTeam) {
        router.showTracker(for: team)
    }
}

// MARK: - Navigation
extension DailyBriefViewController {
    func showCustomizeTarget() {
        interactor.customizeSleepQuestion { [weak self] (question) in
            self?.router.presentCustomizeTarget(question)
        }
    }

    func showDailyCheckInQuestions() {
        router.presentDailyCheckInQuestions()
    }

    func openGuidedTrackAppLink(_ appLink: QDMAppLink?) {
        router.launchAppLinkGuidedTrack(appLink)
    }

    func displayCoachPreparationScreen() {
        router.presentCoachPreparation()
    }

    func presentMyDataScreen() {
        router.showMyDataScreen()
    }

    func presentPopUp(copyrightURL: String?, description: String?) {
        router.presentPopUp(copyrightURL: copyrightURL, description: description)
    }

    func openTools(toolID: Int?) {
        if let contentId = toolID {
            router.presentContent(contentId)
        }
    }

    func showSolveResults(solve: QDMSolve) {
        router.presentSolveResults(solve: solve)
    }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        router.presentPrepareResults(for: preparation)
    }

    func presentMyToBeVision() {
        router.showTBV()
    }

    func presentMindsetResults(for mindsetShifter: QDMMindsetShifter?) {
        router.presentMindsetResults(mindsetShifter)
    }

    @objc func openStrategy(sender: UITapGestureRecognizer) {
        presentStrategyList(strategyID: selectedStrategyID)
    }

    func presentStrategyList(strategyID: Int?) {
        if let contentId = strategyID {
            router.presentContent(contentId)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? BaseDailyBriefDetailsViewController,
           let model = sender as? BaseDailyBriefViewModel {
            BaseDailyBriefDetailsConfigurator.configure(model: model, viewController: controller)
        }
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
        interactor.customizeSleepQuestion { (question) in
            let answers = question?.answers?.count ?? 0
            question?.selectedAnswerIndex = (answers - 1) - answer
        }
    }
}

extension DailyBriefViewController: PopUpCopyrightViewControllerProtocol {
    func cancelAction() {
         dismiss(animated: true)
    }
}
