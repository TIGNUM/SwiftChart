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

protocol DailyBriefViewControllerDelegate: class {
    func openToolFromSprint(toolID: Int?)
    func openStrategyFromSprint(strategyID: Int?)
    func didPressGotItSprint(sprint: QDMSprint)
    func showSolveResults(solve: QDMSolve)
    func presentMyToBeVision()
    func showCustomizeTarget()
    func saveAnswerValue(_ value: Int, from cell: UITableViewCell)
    func saveTargetValue(value: Int?)
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?)
    func presentPrepareResults(for preparation: QDMUserPreparation?)
    func presentCopyRight(copyrightURL: String?)
    func reloadSprintCell(cell: UITableViewCell)
    func didUpdateLevel5()
    func displayCoachPreparationScreen()
    func openGuidedTrackAppLink(_ appLink: QDMAppLink?)
    func presentMyDataScreen()
    func didChangeLocationPermission(granted: Bool)
    func showDailyCheckInQuestions()
}

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: BaseWithTableViewController, ScreenZLevelBottom, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    typealias SectionData = [ArraySection<DailyBriefViewModel.Bucket, BaseDailyBriefViewModel>]

    weak var delegate: CoachCollectionViewControllerDelegate?
    var interactor: DailyBriefInteractorInterface!
    var sectionDataList: SectionData = []

    private var navBarHeader: NavBarTableViewCell?
    private var selectedStrategyID: Int?
    private var selectedToolID: Int?

    private lazy var router = DailyBriefRouter(viewController: self)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        navigationController?.navigationBar.isHidden = true
        tableView.rowHeight = UITableViewAutomaticDimension
        interactor.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDailyBriefFromNotification(_:)),
                                               name: .didUpdateDailyBriefBuckets,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.getDailyBriefBucketsForViewModel()
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        trackPage()
    }
}

// MARK - UITableViewDelegate, UITableViewDataSource
extension DailyBriefViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.rowViewSectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.bucketViewModelNew()?.at(index: section)?.elements.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
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
        return UITableViewAutomaticDimension
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
        case .FEAST_OF_YOUR_EYES?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .MY_PEAK_PERFORMANCE?:
            return getMyPeakPerformance(tableView, indexPath, bucketItem as? MyPeakPerformanceCellViewModel)
        case .GUIDE_TRACK?:
            let showDivider = indexPath.row == bucketList.count - 1
            return getGuidedTrack(tableView, indexPath, showDivider, bucketItem as? GuidedTrackViewModel)
        case .WEATHER?:
            return getWeatherCell(tableView, indexPath, bucketItem as? WeatherViewModel)
        default:
           return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        let bucketItem = bucketList?[indexPath.row]

        switch bucketItem?.domainModel?.bucketName {
        case .LATEST_WHATS_HOT?:
             didSelectRow(at: indexPath)
             guard let whatsHotArticleId = bucketItem?.domainModel?.contentCollectionIds?.first else { break }
             router.presentWhatsHotArticle(articleID: whatsHotArticleId)
        case .SOLVE_REFLECTION?:
            didSelectRow(at: indexPath)
            if (bucketItem as? SolveReminderTableCellViewModel) != nil {
                let model = bucketItem as? SolveReminderTableCellViewModel
                guard let solve = model?.solve else { break }
                showSolveResults(solve: solve)
            }
        default:
            break
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navBarHeader?.updateAlpha(basedOn: scrollView.contentOffset.y)
        delegate?.handlePan(offsetY: scrollView.contentOffset.y)
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
    @objc func updateDailyBriefFromNotification(_ notification: NSNotification) {
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
        let cell: ImpactReadiness1 = tableView.dequeueCell(for: indexPath)
        cell.configure(viewModel: impactReadinessCellViewModel, tapLeft: { [weak self] in
                        self?.delegate?.moveToCell(item: 0)
                        }, tapRight: { [weak self] in
                            self?.delegate?.moveToCell(item: 2)
                    })
        cell.delegate = self
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
        return cell
    }

    func getDepartureBespokeFeastCell(_ tableView: UITableView,
                              _ indexPath: IndexPath,
                              _ departureBespokeFeastModel: DepartureBespokeFeastModel?) -> UITableViewCell {
        let cell: DepartureBespokeFeastCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: departureBespokeFeastModel)
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
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }

    func getWeatherCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ weatherModel: WeatherViewModel?) -> UITableViewCell {
        let cell: WeatherCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: weatherModel)
        cell.delegate = self
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
        tableView.registerDequeueable(DailyCheckinInsightsSHPICell.self)
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
    }

    func scrollToSection(at: Int) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: at), at: .middle, animated: true)
    }
}

// MARK: - DailyBriefViewControllerDelegate
extension DailyBriefViewController: DailyBriefViewControllerDelegate {
    func didChangeLocationPermission(granted: Bool) {
        if granted {
            AppDelegate.current.locationManager.startWeatherLocationMonitoring { (_) in }
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

    func didPressGotItSprint(sprint: QDMSprint) {
        interactor.didPressGotItSprint(sprint: sprint)
    }

    func saveAnswerValue(_ value: Int, from cell: UITableViewCell) {
        interactor.saveAnswerValue(value)
    }

    func saveTargetValue(value: Int?) {
        interactor.saveTargetValue(value: value)
    }

    // TODO Set correct pageName
    func videoAction(_ sender: Any, videoURL: URL?, contentItem: QDMContentItem?) {
        stream(videoURL: videoURL ?? URL(string: "")!, contentItem: contentItem)
    }
}

// MARK: - Navigation
extension DailyBriefViewController {
    func showCustomizeTarget() {
        interactor.customzieSleepQuestion { [weak self] (question) in
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

    func presentCopyRight(copyrightURL: String?) {
        router.presentCopyRight(copyrightURL: copyrightURL)
    }

    func openStrategyFromSprint(strategyID: Int?) {
        router.presentStrategyList(strategyID: strategyID)
    }

    func openToolFromSprint(toolID: Int?) {
        router.presentToolsItems(toolID: toolID)
    }

    func showSolveResults(solve: QDMSolve) {
        router.presentSolveResults(solve: solve)
    }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        router.presentPrepareResults(for: preparation)
    }

    func presentMyToBeVision() {
        router.showMyToBeVision()
    }

    @objc func openStrategy(sender: UITapGestureRecognizer) {
        router.presentStrategyList(strategyID: selectedStrategyID)
    }

    @objc func openTool(sender: UITapGestureRecognizer) {
        router.presentToolsItems(toolID: selectedToolID)
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
        interactor.customzieSleepQuestion { (question) in
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
