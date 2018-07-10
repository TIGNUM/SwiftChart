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
    @IBOutlet private weak var imageViewPlaceholder: UIImageView!
    @IBOutlet private weak var editIconImageView: UIImageView!
    @IBOutlet private weak var headlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var tbvGeneratorButton: UIButton!
    @IBOutlet private weak var fadeContainerView: FadeContainerView!
	@IBOutlet private weak var textViewsContainer: UIView!
	@IBOutlet private weak var containerHeight: NSLayoutConstraint!
    @IBOutlet private weak var headlineStatementTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageStatementTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headlineEditingStatementLabel: UILabel!
    @IBOutlet private weak var messageEditingStatementLabel: UILabel!
    @IBOutlet private weak var headlineEditingSeparatorView: UIView!
    @IBOutlet private weak var messageEditingSeparatorView: UIView!
    private var contentInset = UIEdgeInsets()
    private var initialImage = UIImage()
    private let imageBorder = CAShapeLayer()
    private let navItem = NavigationItem(title: R.string.localized.meSectorMyWhyVisionTitle().uppercased())
    private var imagePickerController: ImagePickerController!
    private var imageRecognizer: UITapGestureRecognizer!
    private var toBeVision: MyToBeVisionModel.Model?
    private var imageTapRecognizer = UITapGestureRecognizer()
    private var avPlayerObserver: AVPlayerObserver?
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
                                        self.headlineTextView.becomeFirstResponder()
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
        syncEditingViews(true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        resizeTextViewsHeight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        maskImage()
        resizeTextViewsHeight()
		updateContainerHeight()
        fadeContainerView.setFade(top: safeAreaInsets.top + 30, bottom: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToTop()
        toBeVisionDidUpdate()
        syncEditingViews(true)
        UIApplication.shared.statusBarStyle = .lightContent
        navItem.showTabMenuView(titles: [R.string.localized.meSectorMyWhyVisionTitle().uppercased()])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navItem.title = R.string.localized.meSectorMyWhyVisionTitle().uppercased()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headlineTextView.resignFirstResponder()
        messageTextView.resignFirstResponder()
        if isBeingDismissed == true {
            edit(false)
        }
        navItem.hideTabMenuView()
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
        }
    }
}

// MARK: - Setup

extension MyToBeVisionViewController {

    func setupView() {
        scrollView.contentInset.bottom = 90
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        syncNavigationButtons(false)
        setupInstructionsButton()
        setupTextViews()
        drawCircles()
        setupImage()
    }

    func setupTextViews() {
        headlineTextView.returnKeyType = .next
        headlineTextView.textContainer.lineFragmentPadding = 0
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.textContainer.lineBreakMode = .byTruncatingTail
        messageTextView.alpha = 1
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14, left: 0, bottom: 10, right: 0)
        syncTextViews()
    }

    func setupInstructionsButton() {
        tbvGeneratorButton.layer.borderWidth = 1
        tbvGeneratorButton.layer.cornerRadius = 7
        tbvGeneratorButton.backgroundColor = .azure
    }

    func setupImage() {
        imageContainerView.addGestureRecognizer(imageTapRecognizer)
        if let currentImage = imageView.image {
            initialImage = currentImage
        }
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
        if isEditing == true {
            headlineTextView.attributedText = interactor?
                .headlinePlaceholderNeeded(headlineEdited: headlineTextView.text)?
                .formattedHeadlineEditingMode
        } else {
            headlineTextView.text = interactor?.headlinePlaceholderNeeded(headlineEdited: headlineTextView.text)
        }

        messageTextView.text = interactor?.messagePlaceholderNeeded(messageEdited: messageTextView.text)
        let messageIsPlaceholder = interactor?.messageEqualsPlaceholder(message: messageTextView.text)
        tbvGeneratorButton.isHidden = isEditing || messageIsPlaceholder == false
    }
}

// MARK: - Private drawing

private extension MyToBeVisionViewController {

    func drawCircles() {
        imageContainerView.layer.addSublayer(imageBorder)
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
        let imagePath = UIBezierPath.circlePath(center: imageContainerView.bounds.center, radius: 115)
        let imageMask = CAShapeLayer()
        imageMask.shadowColor = UIColor.white.cgColor
        imageMask.shadowOffset = .zero
        imageMask.shadowOpacity = 1
        imageMask.shadowRadius = 2
        imageMask.path = imagePath.cgPath
        imageView.layer.mask = imageMask
        let placeholderPath = UIBezierPath.circlePath(center: imageContainerView.bounds.center, radius: 115)
        let placeholderMask = CAShapeLayer()
        placeholderMask.path = placeholderPath.cgPath
        imageViewPlaceholder.layer.mask = placeholderMask
        let borderPath = UIBezierPath.circlePath(center: imageContainerView.bounds.center, radius: 115.5)
        imageBorder.fillColor = UIColor.clear.cgColor
        imageBorder.strokeColor = UIColor.white.cgColor
        imageBorder.lineWidth = 1.2
        imageBorder.opacity = 0.55
        imageBorder.path = borderPath.cgPath
    }

	func updateContainerHeight() {
		var height: CGFloat = 0
		for view in textViewsContainer.subviews {
			height += view.frame.height
		}
		containerHeight.constant = height + 60
	}
}

// MARK: - Actions

extension MyToBeVisionViewController {

