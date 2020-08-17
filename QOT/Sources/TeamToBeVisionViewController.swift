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
    private lazy var router: TeamToBeVisionRouterInterface = TeamToBeVisionRouter(viewController: self)
    @IBOutlet private weak var teamNullStateView: TeamToBeVisionNullStateView!
    @IBOutlet private weak var navigationBarView: TeamToBeVisionNavigationBarView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var warningImageView: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    @IBOutlet private weak var singleMessageRatingView: UIView!
    @IBOutlet private weak var doubleMessageRatingView: UIView!
    @IBOutlet private weak var rateButton: UIButton!
    @IBOutlet private weak var singleMessageRateButton: UIButton!
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var lastUpdatedLabel: UILabel!
    @IBOutlet private weak var lastUpdatedComment: UILabel!
    @IBOutlet private weak var lastRatedLabel: UILabel!
    @IBOutlet private weak var lastRatedComment: UILabel!
    @IBOutlet private weak var singleMessageRatingLabel: UILabel!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var navigationBarViewTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet private weak var teamNullStateImageView: UIImageView!
    @IBOutlet weak var infoStackView: UIStackView!

    var didShowNullStateView = false
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
    let skeletonManager = SkeletonManager()

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
        shareButton.isHidden = true
        showNullState(with: " ", message: " ", writeMessage: "")
        showSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)

        interactor.viewWillAppear()
    }

    func viewDidAppeasr(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func showSkeleton() {
        skeletonManager.addTitle(headerLabel)
        skeletonManager.addSubtitle(toBeVisionLabel)
        skeletonManager.addOtherView(cameraButton)
        skeletonManager.addOtherView(teamNullStateImageView)
        skeletonManager.addOtherView(userImageView)
        skeletonManager.addTitle(teamNullStateView.headerLabel)
        skeletonManager.addSubtitle(teamNullStateView.detailLabel)
        skeletonManager.addSubtitle(teamNullStateView.toBeVisionLabel)
        skeletonManager.addOtherView(teamNullStateView.writeButton)
    }

    @IBAction func editButtonAction(_ sender: Any) {
//        trackUserEvent(.EDIT, value: interactor?.team?.remoteID, valueType: .EDIT_TEAM_TBV, action: .TAP)
//        interactor.showEditVision(isFromNullState: false)
        let controller = R.storyboard.visionRatingExplanation.visionRatingExplanationViewController()
        if let controller = controller {
            let configurator = VisionRatingExplanationConfigurator.make()
            configurator(controller)
            self.present(controller, animated: true, completion: nil)
        }
    }

    @IBAction func cameraButtonAction(_ sender: Any) {
        trackUserEvent(.EDIT, value: interactor?.team?.remoteID, valueType: .PICK_TEAM_TBV_IMAGE, action: .TAP)
        imagePickerController.show(in: self, deletable: (tempTeamImageURL != nil || tempTeamImage != nil))
        imagePickerController.delegate = self
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }

    @IBAction func writeButtonAction(_ sender: Any) {
        trackUserEvent(.EDIT, value: interactor?.team?.remoteID, valueType: .WRITE_TEAM_TBV, action: .TAP)
        interactor.showEditVision(isFromNullState: false)
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
}

// MARK: - Observer
private extension TeamToBeVisionViewController {

    func hideNavigationBarView() {
        navigationBarViewTopMarginConstraint.constant = -150
    }

    func showNavigationBarView() {
        navigationBarViewTopMarginConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Actions
private extension TeamToBeVisionViewController {

}

// MARK: - TeamToBeVisionViewControllerInterface
extension TeamToBeVisionViewController: TeamToBeVisionViewControllerInterface {
    func setupView() {
        scrollView.alpha = 0
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(imageContainerView)
        navigationBarView.delegate = self
        ThemeText.tbvSectionHeader.apply(AppTextService.get(.my_x_team_tbv_section_header_title),
                                         to: toBeVisionLabel)
        userImageView.image = R.image.teamTBVPlaceholder()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Layout.padding_50, right: 0)
        scrollView.scrollsToTop = true
        guard (interactor?.team?.thisUserIsOwner) == true else {
            infoStackView.isHidden = true
            cameraButton.isHidden = true
            return
        }
        ThemeBorder.accent40.apply(cameraButton)
        ThemeBorder.accent40.apply(shareButton)
        ThemeBorder.accent40.apply(rateButton)
        ThemeBorder.accent40.apply(singleMessageRateButton)
        ThemeBorder.accent40.apply(updateButton)
        let adapter = ImagePickerControllerAdapter(self)
        imagePickerController = ImagePickerController(cropShape: .square,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      adapter: adapter)
        imagePickerController.delegate = self
    }

    func load(_ teamVision: QDMTeamToBeVision?,
                rateText: String?,
                isRateEnabled: Bool,
                shouldShowSingleMessageRating: Bool?) {
        if teamVision == nil {
            interactor.showNullState(with: interactor.teamNullStateTitle ?? "", message: interactor.teamNullStateSubtitle ?? "", writeMessage: interactor.nullStateCTA ?? "")
            teamNullStateImageView.gradientBackground(top: true)
            teamNullStateImageView.gradientBackground(top: false)
            return
        }
        if scrollView.alpha == 0 {
            UIView.animate(withDuration: Animation.duration_04) { self.scrollView.alpha = 1 }
        }
        skeletonManager.hide()
        interactor.hideNullState()
//        interactor.isShareBlocked { [weak self] (hidden) in
//            self?.shareButton.isHidden = hidden
//        }
        var headline = teamVision?.headline
        if headline?.isEmpty != false {
            headline = interactor.emptyTeamTBVTitlePlaceholder
        }
        ThemeText.tbvVisionHeader.apply(headline, to: headerLabel)
        let text = (teamVision?.text?.isEmpty == Optional(false)) ? teamVision?.text : interactor.emptyTeamTBVTextPlaceholder
        detailTextView.attributedText = ThemeText.tbvVisionBody.attributedString(text)
        tempTeamImageURL = teamVision?.profileImageResource?.url()
        userImageView.contentMode = tempTeamImageURL == nil ? .center : .scaleAspectFill
        userImageView.setImage(url: tempTeamImageURL, placeholder: userImageView.image) { (_) in /* */}
        removeGradients()
        addGradients()
        //        TO DO: Get rate text for team
        //        ThemeText.tvbTimeSinceTitle.apply(rateText, to: singleMessageRatingLabel)
        //        ThemeText.tvbTimeSinceTitle.apply(rateText, to: lastRatedLabel)

        //        Temp disabling Rating button items
        rateButton.isEnabled = false
        rateButton.isHidden = true
        singleMessageRateButton.isEnabled = false
        singleMessageRatingView.isHidden = true
        doubleMessageRatingView.isHidden = true
        warningImageView.isHidden = true

        ThemeText.tvbTimeSinceTitle.apply(interactor?.lastUpdatedTeamVision(), to: lastUpdatedLabel)
        ThemeText.datestamp.apply(AppTextService.get(.my_qot_my_tbv_section_update_subtitle),
                                  to: lastUpdatedComment)
    }

    func showNullState(with title: String, message: String, writeMessage: String) {
        didShowNullStateView = true
        teamNullStateView.isHidden = false
        teamNullStateView.setupView(with: title, message: message, writeMessage: writeMessage, delegate: self)
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

// MARK: - ImagePickerDelegate
extension TeamToBeVisionViewController: ImagePickerControllerAdapterProtocol {

}

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
}

extension TeamToBeVisionViewController: TeamToBeVisionNullStateViewProtocol {

    func editTeamVisionAction() {
        trackUserEvent(.OPEN, valueType: .WRITE_TEAM_TBV, action: .TAP)
        interactor.showEditVision(isFromNullState: true)
    }
}

extension TeamToBeVisionViewController: TeamToBeVisionNavigationBarViewProtocol {

    func didShare() {
//        to do later
    }
}
