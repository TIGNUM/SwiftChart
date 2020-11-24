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
    private var transition: CardTransition?

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

    override var statusBarAnimatableConfig: StatusBarAnimatableConfig {
        return StatusBarAnimatableConfig(prefersHidden: false,
                                         animation: .slide)
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
        let cell: NewBaseDailyBriefCell = tableView.dequeueCell(for: indexPath)
        var standardModel: BaseDailyBriefViewModel?

        guard let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section),
                let domainModel = bucketModel.elements[indexPath.row].domainModel else {
            cell.configure(with: nil)
            return cell
        }

        let bucketList = bucketModel.elements
        let bucketItem = bucketList[indexPath.row]

        switch domainModel.bucketName {
        case .DAILY_CHECK_IN_1?:
            if (bucketItem as? ImpactReadinessCellViewModel) != nil,
                let impactReadinessCellViewModel = bucketItem as? ImpactReadinessCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: impactReadinessCellViewModel.title,
                                                                title: ImpactReadinessCellViewModel.createAttributedImpactReadinessTitle(for: impactReadinessCellViewModel.readinessScore,
                                                                impactReadinessNoDataTitle: impactReadinessCellViewModel.title),
                                                                body: impactReadinessCellViewModel.feedback,
                                                                image: impactReadinessCellViewModel.dailyCheckImageURL?.absoluteString ?? "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: impactReadinessCellViewModel.domainModel)
            } else if (bucketItem as? ImpactReadinessScoreViewModel) != nil,
                let impactReadinessScoreViewModel = bucketItem as? ImpactReadinessScoreViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_title),
                                                                title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_subtitle)),
                                                                body: AppTextService.get(.daily_brief_section_impact_readiness_section_5_day_rolling_body),
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: impactReadinessScoreViewModel.domainModel)
            }
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
            if let exploreViewModel = bucketItem as? ExploreCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: exploreViewModel.bucketTitle,
                                                                title: NSAttributedString.init(string: exploreViewModel.title ?? ""),
                                                                body: exploreViewModel.duration,
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: exploreViewModel.domainModel)
            }
        case .SPRINT_CHALLENGE?:
            return getSprints(tableView, indexPath, bucketItem as? SprintChallengeViewModel)
        case .ME_AT_MY_BEST?:
            if bucketItem.domainModel?.toBeVisionTrack?.sentence?.isEmpty != false,
               let meAtMyBestCellEmptyViewModel = bucketItem as? MeAtMyBestCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: meAtMyBestCellEmptyViewModel.title,
                                                                title: NSAttributedString.init(string: meAtMyBestCellEmptyViewModel.buttonText ?? ""),
                                                                body: meAtMyBestCellEmptyViewModel.intro ?? "",
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: meAtMyBestCellEmptyViewModel.domainModel)
            } else if let meAtMyBestViewModel = bucketItem as? MeAtMyBestCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: meAtMyBestViewModel.title,
                                                                title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_my_best_card_title)),
                                                                body: meAtMyBestViewModel.tbvStatement,
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: meAtMyBestViewModel.domainModel)
            }
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
            if let whatsHotViewModel = bucketItem as? WhatsHotLatestCellViewModel {
                let publishDate = whatsHotViewModel.publisheDate
                let durationString = whatsHotViewModel.timeToRead
                let dateAndDurationText = DateFormatter.whatsHotBucket.string(from: publishDate) + " | " + durationString

                standardModel = NewDailyBriefStandardModel.init(caption: AppTextService.get(.daily_brief_section_whats_hot_title),
                                                                    title: NSAttributedString.init(string: whatsHotViewModel.title),
                                                                     body: dateAndDurationText,
                                                                     image: whatsHotViewModel.image?.absoluteString ?? "",
                                                                     domainModel: whatsHotViewModel.domainModel)
            }
        case .THOUGHTS_TO_PONDER?:
            return getThoughtsCell(tableView, indexPath, bucketItem as? ThoughtsCellViewModel)
        case .GOOD_TO_KNOW?:
            return getGoodToKnowCell(tableView, indexPath, bucketItem as? GoodToKnowCellViewModel)
        case .FROM_MY_COACH?:
            if let fromMyCoachViewModel = bucketItem as? FromMyCoachCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: "Message from my TIGNUM coach",
                                                                title: NSAttributedString.init(string: fromMyCoachViewModel.detail.title),
                                                                body: fromMyCoachViewModel.messages.first?.text,
                                                                image: fromMyCoachViewModel.detail.imageUrl?.absoluteString ?? "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: fromMyCoachViewModel.domainModel)
            }
        case .FROM_TIGNUM?:
            return getFromTignumMessageCell(tableView, indexPath, bucketItem as? FromTignumCellViewModel)
        case .BESPOKE?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .DEPARTURE_INFO?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .LEADERS_WISDOM?:
            if let leadersWisdomViewModel = bucketItem as? LeaderWisdomCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: leadersWisdomViewModel.title,
                                                                title: NSAttributedString.init(string: leadersWisdomViewModel.subtitle ?? ""),
                                                                body: leadersWisdomViewModel.description ?? "",
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                CTAType: leadersWisdomViewModel.format,
                                                                domainModel: leadersWisdomViewModel.domainModel)
            }
        case .EXPERT_THOUGHTS?:
            if let expertThoughtsViewModel = bucketItem as? ExpertThoughtsCellViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: expertThoughtsViewModel.title,
                                                                     title: NSAttributedString.init(string: expertThoughtsViewModel.description ?? ""),
                                                                     body: expertThoughtsViewModel.name,
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     domainModel: expertThoughtsViewModel.domainModel)
            }
        case .FEAST_OF_YOUR_EYES?:
            return getDepartureBespokeFeastCell(tableView, indexPath, bucketItem as? DepartureBespokeFeastModel)
        case .MY_PEAK_PERFORMANCE?:
            if let peakPerformanceViewModel = bucketItem as? PeakPerformanceViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: peakPerformanceViewModel.title,
                                                                title: NSAttributedString.init(string: peakPerformanceViewModel.eventTitle ?? ""),
                                                                body: peakPerformanceViewModel.contentSubtitle,
                                                                image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                domainModel: peakPerformanceViewModel.domainModel)
            }
        case .GUIDE_TRACK?:
            let showDivider = indexPath.row == bucketList.count - 1
            return getGuidedTrack(tableView, indexPath, showDivider, bucketItem as? GuidedTrackViewModel)
        case .WEATHER?:
            return getWeatherCell(tableView, indexPath, bucketItem as? WeatherViewModel)
        case .MINDSET_SHIFTER?:
            if let mindsetShifterViewModel = bucketItem as? MindsetShifterViewModel {
                standardModel = NewDailyBriefStandardModel.init(caption: mindsetShifterViewModel.title,
                                                                    title: NSAttributedString.init(string: AppTextService.get(.daily_brief_section_my_best_card_title)),
                                                                    body: mindsetShifterViewModel.subtitle,
                                                                     image: "https://homepages.cae.wisc.edu/~ece533/images/boy.bmp",
                                                                     domainModel: mindsetShifterViewModel.domainModel)
            }
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

        if let model = standardModel {
            cell.configure(with: [model])
        }
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section)
        let bucketList = bucketModel?.elements
        let bucketItem = bucketList?[indexPath.row]

        guard let bucketName = bucketItem?.domainModel?.bucketName else { return }

        switch bucketName {
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
    func getRandomQuestionCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ questionCellViewModel: QuestionCellViewModel?) -> UITableViewCell {
        let cell: QuestionCell = tableView.dequeueCell(for: indexPath)
        cell.clickableLinkDelegate = self
        cell.configure(with: questionCellViewModel)
        return cell
    }

    func getThoughtsCell(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ thoughtsCellViewModel: ThoughtsCellViewModel?) -> UITableViewCell {
        let cell: ThoughtsCell = tableView.dequeueCell(for: indexPath)
        cell.clickableLinkDelegate = self
        cell.configure(with: thoughtsCellViewModel)

        return cell
    }

    func getGoodToKnowCell(_ tableView: UITableView,
                           _ indexPath: IndexPath,
                           _ goodToKnowCellViewModel: GoodToKnowCellViewModel?) -> UITableViewCell {
        let cell: GoodToKnowCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: goodToKnowCellViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getFromTignumMessageCell(_ tableView: UITableView,
                                  _ indexPath: IndexPath,
                                  _ fromTignumMessageViewModel: FromTignumCellViewModel?) -> UITableViewCell {
        let cell: FromTignumCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: fromTignumMessageViewModel)
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

    func getAboutMeCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ aboutMeViewModel: AboutMeViewModel?) -> UITableViewCell {
        let cell: AboutMeCell = tableView.dequeueCell(for: indexPath)
        cell.clickableLinkDelegate = self
        cell.configure(with: aboutMeViewModel)
        return cell
    }

    func getSprints(_ tableView: UITableView,
                    _ indexPath: IndexPath,
                    _ sprintChallengeModel: SprintChallengeViewModel?) -> UITableViewCell {
        let cell: SprintChallengeCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: sprintChallengeModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getSolveReminder(_ tableView: UITableView,
                          _ indexPath: IndexPath,
                          _ solveReminderViewModel: SolveReminderCellViewModel?) -> UITableViewCell {
        let cell: SolveReminderCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: solveReminderViewModel)
        cell.clickableLinkDelegate = self
        cell.delegate = self
        return cell
    }

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

    func getlevel5(_ tableView: UITableView,
                   _ indexPath: IndexPath,
                   _ level5ViewModel: Level5ViewModel?) -> UITableViewCell {
        let cell: Level5Cell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: level5ViewModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getDailyCheckinInsightsSHPICell(_ tableView: UITableView,
                                         _ indexPath: IndexPath,
                                         _ dailyCheck2SHPIModel: DailyCheck2SHPIModel?) -> UITableViewCell {
        let cell: DailyCheckinSHPICell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: dailyCheck2SHPIModel)
        cell.clickableLinkDelegate = self
        return cell
    }

    func getDailyCheckIn2TBVCell(_ tableView: UITableView,
                                 _ indexPath: IndexPath,
                                 _ dailyCheckIn2TBVModel: DailyCheckIn2TBVModel?) -> UITableViewCell {
        let cell: DailyCheckinInsightsTBVCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: dailyCheckIn2TBVModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

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

    func getWeatherCell(_ tableView: UITableView,
                        _ indexPath: IndexPath,
                        _ weatherModel: WeatherViewModel?) -> UITableViewCell {
        let cell: WeatherCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: weatherModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getTeamToBeVisionCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ teamVisionModel: TeamToBeVisionCellViewModel?) -> UITableViewCell {
        let cell: TeamToBeVisionCell = tableView.dequeueCell(for: indexPath)
        cell.configure(with: teamVisionModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getTeamVisionSuggestionCell(_ tableView: UITableView,
                                     _ indexPath: IndexPath,
                                     _ teamVisionSuggestionModel: TeamVisionSuggestionModel?) -> UITableViewCell {
        let cell: TeamVisionSuggestionCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: teamVisionSuggestionModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getTeamInvitationCell(_ tableView: UITableView,
                               _ indexPath: IndexPath,
                               _ teamInvitationModel: TeamInvitationModel?) -> UITableViewCell {
        let cell: TeamInvitationCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: teamInvitationModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

    func getOpenPollCell(_ tableView: UITableView,
                         _ indexPath: IndexPath,
                         _ pollOpenModel: PollOpenModel?) -> UITableViewCell {
        let cell: PollOpenCell = tableView.dequeueCell(for: indexPath)
        cell.configure(model: pollOpenModel)
        cell.delegate = self
        cell.clickableLinkDelegate = self
        return cell
    }

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
        tableView.registerDequeueable(QuestionCell.self)
        tableView.registerDequeueable(ThoughtsCell.self)
        tableView.registerDequeueable(GoodToKnowCell.self)
        tableView.registerDequeueable(FromTignumCell.self)
        tableView.registerDequeueable(DailyCheckinInsightsTBVCell.self)
        tableView.registerDequeueable(DailyCheckinSHPICell.self)
        tableView.registerDequeueable(DailyCheckinInsightsPeakPerformanceCell.self)
        tableView.registerDequeueable(AboutMeCell.self)
        tableView.registerDequeueable(Level5Cell.self)
        tableView.registerDequeueable(FromMyCoachCell.self)
        tableView.registerDequeueable(SolveReminderCell.self)
        tableView.registerDequeueable(SprintChallengeCell.self)
        tableView.registerDequeueable(GuidedTrackSectionCell.self)
        tableView.registerDequeueable(GuidedTrackRowCell.self)
        tableView.registerDequeueable(SolveTableViewCell.self)
        tableView.registerDequeueable(WeatherCell.self)
        tableView.registerDequeueable(DepartureBespokeFeastCell.self)
        tableView.registerDequeueable(TeamToBeVisionCell.self)
        tableView.registerDequeueable(TeamVisionSuggestionCell.self)
        tableView.registerDequeueable(TeamInvitationCell.self)
//        tableView.registerDequeueable(DailyBriefTeamNewsFeedHeaderCell.self)
//        tableView.registerDequeueable(DailyBriefTeamNewsFeedFooterCell.self)
//        tableView.registerDequeueable(ArticleBookmarkTableViewCell.self)
//        tableView.registerDequeueable(VideoBookmarkTableViewCell.self)
//        tableView.registerDequeueable(AudioBookmarkTableViewCell.self)
//        tableView.registerDequeueable(NoteTableViewCell.self)
//        tableView.registerDequeueable(DownloadTableViewCell.self)
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

    func showRateHistory(for team: QDMTeam) {
        router.showTracker(for: team)
    }
}

// MARK: - Navigation
extension DailyBriefViewController {
    func showDailyCheckInQuestions() {
        router.presentDailyCheckInQuestions()
    }

    func openGuidedTrackAppLink(_ appLink: QDMAppLink?) {
        router.launchAppLinkGuidedTrack(appLink)
    }

    func displayCoachPreparationScreen() {
        router.presentCoachPreparation()
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
            controller.transitioningDelegate = transition

            // If `modalPresentationStyle` is not `.fullScreen`, this should be set to true to make status bar depends on presented vc.
            controller.modalPresentationCapturesStatusBarAppearance = true
            controller.modalPresentationStyle = .custom
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

extension DailyBriefViewController: NewBaseDailyBriefCellProtocol {
    func didTapOnCollectionViewCell(at indexPath: IndexPath, sender: NewBaseDailyBriefCell) {
        guard let indexPathOfTableViewCell = tableView.indexPath(for: sender) else {
            return
        }

        let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPathOfTableViewCell.section)
        let bucketList = bucketModel?.elements
        let bucketItem = bucketList?[indexPathOfTableViewCell.row]

        guard let bucketName = bucketItem?.domainModel?.bucketName,
              let dailyBriefCellViewModel = bucketItem else { return }

        switch bucketName {
        case .DAILY_CHECK_IN_1:
            guard let impactReadinessCellViewModel = dailyBriefCellViewModel as? ImpactReadinessCellViewModel else {
                if let impactReadinessScoreCellViewModel = dailyBriefCellViewModel as? ImpactReadinessScoreViewModel {
                    performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                        self?.router.presentDailyBriefDetailsScreen(model: impactReadinessScoreCellViewModel)
                    }
                }
                return
            }
            if impactReadinessCellViewModel.readinessScore == -1 {
                showDailyCheckInQuestions()
            } else {
                performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                    self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel)
                }
            }
        case .EXPLORE:
            guard let exploreCellModel = dailyBriefCellViewModel as? ExploreCellViewModel else { return }
            presentStrategyList(strategyID: exploreCellModel.remoteID)
        case .LATEST_WHATS_HOT:
             didSelectRow(at: indexPath)
             guard let whatsHotArticleId = bucketItem?.domainModel?.contentCollectionIds?.first else { break }
             router.presentContent(whatsHotArticleId)
        case .LEADERS_WISDOM:
            guard let leaderWisdomCellModel = dailyBriefCellViewModel as? LeaderWisdomCellViewModel else { return }
            if leaderWisdomCellModel.format == .audio {
                let media = MediaPlayerModel(title: leaderWisdomCellModel.videoTitle?.uppercased() ?? "",
                                             subtitle: "",
                                             url: leaderWisdomCellModel.videoThumbnail,
                                             totalDuration: leaderWisdomCellModel.audioDuration ?? 0,
                                             progress: 0,
                                             currentTime: 0,
                                             mediaRemoteId: leaderWisdomCellModel.remoteID ?? 0)
                NotificationCenter.default.post(name: .playPauseAudio, object: media)
            } else if leaderWisdomCellModel.format == .video {
                stream(videoURL: leaderWisdomCellModel.videoThumbnail ?? URL(string: "")!, contentItem: nil)
            } else {
                performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                    self?.router.presentDailyBriefDetailsScreen(model: leaderWisdomCellModel)
                }
            }
        case .ME_AT_MY_BEST:
            if !(dailyBriefCellViewModel.domainModel?.toBeVisionTrack?.sentence?.isEmpty ?? true) {
                performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                    self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel)
                }
            } else {
                router.showTBV()
            }
        default:
            performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel)
            }
        }
    }

    func performExpandAnimation(for cell: NewBaseDailyBriefCell, withInsideIndexPath: IndexPath, model: BaseDailyBriefViewModel, completionHandler: (@escaping () -> Void)) {

        guard let collectionViewCell = cell.collectionView.cellForItem(at: withInsideIndexPath) as? NewDailyStandardBriefCollectionViewCell else { return }
        collectionViewCell.freezeAnimations()

        guard let currentCellFrame = collectionViewCell.layer.presentation()?.frame else { return }
        guard let cardPresentationFrameOnScreen = collectionViewCell.superview?.convert(currentCellFrame, to: self.view) else { return }

        let cardFrameWithoutTransform = { () -> CGRect in
            let center = collectionViewCell.center
            let size = collectionViewCell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return collectionViewCell.superview?.convert(r, to: self.view) ?? CGRect.zero
        }()

        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: collectionViewCell)
        transition = CardTransition(params: params)

        completionHandler()

        collectionViewCell.unfreezeAnimations()
    }
}