    @objc func didTapClose(_ sender: UIBarButtonItem) {
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

        imageViewPlaceholder.isVisible = toBeVision?.imageURL == nil
        if toBeVision?.imageURL != nil {
            imageView.kf.setImage(with: toBeVision?.imageURL)
        }
        syncInstructionsButton()
        syncImageControls(animated: false)
    }

    func saveToBeVisison() {
        guard var toBeVision = toBeVision, let image = imageView.image else { return }
        if toBeVision.headLine != headlineTextView.text {
            toBeVision.headLine = headlineTextView.text
        }
        if toBeVision.text != messageTextView.text {
            toBeVision.text = messageTextView.text
            toBeVision.lastUpdated = Date()
        }
        initialImage = image
        interactor?.saveToBeVision(image: image, toBeVision: toBeVision)
    }

    func edit(_ isEditing: Bool) {
        self.isEditing = isEditing
        headlineTextView.isEditable = isEditing
        messageTextView.isEditable = isEditing
        imageView.isUserInteractionEnabled = isEditing
        syncImageControls(animated: isEditing)
        syncNavigationButtons(isEditing)
        syncInstructionsButton()
        syncEditingViews(!isEditing)
        if isEditing == false {
            headlineTextView.font = Font.H1MainTitle
        }
    }

    @objc func saveEdit() {
        guard let toBeVision = toBeVision else { return }
        subtitleLabel.attributedText = toBeVision.formattedSubtitle
        edit(false)
        saveToBeVisison()
        scrollToTop()
    }

    @objc func cancelEdit() {
        edit(false)
        scrollToTop()
        toBeVisionDidUpdate()
        imageView.image = initialImage
    }

    func scrollToTop() {
        let topPoint = CGPoint(x: 0, y: -contentInset.top)
        scrollView.setContentOffset(topPoint, animated: true)
    }

    func syncNavigationButtons(_ isEditing: Bool) {
        let leftButton = UIBarButtonItem()
        let leftButtonImage = isEditing == true ? nil : R.image.ic_minimize()
        let leftButtonText = isEditing == true ? "Cancel" : nil
        let buttonsColor = isEditing == true ? UIColor.gray : UIColor.white
        let leftButtonSelector = isEditing == true ? #selector(cancelEdit) : #selector(didTapClose(_:))
        leftButton.tintColor = buttonsColor
        leftButton.image = leftButtonImage
        leftButton.title = leftButtonText
        leftButton.target = self
        leftButton.action = leftButtonSelector
        navItem.leftBarButtonItem = leftButton
        let rightButton = UIBarButtonItem()
        let rightButtonImage = isEditing == true ? nil : R.image.ic_edit()
        let rightButtonText = isEditing == true ? "Save" : nil
        let rightButtonSelector = isEditing == true ? #selector(saveEdit) : #selector(didTapEdit(_:))
        rightButton.image = rightButtonImage
        rightButton.title = rightButtonText
        rightButton.tintColor = buttonsColor
        rightButton.target = self
        rightButton.action = rightButtonSelector
        navItem.rightBarButtonItem = rightButton
    }

    func syncEditingViews(_ areHidden: Bool) {
        let headlineTopConstraint: CGFloat = areHidden == false ? 25 : 15
        let messageTopConstraint: CGFloat = areHidden == false ? 40 : 20
        let isEmptyState = interactor?.isEmptyState()
        let buttonColor = isEditing == true ? UIColor.gray : UIColor.white
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
        navItem.rightBarButtonItem?.tintColor = isEmptyState == true ? .clear : buttonColor
        headlineStatementTopConstraint.constant = headlineTopConstraint
        messageStatementTopConstraint.constant = messageTopConstraint
        view.layoutIfNeeded()
    }

    func syncImageControls(animated: Bool) {
        let hasImage = toBeVision?.imageURL != nil
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

// MARK: - UITextViewDelegate, UITextView private extension

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        headlineTextView.attributedText = headlineTextView.text.formattedHeadlineEditingMode
        if isEditing == false {
            edit(isEditing)
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case headlineTextView: textView.text = interactor?.headlinePlaceholderNeeded(headlineEdited: textView.text)
        case messageTextView: textView.text = interactor?.messagePlaceholderNeeded(messageEdited: textView.text)
        default: return
        }
        syncTextViews()
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == headlineTextView {
            headlineTextView.attributedText = textView.text.formattedHeadlineEditingMode
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == headlineTextView && text == "\n" {
            headlineTextView.resignFirstResponder()
            messageTextView.becomeFirstResponder()
            messageTextView.text.removeLast()

            let scrollPoint: CGPoint = CGPoint(x: 0, y: messageEditingSeparatorView.frame.maxY - 100)
            scrollView.setContentOffset(scrollPoint, animated: false)
        }
        return true
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {

    func cancelSelection() {
        edit(true)
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        imageView.image = image
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

// MARK: - String

private extension String {

    var formattedHeadlineEditingMode: NSAttributedString? {
        return NSAttributedString(string: self.capitalized,
                                  letterSpacing: -0.4,
                                  font: Font.DPText,
                                  lineSpacing: 10.0,
                                  textColor: .white)
    }
}

// MARK: - Keyboard Handling

private extension MyToBeVisionViewController {

    @objc func handleKeyboard(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let isKeyboardShowing = notification.name == .UIKeyboardWillShow
        let height = isKeyboardShowing ? keyboardFrame.height + 60 : 90
        contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        scrollView.contentInset = contentInset
        UIView.animate(withDuration: Animation.duration_06, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
