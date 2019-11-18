//
//  MyVisionViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import Kingfisher

final class MyVisionViewController: BaseViewController, ScreenZLevel2 {

    static var storyboardID = NSStringFromClass(MyVisionViewController.classForCoder())

    @IBOutlet private weak var nullStateView: MyVisionNullStateView!
    @IBOutlet private weak var navigationBarView: MyVisionNavigationBarView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var warningImageView: UIImageView!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var singleMessageRatingView: UIView!
    @IBOutlet private weak var doubleMessageRatingView: UIView!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
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
    private let containerViewSize: CGFloat = 232.0
    private let containerViewRatio: CGFloat = 1.2
    private let lowerBoundAlpha: CGFloat = 0.6
    private let upperBoundAlpha: CGFloat = 1.1
    private var lastContentOffset: CGFloat = 0
    private var tempImage: UIImage?
    private var tempImageURL: URL?
    private var imagePickerController: ImagePickerController!
    let skeletonManager = SkeletonManager()
    var didShowNullStateView = false
    var interactor: MyVisionInteractorInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        userImageView.gradientBackground(top: true)
        userImageView.gradientBackground(top: false)
        showNullState(with: " ", message: " ")
        showSkeleton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
        QuestionnaireViewController.hasArrowsAnimated = false
        interactor.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if !didShowNullStateView {
            return generateBottomNavigationItemForMainView()
        }
        return nil
    }

    func generateBottomNavigationItemForMainView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: R.string.localized.tbvButtonMyTBVData(),
                                     buttonWidth: 160,
                                     action: #selector(myTBVData),
                                     backgroundColor: .carbon,
                                     borderColor: .accent40)]
    }

    @objc func myTBVData() {
        trackUserEvent(.OPEN, valueType: "TBVData", action: .TAP)
        interactor.showTBVData()
    }

    @objc func autogenerateMyVisionAction() {
        trackUserEvent(.OPEN, valueType: "TBVGeneratorFromNullState", action: .TAP)
        removeBottomNavigation()
        interactor.openToBeVisionGenerator()
    }

    private func showRateScreen() {
        trackUserEvent(.OPEN, valueType: "QuestionnaireView", action: .TAP)
        interactor.showRateScreen()
    }

    private func showSkeleton() {
        skeletonManager.addTitle(headerLabel)
        skeletonManager.addSubtitle(toBeVisionLabel)
        skeletonManager.addOtherView(cameraButton)
        skeletonManager.addOtherView(userImageView)
        skeletonManager.addTitle(nullStateView.headerLabel)
        skeletonManager.addSubtitle(nullStateView.detailLabel)
        skeletonManager.addSubtitle(nullStateView.toBeVisionLabel)
        skeletonManager.addOtherView(nullStateView.writeButton)
        skeletonManager.addOtherView(nullStateView.autoGenerateButton)
    }
}

// MARK: - IBActions
private extension MyVisionViewController {
    @IBAction func rateButtonAction(_ sender: UIButton) {
        showRateScreen()
    }

    @IBAction func shareButtonAction(_ sender: UIButton) {
        trackUserEvent(.SHARE, action: .TAP)
        interactor.shareMyToBeVision()
    }

    @IBAction func updateButtonAction(_ sender: UIButton) {
        trackUserEvent(.OPEN, valueType: "UpdateConfirmationView", action: .TAP)
        interactor.showUpdateConfirmationScreen()
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
        trackUserEvent(.OPEN, valueType: "CameraOptions", action: .TAP)
        imagePickerController.show(in: self, deletable: (tempImageURL != nil || tempImage != nil))
        imagePickerController.delegate = self
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }
}

// MARK: - Observer
private extension MyVisionViewController {
    func saveToBeVisionImageAndData() {
        interactor.saveToBeVision(image: tempImage)
    }

    func removeGradients() {
        userImageView.removeSubViews()
    }

    func addGradients(for myVision: QDMToBeVision?) {
        let userImage = myVision?.profileImageResource?.url()
        if userImage != nil {
            userImageView.gradientBackground(top: true)
            userImageView.gradientBackground(top: false)
        }
    }
}

// MARK: - Observer
private extension MyVisionViewController {

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

extension MyVisionViewController: MyVisionViewControllerInterface {

    func showNullState(with title: String, message: String) {
        didShowNullStateView = true
        nullStateView.isHidden = false
        nullStateView.setupView(with: title, message: message, delegate: self)
        refreshBottomNavigationItems()
        skeletonManager.hide()
    }

    func hideNullState() {
        if didShowNullStateView {
            didShowNullStateView = false
            nullStateView.isHidden = true
            refreshBottomNavigationItems()
        }
    }

    func setupView() {
        scrollView.alpha = 0

        ThemeView.level2.apply(view)
        ThemeView.level2.apply(imageContainerView)
        navigationBarView.delegate = self
        ThemeText.tbvSectionHeader.apply(ScreenTitleService.main.localizedString(for: .MyToBeVisionSectionTitle),
                                         to: toBeVisionLabel)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Layout.padding_50, right: 0)
        scrollView.scrollsToTop = true
        ThemeBorder.accent40.apply(cameraButton)
        ThemeBorder.accent40.apply(shareButton)
        ThemeBorder.accent40.apply(rateButton)
        ThemeBorder.accent40.apply(singleMessageRateButton)
        ThemeBorder.accent40.apply(updateButton)

