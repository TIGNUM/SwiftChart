//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 07/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MyToBeVisionViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var headlineTextView: UITextView!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var editImageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var placeholderImageView: UIImageView!
    @IBOutlet private weak var darkBackgroundImageView: UIImageView!
    @IBOutlet private weak var editIconImageView: UIImageView!
    @IBOutlet private weak var headlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var instructionsButton: UIButton!
    @IBOutlet private weak var fadeContainerView: FadeContainerView!
    @IBOutlet private weak var minScrollViewContentHeight: NSLayoutConstraint!

    private let keyboardListener = KeyboardListener()
    private let navItem = NavigationItem(title: R.string.localized.meSectorMyWhyVisionTitle().uppercased())
    private var imagePickerController: ImagePickerController!
    private var imageRecognizer: UITapGestureRecognizer!
    private var toBeVision: MyToBeVisionModel.Model?
    private var imageTapRecognizer = UITapGestureRecognizer()
    private var imageIsHidden = false
    var interactor: MyToBeVisionInteractor?
    var router: MyToBeVisionRouter?
    var permissionsManager: PermissionsManager!

    // MARK: - Lifecycle

    init(configurator: Configurator<MyToBeVisionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
        imagePickerController = ImagePickerController(cropShape: .circle,
                                                      imageQuality: .low,
                                                      imageSize: .small,
                                                      permissionsManager: permissionsManager)
        imagePickerController.delegate = self
        imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var navigationItem: UINavigationItem {
        return navItem
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.viewDidLoad()
        setupView()

        keyboardListener.onStateChange { [weak self] (state) in
            self?.syncScrollViewInsets()
        }
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        syncScrollViewInsets()
        resizeTextViewsHeight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        syncScrollViewInsets()
        resizeTextViewsHeight()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        maskImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        keyboardListener.startObserving()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBeingDismissed == true {
            edit(false)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        keyboardListener.stopObserving()
    }

    func syncScrollViewInsets() {
        let topInset = safeAreaInsets.top
        let bottomeInset = max(safeAreaInsets.bottom, keyboardListener.state.height)

        scrollView.contentInset.top = topInset
        scrollView.contentInset.bottom = bottomeInset
        fadeContainerView.setFade(top: safeAreaInsets.top, bottom: 0)
        minScrollViewContentHeight.constant = scrollView.bounds.height - topInset - bottomeInset  + 31
    }
}

// MARK: - MyToBeVisionViewContollerInterface

extension MyToBeVisionViewController: MyToBeVisionViewControllerInterface {

    func setup(with toBeVision: MyToBeVisionModel.Model) {
        self.toBeVision = toBeVision
        toBeVisionDidUpdate()
    }

    func update(with toBeVision: MyToBeVisionModel.Model) {
        if toBeVision != self.toBeVision {
            self.toBeVision = toBeVision
            toBeVisionDidUpdate()
        }
    }

    func displayImageError() {
        let alertController = UIAlertController(title: R.string.localized.meSectorMyWhyPartnersPhotoErrorTitle(),
                                                message: R.string.localized.meSectorMyWhyPartnersPhotoErrorMessage(),
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: R.string.localized.meSectorMyWhyPartnersPhotoErrorOKButton(),
                                        style: .default)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Setup

extension MyToBeVisionViewController {

    func setupView() {
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        setupNavigation()
        setupInstructionsButton()
        setupTextViews()
        drawCircles()
        setupImage()
    }

    func setupNavigation() {
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        leftButton.target = self
        leftButton.action = #selector(didTapClose(_ :))
        navItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        rightButton.target = self
        rightButton.action = #selector(didTapEdit(_ :))
        rightButton.tintColor = .white40
        navItem.rightBarButtonItem = rightButton
    }

    func setupTextViews() {
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.textContainer.lineBreakMode = .byTruncatingTail
        headlineTextView.textContainer.lineFragmentPadding = 0

        messageTextView.alpha = 1
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 10.0, right: 0.0)
        checkIfPlaceholdersNeeded()
    }

    func setupInstructionsButton() {
        instructionsButton.layer.borderWidth = 1
        instructionsButton.layer.borderColor = UIColor.gray.cgColor
        instructionsButton.layer.cornerRadius = instructionsButton.bounds.height * 0.5
    }

    func setupImage() {
        editImageLabel.alpha = 0
        editIconImageView.alpha = 0
        imageView.addGestureRecognizer(imageTapRecognizer)
    }

    func resizeTextViewsHeight() {
        let headlineSize = headlineTextView.sizeThatFits(CGSize(width: headlineTextView.frame.size.width,
                                                                height: CGFloat(MAXFLOAT)))
        headlineHeightConstraint.constant = headlineSize.height

        let messageSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width,
                                                              height: CGFloat(MAXFLOAT)))
        messageHeightConstraint.constant = messageSize.height
    }

    func checkIfPlaceholdersNeeded() {
        if headlineTextView.text.trimmingCharacters(in: CharacterSet.newlines).components(separatedBy: .whitespaces)[0] == "" {
            headlineTextView.text = R.string.localized.meSectorMyWhyVisionHeadlinePlaceholder().uppercased()
        }
        if messageTextView.text.trimmingCharacters(in: CharacterSet.newlines).components(separatedBy: .whitespaces)[0] == "" {
            messageTextView.text = R.string.localized.meSectorMyWhyVisionMessagePlaceholder()
        }
        resizeTextViewsHeight()
    }

    func syncInstructionsButton() {
        instructionsButton.isHidden = isEditing || messageTextView.text != R.string.localized.meSectorMyWhyVisionMessagePlaceholder()
    }
}

