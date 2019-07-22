//
//  MyVisionViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import AMScrollingNavbar

final class MyVisionViewController: UIViewController, ScreenZLevel2 {

    static var storyboardID = NSStringFromClass(MyVisionViewController.classForCoder())

    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var nullStateView: MyVisionNullStateView!
    @IBOutlet private weak var navigationBarView: MyVisionNavigationBarView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageOverLapView: UIView!
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
    @IBOutlet private weak var lastRatedLabel: UILabel!
    @IBOutlet private weak var singleMessageRatingLabel: UILabel!
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var middleGradientView: UIView!
    @IBOutlet private weak var navigationBarViewTopMarginConstraint: NSLayoutConstraint!

    var didShowNullStateView = false

    private var myVisionDidChange = false
    private var lastContentOffset: CGFloat = 0
    private var tempImage: UIImage?
    private var tempImageURL: URL?
    var interactor: MyVisionInteractorInterface?
    private var imagePickerController: ImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFinishSynchronization(_:)),
                                               name: .didFinishSynchronization,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if myVisionDidChange {
            interactor?.viewDidLoad()
            myVisionDidChange = false
        }
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
        QuestionnaireViewController.hasArrowsAnimated = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editDetailsController  = segue.destination as? MyVisionEditDetailsViewController {
            MyVisionEditDetailsConfigurator.configure(originViewController: self,
                                                      viewController: editDetailsController,
                                                      title: interactor?.myVision?.headline ?? "",
                                                      vision: interactor?.myVision?.text ?? "")
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if didShowNullStateView {
            return generateBottomNavigationItemForNullView()
        } else {
            return generateBottomNavigationItemForMainView()
        }
    }

    func generateBottomNavigationItemForMainView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: "My TBV data", buttonWidth: 127, action: #selector(myTBVData), backgroundColor: .carbon, borderColor: .accent40)]
    }

    func generateBottomNavigationItemForNullView() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: "Auto generate", buttonWidth: 200, action: #selector(autogenerateMyVisionAction), backgroundColor: .carbon, borderColor: .accent40)]
    }

    @objc func myTBVData() {
        trackUserEvent(.OPEN, valueType: "TBVData", action: .TAP)
        interactor?.showTBVData()
    }

    @objc func autogenerateMyVisionAction() {
        trackUserEvent(.OPEN, valueType: "TBVGeneratorFromNullState", action: .TAP)
        interactor?.openToBeVisionGenerator()
    }

    private func showRateScreen() {
        guard let remoteId = interactor?.myVision?.remoteID else { return }
        trackUserEvent(.OPEN, valueType: "QuestionnaireView", action: .TAP)
        interactor?.showRateScreen(with: remoteId)
    }
}

// MARK: - IBActions

private extension MyVisionViewController {

    @IBAction func rateButtonAction(_ sender: UIButton) {
        guard let remoteId = interactor?.myVision?.remoteID else { return }
        interactor?.showRateScreen(with: remoteId)
    }

    @IBAction func shareButtonAction(_ sender: UIButton) {
        trackUserEvent(.SHARE, action: .TAP)
        interactor?.shareMyToBeVision()
    }

    @IBAction func updateButtonAction(_ sender: UIButton) {
        trackUserEvent(.OPEN, valueType: "UpdateConfirmationView", action: .TAP)
        interactor?.showUpdateConfirmationScreen()
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
        trackUserEvent(.OPEN, valueType: "CameraOptions", action: .TAP)
        imagePickerController.show(in: self, deletable: (tempImageURL != nil || tempImage != nil))
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }
}

// MARK: - Observer
private extension MyVisionViewController {
    func saveToBeVisionImage() {
        guard var toBeVision = interactor?.myVision else { return }
        toBeVision.modifiedAt = Date()
        interactor?.saveToBeVision(image: tempImage, toBeVision: toBeVision)
    }

    func removeGradients() {
        middleGradientView.isHidden = true
        topGradientView.isHidden = true
    }

