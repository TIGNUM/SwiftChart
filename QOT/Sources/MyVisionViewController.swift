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

final class MyVisionViewController: UIViewController {

    static var storyboardID = NSStringFromClass(MyVisionViewController.classForCoder())

    @IBOutlet private weak var navigationBarView: MyVisionNavigationBarView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageOverLapView: UIView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var writtenYesterDayButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var generateVisionButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var detailTextView: UITextView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var middleGradientView: UIView!
    @IBOutlet private weak var navigationBarViewTopMarginConstraint: NSLayoutConstraint!

    private var myVisionDidChange = false
    private var lastContentOffset: CGFloat = 0
    private var tempImage: UIImage?
    private var tempImageURL: URL?
    var interactor: MyVisionInteractorInterface?
    private var imagePickerController: ImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if myVisionDidChange {
            interactor?.viewDidLoad()
            myVisionDidChange = false
        }
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editDetailsController  = segue.destination as? MyVisionEditDetailsViewController {
            MyVisionEditDetailsConfigurator.configure(originViewController: self, viewController: editDetailsController, title: interactor?.myVision?.headline ?? "", vision: interactor?.myVision?.text ?? "")
        }
    }
}

// MARK: - IBActions

private extension MyVisionViewController {
    @IBAction func writtenYesterdayButtonAction(_ sender: UIButton) {
    }

    @IBAction func shareButtonAction(_ sender: UIButton) {
        interactor?.shareMyToBeVision()
    }

    @IBAction func editButtonAction(_ sender: UIButton) {
        interactor?.showEditVision()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func generateVisionAction(_ sender: UIButton) {
        interactor?.openToBeVisionGenerator()
    }

    @IBAction func cameraButtonAction(_ sender: UIButton) {
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
        bottomGradientView.removeSubViews()
        middleGradientView.isHidden = true
        topGradientView.isHidden = true
    }

    func addGradients(for myVision: QDMToBeVision?) {
        let userImage = myVision?.profileImageResource?.url()
        if userImage != nil {
            topGradientView.isHidden = false
            middleGradientView.isHidden = false
        }
        if myVision?.text != nil {
            bottomGradientView.addFadeView(at: .bottom,
                                        height: 100,
                                        primaryColor: .carbon,
                                        fadeColor: colorMode.fade)
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

    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didGetData(notification:)), name: NSNotification.Name.didFinishSynchronization, object: nil)
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didFinishSynchronization, object: nil)
    }

    func formatted(headline: String) -> NSAttributedString? {
        return NSAttributedString(string: headline.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .sand)
    }

    func formatted(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .sand)
    }

    @objc func didGetData(notification: NSNotification) {
        interactor?.updateToBeVision()
    }
}

extension MyVisionViewController: MyVisionViewControllerInterface {

    func setupView() {
        navigationBarView.delegate = self
        toBeVisionLabel.text = R.string.localized.myQOTToBeVisionTitle()
        imageOverLapView.backgroundColor = .carbon40
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Layout.padding_50, right: 0)
        scrollView.scrollsToTop = true
        imageContainerView.backgroundColor = .carbon
        view.backgroundColor = .carbon
        editButton.corner(radius: editButton.frame.size.width/2, borderColor: .accent40)
        cameraButton.corner(radius: cameraButton.frame.size.width/2, borderColor: .accent40)
        backButton.corner(radius: backButton.frame.size.width/2, borderColor: .accent40)
        generateVisionButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        guard let permissionManager = interactor?.permissionManager else { return }
        imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      permissionsManager: permissionManager,
                                                      pageName: .imagePickerToBeVision)
        imagePickerController.delegate = self
    }

    func load(_ myVision: QDMToBeVision?) {
        if myVision == nil {
            interactor?.openToBeVisionGenerator()
            return
        }
        writtenYesterDayButton.isHidden = myVision?.headline == nil && myVision?.text == nil
        shareButton.isHidden = interactor?.isShareBlocked() ?? false
        headerLabel.attributedText = myVision?.headline?.isEmpty ?? true ? formatted(headline: interactor?.headlinePlaceholder ?? "") : formatted(headline: myVision?.headline ?? "")
        detailTextView.attributedText = myVision?.text?.isEmpty ?? true ? formatted(vision: interactor?.messagePlaceholder ?? "") : formatted(vision: myVision?.text ?? "")
        tempImageURL = myVision?.profileImageResource?.url()
        userImageView.setImage(from: tempImageURL, placeholder: R.image.circlesWarning())
        imageOverLapView.isHidden = tempImageURL == nil
        removeGradients()
        addGradients(for: myVision)
        writtenYesterDayButton.setTitle(interactor?.lastUpdatedVision(), for: .normal)
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
        if (self.lastContentOffset > offsetY) {
            if navigationBarViewTopMarginConstraint.constant < 0 && scrollView.contentOffset.y > 500 {
                showNavigationBarView()
            }
            if (offsetY < 0) {
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

extension MyVisionViewController: ImagePickerControllerDelegate {
    func deleteImage() {
        tempImage = nil
        tempImageURL = nil
        userImageView.kf.setImage(with: tempImageURL, placeholder: R.image.circlesWarning())
        RestartHelper.clearRestartRouteInfo()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        saveToBeVisionImage()
        RestartHelper.clearRestartRouteInfo()
    }
}

extension MyVisionViewController: MyVisionNavigationBarViewProtocol {
    func didShare() {
        interactor?.shareMyToBeVision()
    }

    func didEdit() {
        interactor?.showEditVision()
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
    
    func didDismiss() {
        
    }
}