// MARK: - Private drawing

private extension MyToBeVisionViewController {

    func drawCircles() {
        var center = view.center; center.x *= 0.2; center.y *= 1.1
        let circleLayer1 = CAShapeLayer.circle(center: center,
                                               radius: view.bounds.width * 0.55,
                                               fillColor: .clear,
                                               strokeColor: .whiteLight8)
        circleLayer1.lineDashPattern = [1, 2]
        view.layer.insertSublayer(circleLayer1, below: scrollView.layer)
        let circleLayer2 = CAShapeLayer.circle(center: center,
                                               radius: view.bounds.width * 0.9,
                                               fillColor: .clear,
                                               strokeColor: .whiteLight8)
        view.layer.insertSublayer(circleLayer2, below: scrollView.layer)

    }

    func maskImage() {
        let bounds = imageContainerView.bounds
        let radius = bounds.height * 2 // Magic number matching placeholder radius
        let center = CGPoint(x: bounds.midX, y: radius)
        let path = UIBezierPath.circlePath(center: center, radius: radius)
        let borderMask = CAShapeLayer()
        let borderMask2 = CAShapeLayer()
        borderMask.path = path.cgPath
        borderMask2.path = path.cgPath
        imageView.layer.mask = borderMask
        darkBackgroundImageView.layer.mask = borderMask2
    }
}

// MARK: - Actions

extension MyToBeVisionViewController {

    @objc func didTapClose(_ sender: UIBarButtonItem) {
        saveToBeVisison()
        router?.close()
    }

    @objc func didTapEdit(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
        edit(isEditing)
    }

    @objc func didTapImage() {
        imagePickerController.show(in: self)
    }

    @IBAction func didTapViewInstructions(_ sender: UIButton) {
        let stringURL = "https://s3.eu-central-1.amazonaws.com/tignum-content/videos/On-boarding/TO_BE_VISION.mp4"
        guard let videoURL = URL(string: stringURL) else { return }

        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVPlayer(playerItem: playerItem)
        let playerVC = AVPlayerViewController()
        player.volume = 1.0
        player.play()
        playerVC.player = player
        present(playerVC, animated: true, completion: nil)
    }
}

// MARK: - Sync

private extension MyToBeVisionViewController {

    func toBeVisionDidUpdate() {
        subtitleLabel.attributedText = toBeVision?.formattedSubtitle
        if headlineTextView.attributedText != toBeVision?.formattedHeadline {
            headlineTextView.attributedText = toBeVision?.formattedHeadline
        }
        if messageTextView.attributedText != toBeVision?.formattedVision {
            messageTextView.attributedText = toBeVision?.formattedVision
        }
        if toBeVision?.imageURL == nil {
            placeholderImageView.isVisible = true
            return
        }
        imageView.kf.setImage(with: toBeVision?.imageURL)
        syncInstructionsButton()
    }

