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

final class MyToBeVisionViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var headlineTextView: UITextView!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var editImageLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var placeholderImageView: UIImageView!
    @IBOutlet private weak var editIconImageView: UIImageView!
    @IBOutlet private weak var headlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var tbvGeneratorButton: UIButton!
    @IBOutlet private weak var fadeContainerView: FadeContainerView!
    @IBOutlet private weak var minScrollViewContentHeight: NSLayoutConstraint!
    @IBOutlet private weak var messageStatementTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headlineEditingStatementLabel: UILabel!
    @IBOutlet private weak var messageEditingStatementLabel: UILabel!
    @IBOutlet private weak var headlineEditingSeparatorView: UIView!
    @IBOutlet private weak var messageEditingSeparatorView: UIView!
    private let keyboardListener = KeyboardListener()
    private let navItem = NavigationItem(title: R.string.localized.meSectorMyWhyVisionTitle().uppercased())
    private var imagePickerController: ImagePickerController!
    private var imageRecognizer: UITapGestureRecognizer!
    private var toBeVision: MyToBeVisionModel.Model?
    private var imageTapRecognizer = UITapGestureRecognizer()
    private var avPlayerObserver: AVPlayerObserver?
    private var imageIsHidden = false
    private var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] = [:]
    var interactor: MyToBeVisionInteractor?
    var router: MyToBeVisionRouter?
    var permissionsManager: PermissionsManager!

    private lazy var editAlertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: R.string.localized.alertButtonTitleEditVision(),
                                       style: .default) { [unowned self] (alertAction: UIAlertAction) in
                                        self.isEditing = true
                                        self.edit(true)
        }

        let generatorAction = UIAlertAction(title: R.string.localized.alertButtonTitleCreateVision(),
                                            style: .default) { [unowned self] (alertAction: UIAlertAction) in
                                                self.interactor?.makeVisionGeneratorAndPresent()
        }

        let cancelAction = UIAlertAction(title: R.string.localized.alertButtonTitleCancel(),
                                         style: .cancel) { [unowned self] (alertAction: UIAlertAction) in
                                            self.isEditing = false
                                            self.edit(false)
        }

        alertController.addAction(editAction)
        alertController.addAction(generatorAction)
        alertController.addAction(cancelAction)
        return alertController
    }()

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
        visionChatItems = interactor?.visionChatItems ?? [:]
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
        resizeTextViewsHeight()
        syncEditingViews(true)

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

        syncEditingViews(true)
        keyboardListener.startObserving()
        UIApplication.shared.statusBarStyle = .lightContent
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
        let bottomInset = max(safeAreaInsets.bottom + 200, keyboardListener.state.height)
        scrollView.contentInset.bottom = bottomInset
        fadeContainerView.setFade(top: safeAreaInsets.top + 32, bottom: 0)
        minScrollViewContentHeight.constant = scrollView.bounds.height - bottomInset + 150
    }
}

// MARK: - MyToBeVisionViewContollerInterface

extension MyToBeVisionViewController: MyToBeVisionViewControllerInterface {

    func showVisionGenerator() {
        let chatViewModel = ChatViewModel<VisionGeneratorChoice>(items: [])
        let configurator = VisionGeneratorConfigurator.make(chatViewModel,
                                                            visionModel: toBeVision,
                                                            visionController: self,
                                                            visionChatItems: visionChatItems)
        let chatViewController = ChatViewController(pageName: .visionGenerator,
                                                    viewModel: chatViewModel,
                                                    backgroundImage: R.image.backgroundChatBot(),
                                                    configure: configurator)
        chatViewController.title = "CREATE A TO BE VISION"
        let navController = UINavigationController(rootViewController: chatViewController)
        navController.navigationBar.applyDarkBluryStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        pushToStart(childViewController: chatViewController)
    }

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
        showAlert(type: .canNotUploadPhoto)
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
        navItem.rightBarButtonItem = rightButton
    }

    func setupTextViews() {
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.textContainer.lineBreakMode = .byTruncatingTail
        headlineTextView.textContainer.lineFragmentPadding = 0

        messageTextView.alpha = 1
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 10.0, right: 0.0)
        syncTextViews()
    }

    func setupInstructionsButton() {
        tbvGeneratorButton.layer.borderWidth = 1
        tbvGeneratorButton.layer.cornerRadius = 7
        tbvGeneratorButton.backgroundColor = .azure
    }

    func setupImage() {
        imageContainerView.addGestureRecognizer(imageTapRecognizer)
    }

    func resizeTextViewsHeight() {
        let headlineSize = headlineTextView.sizeThatFits(CGSize(width: headlineTextView.frame.size.width,
                                                                height: CGFloat(MAXFLOAT)))
        headlineHeightConstraint.constant = headlineSize.height
        let messageSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width,
                                                              height: CGFloat(MAXFLOAT)))
        messageHeightConstraint.constant = messageSize.height
    }

    func syncTextViews() {
        resizeTextViewsHeight()
        syncInstructionsButton()
    }

    func syncInstructionsButton() {
        headlineTextView.text = interactor?.headlinePlaceholderNeeded(headlineEdited: headlineTextView.text)
        messageTextView.text = interactor?.messagePlaceholderNeeded(messageEdited: messageTextView.text)

        let messageIsPlaceholder = interactor?.messageEqualsPlaceholder(message: messageTextView.text)
        tbvGeneratorButton.isHidden = isEditing || messageIsPlaceholder == false
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
        let path = UIBezierPath()
        let borderMask = CAShapeLayer()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.maxX, y: view.bounds.minY))
        path.addLine(to: CGPoint(x: view.bounds.maxX, y: 225))
        path.addCurve(to: CGPoint(x: view.bounds.minX, y: 225),
                      controlPoint1: CGPoint(x: view.bounds.midX + (view.bounds.midX / 2), y: 275),
                      controlPoint2: CGPoint(x: view.bounds.midX - (view.bounds.midX / 2), y: 275))
        path.addLine(to: CGPoint(x: view.bounds.minX, y: view.bounds.minY))
        borderMask.path = path.cgPath
        imageView.layer.mask = borderMask
    }
}

