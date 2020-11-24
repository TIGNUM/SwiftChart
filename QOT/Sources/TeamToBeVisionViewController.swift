//
//  TeamToBeVisionViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionViewController: BaseViewController, ScreenZLevel2 {

    // MARK: - Properties
    var interactor: TeamToBeVisionInteractorInterface!
    private lazy var router = TeamToBeVisionRouter(viewController: self)
    @IBOutlet private weak var teamNullStateView: TeamToBeVisionNullStateView!
    @IBOutlet private weak var navigationBarView: ToBeVisionSelectionBar!
    @IBOutlet private weak var navigationContainer: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var navigationBarViewTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet private weak var teamNullStateImageView: UIImageView!
    @IBOutlet private weak var toBeVisionSelectionBar: ToBeVisionSelectionBar!
    @IBOutlet private weak var pollButton: RoundedButton!
    @IBOutlet private weak var trackerButton: RoundedButton!
    @IBOutlet private weak var trendsLabel: UILabel!
    @IBOutlet private weak var trendsButton: UIButton!
    @IBOutlet private weak var trendsBarView: UIView!
    @IBOutlet private weak var pollBatchLabel: UILabel!
    @IBOutlet private weak var trackerBatchLabel: UILabel!

    @IBOutlet private weak var lastModifiedLabel: UILabel!
    private var didShowNullStateView = false
    private var shouldShowCreate = false
    private let containerViewSize: CGFloat = 232.0
    private let containerViewRatio: CGFloat = 1.2
    private let lowerBoundAlpha: CGFloat = 0.6
    private let upperBoundAlpha: CGFloat = 1.1
    private var lastContentOffset: CGFloat = 0
    private var tempImage: UIImage?
    private var tempTeamImage: UIImage?
    private var tempImageURL: URL?
    private var tempTeamImageURL: URL?
    private var imagePickerController: ImagePickerController!
    private lazy var skeletonManager = SkeletonManager()

    // MARK: - Init
    init(configure: Configurator<TeamToBeVisionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        userImageView.gradientBackground(top: true)
        userImageView.gradientBackground(top: false)
        showNullState(with: "", message: "", header: "")
        showSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
        interactor.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if shouldShowCreate {
            let button = RoundedButton(title: nil, target: self, action: #selector(showCreateAlert))
            ThemableButton.myPlans.apply(button, title: interactor.nullStateCTA)
            return [button.barButton]
        }
        return []
    }
}

// MARK: - ToBeVisionSelectionBarProtocol
extension TeamToBeVisionViewController: ToBeVisionSelectionBarProtocol {
    func didTapEditItem() {
        trackUserEvent(.EDIT, value: interactor.team.remoteID, valueType: .EDIT_TEAM_TBV, action: .TAP)
        interactor.showEditVision(isFromNullState: false)
    }

    func didTapCameraItem() {
        trackUserEvent(.EDIT, value: interactor.team.remoteID, valueType: .PICK_TEAM_TBV_IMAGE, action: .TAP)
        imagePickerController.show(in: self, deletable: (tempTeamImageURL != nil || tempTeamImage != nil))
        imagePickerController.delegate = self
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }

    func didTapShareItem() {
        didShare()
    }

    func isShareBlocked(_ completion: @escaping (Bool) -> Void) {
        interactor.isShareBlocked(completion)
    }

    func isEditBlocked(_ completion: @escaping (Bool) -> Void) {
        interactor.isEditBlocked(completion)
    }
}

// MARK: - Private
private extension TeamToBeVisionViewController {
    func saveTeamToBeVisionImageAndData() {
        interactor.saveToBeVision(image: tempTeamImage)
    }

    func removeGradients() {
        userImageView.removeSubViews()
        teamNullStateView.removeSubViews()
    }

    func addGradients() {
        userImageView.gradientBackground(top: true)
        userImageView.gradientBackground(top: false)
    }

    func hideNavigationBarView() {
        navigationBarViewTopMarginConstraint.constant = -100
    }

    func showNavigationBarView() {
        navigationBarViewTopMarginConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func showSkeleton() {
        skeletonManager.addTitle(headerLabel)
        skeletonManager.addSubtitle(toBeVisionLabel)
        skeletonManager.addOtherView(teamNullStateImageView)
        skeletonManager.addOtherView(userImageView)
        skeletonManager.addTitle(teamNullStateView.headerLabel)
        skeletonManager.addSubtitle(teamNullStateView.detailLabel)
        skeletonManager.addSubtitle(teamNullStateView.toBeVisionLabel)
    }

    func addBatchToPollButton() {
        shouldShowCreate = false
        refreshBottomNavigationItems()
        pollButton.isHidden = false
        pollBatchLabel.isHidden = false
        pollBatchLabel.circle()
    }

    func addBatchToTrackerButton() {
        shouldShowCreate = false
        refreshBottomNavigationItems()
        trackerButton.isHidden = false
        trackerBatchLabel.isHidden = false
        trackerBatchLabel.circle()
    }

    func removeBatchTrackerButton() {
        trackerBatchLabel.isHidden = true
    }

    func removeBatchPollButton() {
        pollBatchLabel.isHidden = true
    }
}

// MARK: - Actions
private extension TeamToBeVisionViewController {
    @IBAction func didTapOpenTrends() {
        router.showTracker(for: interactor.team)
    }

