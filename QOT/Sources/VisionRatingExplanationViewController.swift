//
//  VisionRatingExplanationViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationViewController: BaseViewController {

    // MARK: - Properties
    var interactor: VisionRatingExplanationInteractorInterface!
    private lazy var router = VisionRatingExplanationRouter(viewController: self)
    @IBOutlet private weak var checkMarkView: UIView!
    @IBOutlet private weak var checkmarkLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var syncingLabel: UILabel!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var playIconBackgroundView: UIView!
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var loadingDotsContainer: UIView?
    private var downSyncObserver: NSObjectProtocol?
    private var skeletonManager = SkeletonManager()
    private var videoID: Int?
    private var rightBarButtonTitle = ""
    private var rightBarButtonAction = #selector(startRating)
    private var loadingDots: DotsLoadingView?

    // MARK: - Init
    init(configure: Configurator<VisionRatingExplanationViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation(bottomNavigationLeftBarItems(), bottomNavigationRightBarItems())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @IBAction func buttonChecked(_ sender: Any) {
        checkButton.isSelected.toggle()
        checkButton.backgroundColor = checkButton.isSelected ? .accent70 : .clear
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem] {
        if interactor.team?.thisUserIsOwner == true {
            return getRightBarButtonItems()
        }
        fetchMemberPoll()
        return []
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem] {
        return getLeftBarButtonItems()
    }
}

// MARK: - Actions
extension VisionRatingExplanationViewController {
    @objc func startRating() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        guard let teamID = interactor.team?.remoteID else { return }
        trackUserEvent(.OPEN, value: teamID, valueType: .TEAM_TO_BE_VISION_RATING, action: .TAP)
        var tmpPoll: QDMTeamToBeVisionTrackerPoll?
        var tmpTeam: QDMTeam?

        interactor.startTeamTrackerPoll(sendPushNotification: checkButton.isSelected) { (poll, team) in
            tmpPoll = poll
            tmpTeam = team
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.router.showRateScreen(trackerPoll: tmpPoll,
                                        team: tmpTeam,
                                        delegate: self,
                                        showBanner: self?.checkButton.isSelected,
                                        showModal: true)
            self?.updateBottomNavigation([], [])
            self?.removeObserver()
        }
    }

    @objc func startTeamTBVGenerator() {
        guard let team = interactor.team else { return }
        trackUserEvent(.OPEN, value: team.remoteID, valueType: .TEAM_TBV_GENERATOR, action: .TAP)
        interactor.startTeamTBVPoll(sendPushNotification: self.checkButton.isSelected) { [weak self] (poll) in
            self?.router.showTeamTBVGenerator(poll: poll, team: team, showBanner: self?.checkButton.isSelected)
            self?.updateBottomNavigation([], [])
            self?.removeObserver()
        }
    }

    @objc func createTeam() {
        router.presentEditTeam(.create, team: nil)
        updateBottomNavigation([], [])
        removeObserver()
    }

    @objc func videoTapped(_ sender: UITapGestureRecognizer) {
        if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(videoID ?? 0)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
        }
    }

    func setupButtons() {
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.accent.cgColor
        checkButton.corner(radius: 2)
    }
}

// MARK: - VisionRatingExplanationViewControllerInterface
extension VisionRatingExplanationViewController: VisionRatingExplanationViewControllerInterface {
    func setupView(type: Explanation.Types) {
        playIconBackgroundView.circle()
        ThemeText.ratingExplanationText.apply(AppTextService.get(.my_x_team_tbv_section_feature_explanation_checkmark),
                                              to: checkmarkLabel)
        updateBottomNavigation(bottomNavigationLeftBarItems(), bottomNavigationRightBarItems())
        switch type {
        case .ratingOwner, .tbvPollOwner:
            checkMarkView.isHidden = false
        default:
            checkMarkView.isHidden = true
        }
    }