// MARK: - Actions

extension MyToBeVisionViewController {

    @objc func didTapClose(_ sender: UIBarButtonItem) {
        saveToBeVisison()
        router?.close()
    }

    @objc func didTapEdit(_ sender: UIBarButtonItem) {
        if isEditing == true {
            editAlertController.dismiss(animated: true, completion: nil)
            self.isEditing = false
            self.edit(false)
        } else {
            showEditActionSheet()
        }
    }

    @objc func didTapImage() {
        imagePickerController.show(in: self)
    }

    @IBAction private func didTapCreateVision() {
        interactor?.makeVisionGeneratorAndPresent()
    }
}

// MARK: - Sync

private extension MyToBeVisionViewController {

    func showEditActionSheet() {
        present(editAlertController, animated: true, completion: nil)
    }

    func toBeVisionDidUpdate() {
        subtitleLabel.attributedText = toBeVision?.formattedSubtitle
        if headlineTextView.attributedText != toBeVision?.formattedHeadline && toBeVision?.headLine != nil {
            headlineTextView.attributedText = toBeVision?.formattedHeadline
        }
        if messageTextView.attributedText != toBeVision?.formattedVision {
            messageTextView.attributedText = toBeVision?.formattedVision
        }

        placeholderImageView.isVisible = toBeVision?.imageURL == nil
        if toBeVision?.imageURL != nil {
            imageView.kf.setImage(with: toBeVision?.imageURL)
        }
        syncInstructionsButton()
        syncImageControls(animated: false)
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
        syncImageControls(animated: isEditing)
        syncInstructionsButton()
        syncEditingViews(!isEditing)
    }

    func syncEditingViews(_ areHidden: Bool) {
        let messageTopConstraint: CGFloat = areHidden == false ? 40 : 20
        let isEmptyState = interactor?.isEmptyState()
        headlineEditingSeparatorView.isHidden = areHidden
        messageEditingSeparatorView.isHidden = areHidden
        headlineEditingStatementLabel.isHidden = areHidden
        messageEditingStatementLabel.isHidden = areHidden
        imageTapRecognizer.isEnabled = !areHidden
        editIconImageView.isHidden = areHidden
        editImageLabel.isHidden = areHidden
        subtitleLabel.isHidden = !areHidden
        headlineTextView.isHidden = isEmptyState == true
        navItem.rightBarButtonItem?.isEnabled = isEmptyState == false
        navItem.rightBarButtonItem?.tintColor = isEmptyState == true ? .clear : .white
        messageStatementTopConstraint.constant = messageTopConstraint
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
            self.editImageLabel.alpha = buttonAlpha
            self.editIconImageView.alpha = buttonAlpha
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

// MARK: - UITextViewDelegate, UITextView private extension

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isEditing == false {
            edit(isEditing)
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        headlineTextView.font = Font.H9Title
        resizeTextViewsHeight()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        headlineTextView.font = Font.H1MainTitle
        switch textView {
        case headlineTextView: textView.text = interactor?.headlinePlaceholderNeeded(headlineEdited: textView.text)
        case messageTextView: textView.text = interactor?.messagePlaceholderNeeded(messageEdited: textView.text)
        default: return
        }
        syncTextViews()
    }

    func textViewDidChange(_ textView: UITextView) {
        resizeTextViewsHeight()
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {

    func cancelSelection() {}

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