    @IBAction func didTapPollButton(_ sender: RoundedButton) {
        trackUserEvent(.OPEN,
                       value: interactor.team.remoteID,
                       valueType: .TEAM_TBV_POLL_BUTTON_TAP,
                       action: .TAP)
        switch sender.ctaAction {
        case .showAdminOptionsGenerator:
            router.showTeamAdmin(type: .voting,
                                 team: interactor.team,
                                 showBanner: false)

        case .showAdminOptionsRating:
            router.showTeamAdmin(type: .rating,
                                 team: interactor.team,
                                 showBanner: false)

        case .showBanner(let message):
            router.showBanner(message: message)

        case .showIntroGenerator:
            router.showTeamTBVPollEXplanation(interactor.team)

        case .showIntroRating:
            router.showTeamRatingExplanation(interactor.team)

        case .showRating:
            interactor.ratingTapped()

        case .showGenerator:
            router.showTeamTBVGenerator(poll: interactor.teamVisionPoll,
                                        team: interactor.team,
                                        showBanner: false)

        case .undefined,
             .none: break
        }
    }

    @objc func showCreateAlert(_ sender: Any) {
        let openTeamPollTitle = AppTextService.get(.my_x_team_tbv_section_alert_right_button)
        let openTeamPoll = QOTAlertAction(title: openTeamPollTitle) { [weak self] (_) in
            self?.trackUserEvent(.OPEN, valueType: .TEAM_TBV_GENERATOR, action: .TAP)
            if let pollButton = self?.pollButton {
                self?.didTapPollButton(pollButton)
            }
        }
        let addTitle = AppTextService.get(.my_x_team_tbv_section_alert_left_button)
        let add = QOTAlertAction(title: addTitle) { [weak self] (_) in
            self?.trackUserEvent(.OPEN, valueType: .WRITE_TEAM_TBV, action: .TAP)
            self?.interactor.showEditVision(isFromNullState: true)
        }

        QOTAlert.show(title: interactor.nullStateCTA?.uppercased(),
                      message: AppTextService.get(.my_x_team_tbv_section_alert_message),
                      bottomItems: [add, openTeamPoll])
    }

    func setupContent(_ teamVision: QDMTeamToBeVision?) {
        var headline = teamVision?.headline
        if headline?.isEmpty != false {
            headline = interactor.teamNullStateTitle
        }
        ThemeText.tbvVisionHeader.apply(headline, to: headerLabel)
        let text = (teamVision?.text?.isEmpty == Optional(false)) ? teamVision?.text : interactor.teamNullStateSubtitle
        detailTextView.attributedText = ThemeText.tbvVisionBody.attributedString(text)
        tempTeamImageURL = teamVision?.profileImageResource?.url()
        userImageView.contentMode = .scaleAspectFill
        userImageView.setImage(url: tempTeamImageURL, placeholder: userImageView.image) { (_) in /* */}
        let lastModified = AppTextService.get(.my_x_team_tbv_section_update_subtitle).replacingOccurrences(of: "${date}", with: interactor?.lastUpdatedTeamVision() ?? "")
        ThemeText.teamTvbTimeSinceTitle.apply(lastModified, to: lastModifiedLabel)
    }
}

// MARK: - TeamToBeVisionViewControllerInterface
extension TeamToBeVisionViewController: TeamToBeVisionViewControllerInterface {
    func setSelectionBarButtonItems() {
        toBeVisionSelectionBar.allOff()
        toBeVisionSelectionBar.configure(isOwner: interactor.team.thisUserIsOwner, self)
        navigationBarView.configure(isOwner: interactor.team.thisUserIsOwner, self)
        navigationBarView.backgroundColor = .carbon
    }

    func setupView() {
        scrollView.alpha = 0
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(imageContainerView)
        let title = AppTextService.get(.my_x_team_tbv_new_section_header_title).replacingOccurrences(of: "{$TEAM_NAME}",
                                                                                                     with: interactor.team.name?.uppercased() ?? "")
        ThemeText.tbvSectionHeader.apply(title, to: toBeVisionLabel)
        userImageView.image = R.image.teamTBVPlaceholder()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Layout.padding_50, right: 0)
        scrollView.scrollsToTop = true
        ThemableButton.poll.apply(pollButton, key: .my_x_team_tbv_section_poll_button)
        ThemableButton.poll.apply(trackerButton, key: .my_x_team_tbv_section_rating_button)
        let adapter = ImagePickerControllerAdapter(self)
        imagePickerController = ImagePickerController(cropShape: .square,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      adapter: adapter)
        imagePickerController.delegate = self
        ThemeText.trends.apply(AppTextService.get(.my_x_team_tbv_section_trends_label), to: trendsLabel)
    }