    func saveToBeVisison() {
        guard var toBeVision = toBeVision else { return }

        let currentDate = Date()
        if toBeVision.headLine != headlineTextView.text {
            toBeVision.lastUpdated = currentDate
            toBeVision.headLine = headlineTextView.text
        }
        if toBeVision.text != messageTextView.text {
            toBeVision.lastUpdated = currentDate
            toBeVision.text = messageTextView.text
        }

        interactor?.saveToBeVision(toBeVision: toBeVision)
    }

    func edit(_ isEditing: Bool) {
        self.isEditing = isEditing
        headlineTextView.isEditable = isEditing
        messageTextView.isEditable = isEditing
        imageView.isUserInteractionEnabled = isEditing
        navItem.rightBarButtonItem?.tintColor = isEditing ? .white : .white40
        syncImageControls(animated: isEditing)
        syncInstructionsButton()
    }

    func syncImageControls(animated: Bool) {
        let hasImage = toBeVision?.imageURL != nil
        imageView.isHidden = !hasImage
        let buttonAlpha: CGFloat
        if hasImage {
            buttonAlpha = isEditing == true ? 1 : 0
        } else {
            buttonAlpha = isEditing == true ? 1 : 0.3
        }
        imageTapRecognizer.isEnabled = !hasImage || isEditing
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            if self.imageIsHidden == false {
                self.editImageLabel.alpha = buttonAlpha
                self.editIconImageView.alpha = buttonAlpha
            }
            self.imageView.alpha = self.isEditing ? 0.25 : 1
        }
    }
}

// MARK: - Notifications

extension MyToBeVisionViewController {

    override internal func keyboardWillAppear(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = rect.height
    }

    override internal func keyboardWillDisappear(notification: NSNotification) {
        resizeTextViewsHeight()
    }
}

// MARK: - UIScrollViewDelegate

extension MyToBeVisionViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let adjustOffsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        let hideImage = adjustOffsetY >= 30
        setImageViewHidden(hideImage)
    }

    private func setImageViewHidden(_ hidden: Bool) {
        guard imageIsHidden != hidden else { return }

        imageIsHidden = hidden
        let constant = hidden ? imageContainerView.bounds.height : 0
        imageContainerBottomConstraint.constant = constant
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextViewDelegate, UITextView private extension

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isEditing == false {
            edit(isEditing)
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        resizeTextViewsHeight()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        checkIfPlaceholdersNeeded()
    }

    func textViewDidChange(_ textView: UITextView) {
        resizeTextViewsHeight()
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        guard let toBeVision = toBeVision else { return }

        interactor?.updateToBeVisionImage(image: image, toBeVision: toBeVision)
    }
}

// MARK: - NSAttributedString

private extension MyToBeVisionModel.Model {

    var formattedHeadline: NSAttributedString? {
        guard let headLine = headLine else { return nil }

        return NSAttributedString(string: headLine.uppercased(),
                                  letterSpacing: 2,
                                  font: Font.H1MainTitle,
                                  lineSpacing: 3,
                                  textColor: .white)
    }

    var formattedSubtitle: NSAttributedString? {
        guard
            let date = lastUpdated,
            let timeInterval = DateComponentsFormatter.timeIntervalToString(-date.timeIntervalSinceNow, isShort: true)
            else { return nil }

        let text = R.string.localized.meSectorMyWhyVisionWriteDate(timeInterval).uppercased()
        return NSAttributedString(string: text, letterSpacing: 2, font: Font.H7Tag, lineSpacing: 0, textColor: .white30)
    }

    var formattedVision: NSAttributedString? {
        guard let text = text else { return nil }

        return NSAttributedString(string: text,
                                  letterSpacing: -0.4,
                                  font: Font.DPText,
                                  lineSpacing: 10.0,
                                  textColor: .white)
    }
}