    func addGradients(for myVision: QDMToBeVision?) {
        let userImage = myVision?.profileImageResource?.url()
        if userImage != nil {
            topGradientView.isHidden = false
            middleGradientView.isHidden = false
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

    func formatted(headline: String) -> NSAttributedString? {
        return NSAttributedString(string: headline.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }

    func formatted(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand)
    }
}

extension MyVisionViewController: MyVisionViewControllerInterface {
    func showScreenLoader() {
        loaderView.isHidden = false
    }

    func hideScreenLoader() {
        loaderView.isHidden = true
    }

    func showNullState(with title: String, message: String) {
        didShowNullStateView = true
        nullStateView.isHidden = false
        nullStateView.setupView(with: title, message: message, delegate: self)
        refreshBottomNavigationItems()
    }

    func hideNullState() {
        didShowNullStateView = false
        nullStateView.isHidden = true
        refreshBottomNavigationItems()
    }

    func setupView() {
        navigationBarView.delegate = self
        toBeVisionLabel.text = R.string.localized.myQOTToBeVisionTitle()
        imageOverLapView.backgroundColor = .carbon40
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Layout.padding_50, right: 0)
        scrollView.scrollsToTop = true
        imageContainerView.backgroundColor = .carbon
        view.backgroundColor = .carbon
        cameraButton.corner(radius: cameraButton.frame.size.width/2, borderColor: .accent40)
        rateButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        singleMessageRateButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        updateButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        let adapter = ImagePickerControllerAdapter(self)
        imagePickerController = ImagePickerController(cropShape: .square,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      permissionsManager: AppCoordinator.appState.permissionsManager!,
                                                      pageName: .imagePickerToBeVision,
                                                      adapter: adapter)
        imagePickerController.delegate = self
    }

    func load(_ myVision: QDMToBeVision?, rateText: String?, isRateEnabled: Bool, shouldShowSingleMessage: Bool) {
        if myVision == nil {
            interactor?.showNullState(with: interactor?.headlinePlaceholder ?? "", message: interactor?.messagePlaceholder ?? "")
            return
        }
        rateButton.isEnabled = myVision?.remoteID != nil
        interactor?.hideNullState()
        shareButton.isHidden = interactor?.isShareBlocked() ?? false
        headerLabel.attributedText = myVision?.headline?.isEmpty ?? true ? formatted(headline: interactor?.headlinePlaceholder ?? "") : formatted(headline: myVision?.headline ?? "")
        detailTextView.attributedText = myVision?.text?.isEmpty ?? true ? formatted(vision: interactor?.messagePlaceholder ?? "") : formatted(vision: myVision?.text ?? "")
        tempImageURL = myVision?.profileImageResource?.url()
        userImageView.contentMode = tempImageURL == nil ? .center : .scaleAspectFill
        userImageView.setImage(from: tempImageURL, placeholder: R.image.circlesWarning())
        imageOverLapView.isHidden = tempImageURL == nil
        removeGradients()
        addGradients(for: myVision)
        lastRatedLabel.text = rateText
        rateButton.isEnabled = isRateEnabled
        singleMessageRateButton.isEnabled = isRateEnabled
        singleMessageRatingLabel.text = rateText
        lastUpdatedLabel.text = interactor?.lastUpdatedVision()
        singleMessageRatingView.isHidden = !shouldShowSingleMessage
        doubleMessageRatingView.isHidden = shouldShowSingleMessage
        guard let shouldShowWarningIcon = interactor?.shouldShowWarningIcon() else { return }
        warningImageView.isHidden = !shouldShowWarningIcon
    }
}

// MARK: - UIScrollViewDelegate
extension MyVisionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let alphaValue = (offsetY/232.0)*1.2
        if alphaValue > 0.4 && alphaValue < 1.1 {
            DispatchQueue.main.async {
                self.imageOverLapView.backgroundColor = UIColor(red: 20/255, green: 19/255, blue: 18/255, alpha: alphaValue)
            }
        }

        if self.lastContentOffset > offsetY {
            if navigationBarViewTopMarginConstraint.constant < 0 && scrollView.contentOffset.y > 500 {
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
        saveToBeVisionImage()
        userImageView.kf.setImage(with: tempImageURL, placeholder: R.image.circlesWarning())
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        userImageView.image = tempImage
        saveToBeVisionImage()
        RestartHelper.clearRestartRouteInfo()
        refreshBottomNavigationItems()
    }
}

extension MyVisionViewController: MyVisionNavigationBarViewProtocol {
    func didShare() {
        trackUserEvent(.SHARE, action: .TAP)
        interactor?.shareMyToBeVision()
    }
}

extension MyVisionViewController: MyVisionEditDetailsViewControllerProtocol {
    func didSave(_ saved: Bool) {
        if saved == true {
            interactor?.viewDidLoad()
        }
    }
}

extension MyVisionViewController: DecisionTreeViewControllerDelegate {
    func toBeVisionDidChange() {
        myVisionDidChange = true
    }

    func didDismiss() {}
}

extension MyVisionViewController: MyVisionNullStateViewProtocol {
    func editMyVisionAction() {
        trackUserEvent(.OPEN, valueType: "CreateNewToBeVisionFromNullState", action: .TAP)
        interactor?.showEditVision()
    }
}

extension MyVisionViewController: PopUpViewControllerProtocol {
    func leftButtonAction() {
        trackUserEvent(.OPEN, valueType: "ToBeVisionGeneratorFromUpdateModal", action: .TAP)
        interactor?.closeUpdateConfirmationScreen(completion: {[weak self] in
            self?.interactor?.openToBeVisionGenerator()
        })
    }

    func rightButtonAction() {
        trackUserEvent(.OPEN, valueType: "EditToBeVision", action: .TAP)
        interactor?.closeUpdateConfirmationScreen(completion: {[weak self] in
            self?.interactor?.showEditVision()
        })
    }

    func cancelAction() {
        interactor?.closeUpdateConfirmationScreen(completion: {[weak self] in
            self?.refreshBottomNavigationItems()
        })
    }
}

extension MyVisionViewController: MyToBeVisionRateViewControllerProtocol {
    func doneAction() {
        interactor?.showTracker()
        myVisionDidChange = true
    }
}

extension MyVisionViewController: MyToBeVisionDataNullStateViewControllerProtocol {
    func didRateTBV() {
        showRateScreen()
    }
}

// MARK: - TBV TRACKER DID FINISH DOWN SYNC
extension MyVisionViewController {
    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext else { return }
        if syncResult.dataType == .MY_TO_BE_VISION_TRACKER, syncResult.syncRequestType == .DOWN_SYNC {
            interactor?.viewDidLoad()
        }
    }
}