    func load(_ teamVision: QDMTeamToBeVision?) {
        shouldShowCreate = teamVision == nil
        if teamVision == nil {
            interactor.showNullState()
            teamNullStateImageView.gradientBackground(top: true)
            teamNullStateImageView.gradientBackground(top: false)
            return
        }
        if scrollView.alpha == 0 {
            UIView.animate(withDuration: Animation.duration_04) {
                self.scrollView.alpha = 1
            }
        }
        skeletonManager.hide()
        interactor.hideNullState()
        setupContent(teamVision)
        removeGradients()
        addGradients()
        refreshBottomNavigationItems()
    }

    func showNullState(with title: String, message: String, header: String) {
        didShowNullStateView = true
        teamNullStateView.isHidden = false
        teamNullStateView.setupView(with: title, message: message, sectionHeader: header)
        refreshBottomNavigationItems()
        skeletonManager.hide()
    }

    func hideNullState() {
        if didShowNullStateView {
            didShowNullStateView = false
            teamNullStateView.isHidden = true
            refreshBottomNavigationItems()
        }
    }

    func hideTrends(_ hide: Bool) {
        trendsBarView.isHidden = hide
        trendsButton.isHidden = hide
        trendsLabel.isHidden = hide
    }

    func hideSelectionBar(_ hide: Bool) {
        toBeVisionSelectionBar.isHidden = hide
    }
}

// MARK: - TeamVisionViewControllerScrollViewDelegate
extension TeamToBeVisionViewController: TeamToBeVisionViewControllerScrollViewDelegate {
    func scrollToTop(_ animated: Bool) {
        scrollView.scrollToTop(animated)
    }
}

// MARK: - UIScrollViewDelegate
extension TeamToBeVisionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if self.lastContentOffset > offsetY {
            if navigationBarViewTopMarginConstraint.constant < 0 && scrollView.contentOffset.y > 400 {
                showNavigationBarView()
            }
            if offsetY < 0 {
                hideNavigationBarView()
            }
        } else {
            if navigationBarViewTopMarginConstraint.constant == 0 {
                hideNavigationBarView()
            }
        }
        self.lastContentOffset = offsetY
    }
}

// MARK: - ImagePickerControllerAdapterProtocol
extension TeamToBeVisionViewController: ImagePickerControllerAdapterProtocol {

}

// MARK: - ImagePickerControllerDelegate
extension TeamToBeVisionViewController: ImagePickerControllerDelegate {
    func deleteImage() {
        tempTeamImage = nil
        tempTeamImageURL = nil
        saveTeamToBeVisionImageAndData()
        skeletonManager.addOtherView(userImageView)
        userImageView.setImage(url: tempTeamImageURL,
                               placeholder: R.image.teamTBVPlaceholder(),
                               skeletonManager: self.skeletonManager) { (_) in /* */}
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempTeamImage = image
        saveTeamToBeVisionImageAndData()
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func updatePollButton(poll: ButtonTheme.Poll) {
        do {
            let cta = try poll.stateWithAction()
            pollButton.ctaState = cta.state
            pollButton.ctaAction = cta.action
            removeBatchPollButton()
            pollButton.isSelected = false
            switch cta.state {
            case .isHidden:
                pollButton.isHidden = true
            case .isActive:
                pollButton.isHidden = false
                pollButton.isEnabled = true
            case .isInactive:
                pollButton.isHidden = false
                pollButton.isSelected = true
            case .hasBatch:
                pollButton.isHidden = false
                pollButton.isEnabled = true
                addBatchToPollButton()
            case .undefined:
                log("cta.state: undefined", level: .debug)
            }
        } catch {
            log("StateError.unkown: \(error.localizedDescription)", level: .debug)
        }
    }

    func updateTrackerButton(poll: ButtonTheme.Poll) {
        do {
            let cta = try poll.stateWithAction()
            trackerButton.ctaState = cta.state
            trackerButton.ctaAction = cta.action
            removeBatchTrackerButton()
            trackerButton.isSelected = false
            switch cta.state {
            case .isHidden:
                trackerButton.isHidden = true
            case .isActive:
                trackerButton.isHidden = false
                trackerButton.isEnabled = true
            case .isInactive:
                trackerButton.isHidden = false
                trackerButton.isSelected = true
            case .hasBatch:
                trackerButton.isHidden = false
                trackerButton.isEnabled = true
                addBatchToTrackerButton()
            case .undefined:
                log("cta.state: undefined", level: .debug)
            }
        } catch {
            log("StateError.unkown: \(error.localizedDescription)", level: .debug)
        }
    }
}

// MARK: - TeamToBeVisionNavigationBarViewProtocol
extension TeamToBeVisionViewController: TeamToBeVisionNavigationBarViewProtocol {
    func didShare() {
        trackUserEvent(.SHARE, value: interactor.team.remoteID, valueType: .TEAM_TO_BE_VISION, action: .TAP)
        interactor.shareTeamToBeVision()
    }
}