        let adapter = ImagePickerControllerAdapter(self)
        imagePickerController = ImagePickerController(cropShape: .square,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      permissionsManager: AppCoordinator.permissionsManager!,
                                                      adapter: adapter)
        imagePickerController.delegate = self
        userImageView.image = R.image.circlesWarning()
    }

    func load(_ myVision: QDMToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessageRating: Bool?) {
        if myVision == nil {
            interactor.showNullState(with: interactor.nullStateTitle ?? "", message: interactor.nullStateSubtitle ?? "")
            return
        }
        if scrollView.alpha == 0 {
            UIView.animate(withDuration: Animation.duration_04) { self.scrollView.alpha = 1 }
        }
        skeletonManager.hide()
        interactor.hideNullState()

        interactor.isShareBlocked { [weak self] (hidden) in
            self?.shareButton.isHidden = hidden
        }

        var headline = myVision?.headline
        if headline?.isEmpty != false {
            headline = interactor.emptyTBVTitlePlaceholder
        }
        ThemeText.tbvVisionHeader.apply(headline, to: headerLabel)
        let text = (myVision?.text?.isEmpty == Optional(false)) ? myVision?.text : interactor.emptyTBVTextPlaceholder
        detailTextView.attributedText = ThemeText.tbvVisionBody.attributedString(text)

        tempImageURL = myVision?.profileImageResource?.url()
        userImageView.contentMode = tempImageURL == nil ? .center : .scaleAspectFill
        userImageView.setImage(url: tempImageURL, placeholder: userImageView.image) { (_) in /* */}

        removeGradients()
        addGradients(for: myVision)

        ThemeText.tvbTimeSinceTitle.apply(rateText, to: singleMessageRatingLabel)
        ThemeText.tvbTimeSinceTitle.apply(rateText, to: lastRatedLabel)
        ThemeText.tvbTimeSinceTitle.apply(interactor.lastUpdatedVision(), to: lastUpdatedLabel)
        ThemeText.datestamp.apply(R.string.localized.tbvLastUpdatedComment(), to: lastUpdatedComment)
        ThemeText.datestamp.apply(R.string.localized.tbvLastRatedComment(), to: lastRatedComment)

        rateButton.isEnabled = isRateEnabled
        singleMessageRateButton.isEnabled = isRateEnabled
        if let shouldShowSingleMessage = shouldShowSingleMessageRating {
            singleMessageRatingView.isHidden = !shouldShowSingleMessage
            doubleMessageRatingView.isHidden = shouldShowSingleMessage
        } else {
            singleMessageRatingView.isHidden = true
            doubleMessageRatingView.isHidden = true
        }

        interactor.shouldShowWarningIcon { [weak self] (show) in
            self?.warningImageView.isHidden = !show
        }
    }

    func presentTBVUpdateAlert(title: String, message: String, editTitle: String, createNewTitle: String) {
        let createNew = RoundedButton(title: createNewTitle, target: self, action: #selector(continueUpdatingTBV)).barButton
        let edit = RoundedButton(title: editTitle, target: self, action: #selector(editTBV)).barButton
        QOTAlert.show(title: title, message: message, bottomItems: [createNew, edit])
    }
}

// MARK: - MyVisionViewControllerScrollViewDelegate
extension MyVisionViewController: MyVisionViewControllerScrollViewDelegate {
    func scrollToTop(_ animated: Bool) {
        scrollView.scrollToTop(animated)
    }
}

// MARK: - UIScrollViewDelegate
extension MyVisionViewController: UIScrollViewDelegate {
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
extension MyVisionViewController: ImagePickerControllerAdapterProtocol {

}

extension MyVisionViewController: ImagePickerControllerDelegate {
    func deleteImage() {
        tempImage = nil
        tempImageURL = nil
        saveToBeVisionImageAndData()
        skeletonManager.addOtherView(userImageView)
        userImageView.setImage(url: tempImageURL,
                               placeholder: R.image.circlesWarning(),
                               skeletonManager: self.skeletonManager) { (_) in /* */}
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        saveToBeVisionImageAndData()
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }
}

extension MyVisionViewController: MyVisionNavigationBarViewProtocol {
    func didShare() {
        trackUserEvent(.SHARE, action: .TAP)
        interactor.shareMyToBeVision()
    }
}

extension MyVisionViewController: MyVisionNullStateViewProtocol {
    func editMyVisionAction() {
        trackUserEvent(.OPEN, valueType: "CreateNewToBeVisionFromNullState", action: .TAP)
        interactor.showEditVision(isFromNullState: true)
    }
}

extension MyVisionViewController {
    @objc func continueUpdatingTBV() {
        removeBottomNavigation()
        trackUserEvent(.OPEN, valueType: "ToBeVisionGeneratorFromUpdateModal", action: .TAP)
        interactor.openToBeVisionGenerator()
    }

    @objc func editTBV() {
        trackUserEvent(.OPEN, valueType: "EditToBeVision", action: .TAP)
        interactor.showEditVision(isFromNullState: false)
    }
}

extension MyVisionViewController: MyToBeVisionRateViewControllerProtocol {
    func doneAction() {
        interactor.showTracker()
    }
}

extension MyVisionViewController: MyToBeVisionDataNullStateViewControllerProtocol {
    func didRateTBV() {
        showRateScreen()
    }
}
