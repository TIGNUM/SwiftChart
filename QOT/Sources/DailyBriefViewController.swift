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
    typealias SectionData = [ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]
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
        setupTableView()
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

    func setupTableView() {
        let headerView = R.nib.newDailyBriefTableViewHeader(owner: self)
        headerView?.configure(tapLeft: { [weak self] in
            self?.delegate?.moveToCell(item: 0)
        }, tapRight: { [weak self] in
            self?.delegate?.moveToCell(item: 2)
        })
        tableView.tableHeaderView = headerView
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 160
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DailyBriefViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.rowViewSectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if interactor.bucketViewModelNew()?.at(index: section)?.model.title == nil {
            return 1
        } else {
            return interactor.bucketViewModelNew()?.at(index: section)?.elements.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = R.nib.newDailyBriefTableViewSectionHeader(owner: self)
        sectionHeader?.configure(title: interactor.bucketViewModelNew()?.at(index: section)?.model.title)

        return sectionHeader
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
        var cellModels: [BaseDailyBriefViewModel] = []

        guard indexPath.row < interactor.bucketViewModelNew()?.at(index: indexPath.section)?.elements.count ?? 0,
              let bucketModel = interactor.bucketViewModelNew()?.at(index: indexPath.section),
              let domainModel = bucketModel.elements[indexPath.row].domainModel else {
            switch indexPath.section {
            case 0:
                cell.configure(with: nil, skeletonMode: .getStarted)
            default:
                cell.configure(with: nil)
            }
            return cell
        }

        let bucketList = bucketModel.elements
        let bucketItem = bucketList[indexPath.row]

        switch domainModel.bucketName {
        case .GUIDE_TRACK?:
            if let guidedTrackViewModel = bucketItem as? GuidedTrackViewModel,
               let items = guidedTrackViewModel.items {
                for item in items {
                    let model = NewDailyBriefGetStartedModel.init(title: item.title,
                                                                  image: item.image,
                                                                  appLink: item.appLink,
                                                                  domainModel: guidedTrackViewModel.domainModel)
                    cellModels.append(model)
                }
            }
        case .DAILY_CHECK_IN_1?:
            if let impactReadinessCellViewModel = bucketItem as? ImpactReadinessCellViewModel {
                let numberOfLines = impactReadinessCellViewModel.readinessScore == -1 ? 0 : 2
                cellModels.append(NewDailyBriefStandardModel.init(caption: bucketItem.caption,
                                                                  title: bucketItem.title,
                                                                  body: bucketItem.body,
                                                                  image: bucketItem.image,
                                                                  attributedTitle: impactReadinessCellViewModel.attributedTitle,
                                                                  numberOfLinesForBody: numberOfLines,
                                                                  titleColor: bucketItem.titleColor,
                                                                  domainModel: bucketItem.domainModel))

            } else if (bucketItem as? ImpactReadinessScoreViewModel) != nil {
                cellModels.append(NewDailyBriefStandardModel.init(caption: bucketItem.caption,
                                                                  title: bucketItem.title,
                                                                  body: bucketItem.body,
                                                                  image: bucketItem.image,
                                                                  titleColor: bucketItem.titleColor,
                                                                  domainModel: bucketItem.domainModel))
            }
        case .LEADERS_WISDOM?:
            if let leadersWisdomViewModel = bucketItem as? LeaderWisdomCellViewModel {
                cellModels.append(NewDailyBriefStandardModel.init(caption: bucketItem.caption,
                                                                  title: bucketItem.title,
                                                                  body: bucketItem.body,
                                                                  image: bucketItem.image,
                                                                  CTAType: leadersWisdomViewModel.format,
                                                                  titleColor: bucketItem.titleColor,
                                                                  domainModel: bucketItem.domainModel))
            }
        case .SOLVE_REFLECTION?:
            if (bucketItem as? SolveReminderCellViewModel) != nil {
                return getSolveReminder(tableView, indexPath, bucketItem as? SolveReminderCellViewModel)
            } else if (bucketItem as? SolveReminderTableCellViewModel) != nil {
                return getSolveReminderTableCell(tableView, indexPath, bucketItem as? SolveReminderTableCellViewModel)
            }
            return UITableViewCell()
        case .SPRINT_CHALLENGE?:
            if let bucket = bucketItem as? SprintsCollectionViewModel,
               let items = bucket.items {
                for index in 0...items.count - 1 {
                    let item = items[index]
                    cellModels.append(NewDailyBriefStandardModel.init(caption: item.caption,
                                                                      title: item.title,
                                                                      body: item.body,
                                                                      image: item.image,
                                                                      enabled: index <= item.sprint.currentDay,
                                                                      titleColor: bucketItem.titleColor,
                                                                      domainModel: item.domainModel))
                }
            }
//        case .TEAM_NEWS_FEED?:
//            return getTeamNewsFeed(tableView, indexPath, bucketItem as? TeamNewsFeedDailyBriefViewModel)
        case .TEAM_TOBEVISION_GENERATOR_POLL?:
            let numberOfLines = 6
            cellModels.append(NewDailyBriefStandardModel.init(caption: bucketItem.caption,
                                                            title: bucketItem.title,
                                                            body: bucketItem.body,
                                                            image: bucketItem.image,
                                                            numberOfLinesForBody: numberOfLines,
                                                            titleColor: bucketItem.titleColor,
                                                            domainModel: bucketItem.domainModel))

        case .TEAM_TOBEVISION_TRACKER_POLL?:
            if (bucketItem as? RateOpenModel) != nil,
               let rateViewModel = bucketItem as? RateOpenModel {
                return getOpenRateCell(tableView, indexPath, rateViewModel)
            } else if (bucketItem as? RatingFeedbackModel ) != nil,
                      let feedbackModel = bucketItem as? RatingFeedbackModel {
                return getRatingFeedbackCell(tableView, indexPath, feedbackModel)
            }
            return UITableViewCell()
        case .WEATHER?:
            return getWeatherCell(tableView, indexPath, bucketItem as? WeatherViewModel)
        default:
            cellModels.append(NewDailyBriefStandardModel.init(caption: bucketItem.caption,
                                                                title: bucketItem.title,
                                                                body: bucketItem.body,
                                                                image: bucketItem.image,
                                                                titleColor: bucketItem.titleColor,
                                                                domainModel: bucketItem.domainModel))
        }

        cell.configure(with: cellModels)
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
    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<DailyBriefSectionModel, BaseDailyBriefViewModel>]>) {
        tableView.reload(using: differenceList, with: .fade) { data in
            self.interactor.updateViewModelListNew(data)
        }
    }

    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.registerDequeueable(SolveReminderCell.self)
        tableView.registerDequeueable(SolveTableViewCell.self)
        tableView.registerDequeueable(WeatherCell.self)
        tableView.registerDequeueable(TeamToBeVisionCell.self)
        tableView.registerDequeueable(TeamVisionSuggestionCell.self)
        tableView.registerDequeueable(TeamInvitationCell.self)
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

    func reloadSprintCell(cell: UITableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
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
            self?.router.showTeamTBV(team)
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

    func presentStrategyList(strategyID: Int?) {
        if let contentId = strategyID {
            router.presentContent(contentId)
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
                        self?.router.presentDailyBriefDetailsScreen(model: impactReadinessScoreCellViewModel, transitioningDelegate: self?.transition)
                    }
                }
                return
            }
            if impactReadinessCellViewModel.readinessScore == -1 && !impactReadinessCellViewModel.isCalculating {
                showDailyCheckInQuestions()
            } else {
                performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                    self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel, transitioningDelegate: self?.transition)
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
                    self?.router.presentDailyBriefDetailsScreen(model: leaderWisdomCellModel, transitioningDelegate: self?.transition)
                }
            }
        case .ME_AT_MY_BEST:
            if !(dailyBriefCellViewModel.domainModel?.toBeVisionTrack?.sentence?.isEmpty ?? true) {
                performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                    self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel, transitioningDelegate: self?.transition)
                }
            } else {
                router.showTBVGenerator()
            }
        case .FROM_TIGNUM:
            guard let fromTignumCellModel = dailyBriefCellViewModel as? FromTignumCellViewModel else { return }
            fromTignumCellModel.link?.launch()
        case .TEAM_TO_BE_VISION:
            guard let viewModel = bucketItem as? TeamToBeVisionCellViewModel else { break }
            guard let team = viewModel.team else { break }
            router.showTeamTBV(team)
        case .TEAM_INVITATION:
            presentTeamPendingInvites()
        case .TEAM_TOBEVISION_GENERATOR_POLL:
            guard let pollModel = dailyBriefCellViewModel as? PollOpenModel else { return }
            guard let team = pollModel.team else { return }
            router.showExplanation(team, type: .tbvPollUser)
        case .SPRINT_CHALLENGE:
            guard let sprintCollectionCellModel = dailyBriefCellViewModel as? SprintsCollectionViewModel,
                  let sprintCellModel = sprintCollectionCellModel.items?[indexPath.item] else { return }
            performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                self?.router.presentDailyBriefDetailsScreen(model: sprintCellModel, transitioningDelegate: self?.transition)
            }
        default:
            performExpandAnimation(for: sender, withInsideIndexPath: indexPath, model: dailyBriefCellViewModel) { [weak self] in
                self?.router.presentDailyBriefDetailsScreen(model: dailyBriefCellViewModel, transitioningDelegate: self?.transition)
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