    func setupLabels(title: String, text: String, videoTitle: String) {
        ThemeText.ratingExplanationTitle.apply(title.uppercased(), to: titleLabel)
        let adaptedText = text.replacingOccurrences(of: "${TEAM_NAME}", with: (interactor.team?.name ?? "").uppercased())
        ThemeText.ratingExplanationText.apply(adaptedText, to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(videoTitle, to: videoTitleLabel)

    }

    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String, remoteID: Int) {
        videoView.isHidden = videoURL == nil
        self.videoID = remoteID
        videoImageView.setImage(url: thumbNailURL, skeletonManager: skeletonManager) { (_) in /* */}
        videoDescriptionLabel.text = duration
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(self.videoTapped(_:)))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(videoTap)
    }

    func setupRightBarButtonItem(title: String, type: Explanation.Types) {
        rightBarButtonTitle = title
        switch type {
        case .ratingUser,
             .ratingOwner: rightBarButtonAction = #selector(startRating)
        case .tbvPollOwner,
             .tbvPollUser: rightBarButtonAction = #selector(startTeamTBVGenerator)
        case .createTeam: rightBarButtonAction = #selector(createTeam)
        }
    }
}

extension VisionRatingExplanationViewController: TBVRateDelegate {
    func doneAction() {

    }
}

private extension VisionRatingExplanationViewController {
    func getRightBarButtonItems() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: rightBarButtonTitle,
                                     buttonWidth: .Save,
                                     action: rightBarButtonAction,
                                     backgroundColor: .clear,
                                     borderColor: .white40)]
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        return [dismissNavigationItemBlack(action: #selector(didTapDismissButton))]
    }

    func addNotificationObservers() {
        downSyncObserver = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                                  object: nil,
                                                                  queue: .main) { [weak self] notification in
            if self?.downSyncObserver != nil {
                self?.didFinishDownSynchronization(notification)
            }
        }
    }

    func removeObserver() {
        if let downSyncObserver = downSyncObserver {
            NotificationCenter.default.removeObserver(downSyncObserver)
            self.downSyncObserver = nil
        }
    }

    @objc func didFinishDownSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext,
              syncResult.syncRequestType == .DOWN_SYNC,
              syncResult.hasUpdatedContent,
              downSyncObserver != nil else { return }
        if interactor.type == .ratingUser && syncResult.dataType == .TEAM_TO_BE_VISION_TRACKER_POLL {
            hideSyncAnimationAndShowStartButton()
        }
        if interactor.type == .tbvPollUser && syncResult.dataType == .TEAM_TO_BE_VISION_GENERATOR_POLL {
            hideSyncAnimationAndShowStartButton()
        }
    }

    func hideSyncAnimationAndShowStartButton() {
        hideLoadingDots()
        updateBottomNavigation(getLeftBarButtonItems(), getRightBarButtonItems())
        removeObserver()
    }

    func showLoadingDots() {
        guard let loadingDotsContainer = loadingDotsContainer, loadingDots == nil else { return }
        let dots = DotsLoadingView(with: CGRect(x: 0, y: 0, width: .LoadingDots, height: .LoadingDots),
                                   parentView: loadingDotsContainer,
                                   dotsColor: .lightGrey)
        loadingDots = dots
        loadingDots?.animate()
        syncingLabel.isHidden = false
    }

    func hideLoadingDots() {
        loadingDots?.stopAnimation()
        syncingLabel.isHidden = true
    }

    func fetchMemberPoll() {
        if interactor.type == .ratingUser {
            showLoadingDots()
            interactor.getOpenTeamTrackerPoll { [weak self] (trackerPoll) in
                if trackerPoll != nil {
                    self?.hideSyncAnimationAndShowStartButton()
                } else {
                    self?.addNotificationObservers()
                }

            }
        }

        if interactor.type == .tbvPollUser {
            showLoadingDots()
            interactor.getOpenTeamGeneratorPoll { [weak self] (generatorPoll) in
                if generatorPoll != nil {
                    self?.hideSyncAnimationAndShowStartButton()
                } else {
                    self?.addNotificationObservers()
                }
            }
        }
    }
}
