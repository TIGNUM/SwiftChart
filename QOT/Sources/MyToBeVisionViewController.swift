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

final class MyToBeVisionViewController: UIViewController, FullScreenLoadable, PageViewControllerNotSwipeable {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var headlineTextView: UITextView!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var editImageLabel: UILabel!
    @IBOutlet private weak var imageViewVision: UIImageView!
    @IBOutlet private weak var editIconImageView: UIImageView!
    @IBOutlet private weak var headlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageEditButton: UIButton!
	@IBOutlet private weak var textViewsContainer: UIView!
	@IBOutlet private weak var containerHeight: NSLayoutConstraint!
    @IBOutlet private weak var headlineEditingSeparatorView: UIView!
    @IBOutlet private weak var messageEditingSeparatorView: UIView!
	@IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var generatorButton: UIButton!
    private var eventTracker: EventTracker?
	private var contentInset = UIEdgeInsets()
    private var initialImage = UIImage()
    private let imageBorder = CAShapeLayer()
    private var imagePickerController: ImagePickerController!
    private var tempImage: UIImage?
    private var tempImageURL: URL?
    private var avPlayerObserver: AVPlayerObserver?
    private var visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]] = [:]
    static var page: PageName = .tabBarItemToBeVision
    static var generatorPage: PageName = .visionGenerator
    var interactor: MyToBeVisionInteractor?
    var router: MyToBeVisionRouter?
    var permissionsManager: PermissionsManager!
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.loadingData())
            if isLoading == false {
                scrollToTop()
                toBeVisionDidUpdate()
                syncEditingViews(true)
                view.layoutIfNeeded()
            }
        }
    }

    // MARK: - Lifecycle

    init(configurator: Configurator<MyToBeVisionViewController>, eventTracker: EventTracker? = nil) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
        self.eventTracker = eventTracker
        imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                      imageQuality: .medium,
                                                      imageSize: .medium,
                                                      permissionsManager: permissionsManager,
                                                      pageName: .imagePickerToBeVision)
        imagePickerController.delegate = self
        visionChatItems = interactor?.visionChatItems ?? [:]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
        syncEditingViews(true)
        addKeyboardObservers()
        edit(false)
        if UIDevice.isVersion10 == true {
            viewWillAppear(true)
        }
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        resizeTextViewsHeight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeTextViewsHeight()
		updateContainerHeight()
        title = R.string.localized.meSectorMyWhyVisionTitle().uppercased()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToTop()
        toBeVisionDidUpdate()
        syncEditingViews(true)
        updateContainerHeight()
        syncShareButton()
        UIApplication.shared.setStatusBarStyle(.lightContent)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        headlineTextView.resignFirstResponder()
        messageTextView.resignFirstResponder()
        tempImage = nil
        if isBeingDismissed == true {
            edit(false)
        }
    }
}

// MARK: - MyToBeVisionViewContollerInterface

extension MyToBeVisionViewController: MyToBeVisionViewControllerInterface {

    func setLoading() {
        updateReadyState()
        view.layoutIfNeeded()
    }

    func showVisionGenerator() {
        let chatViewController = VisionGeneratorConfigurator.visionGeneratorViewController(pageName: MyToBeVisionViewController.generatorPage,
                                                                                           toBeVision: interactor?.myToBeVision,
                                                                                           visionController: self,
                                                                                           visionChatItems: visionChatItems,
                                                                                           navigationItem: interactor?.navigationItem)
        chatViewController.hidesBottomBarWhenPushed = true
        pushToStart(childViewController: chatViewController, enableInteractivePop: false)
    }

    func setup() {
        toBeVisionDidUpdate()
    }

    func update() {
        toBeVisionDidUpdate()
    }

    func setLaunchOptions(_ options: [LaunchOption: String?]) {
        for option in options.keys {
            let value = options[option] ?? ""
            switch option {
            case .edit:
                if value?.lowercased() == "image" {
                    DispatchQueue.main.async {
                        self.isEditing = true
                        self.edit(true)
                        self.didTapImage()
                    }
                }
            }
        }
    }
}

// MARK: - Setup

extension MyToBeVisionViewController {

    func setupView() {
        headlineEditingSeparatorView.backgroundColor = .darkAzure
        messageEditingSeparatorView.backgroundColor = .darkAzure
        view.backgroundColor = .navy
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInset.bottom = Layout.padding_90
            scrollView.contentInsetAdjustmentBehavior = .never
		} else {
            scrollView.contentInset.bottom = view.bounds.height
		}
        syncNavigationButtons(false)
        setupTextViews()
    }

    func setupTextViews() {
        headlineTextView.returnKeyType = .next
        headlineTextView.textContainer.lineFragmentPadding = 0
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.textContainer.lineBreakMode = .byTruncatingTail
        messageTextView.alpha = 1
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14, left: 0, bottom: 10, right: 0)
    }

    func resizeTextViewsHeight() {
        let headlineSize = headlineTextView.sizeThatFits(CGSize(width: headlineTextView.frame.size.width,
                                                                height: CGFloat(MAXFLOAT)))
        headlineHeightConstraint.constant = headlineSize.height
        let messageSize = messageTextView.sizeThatFits(CGSize(width: messageTextView.frame.size.width,
                                                              height: CGFloat(MAXFLOAT)))
        messageHeightConstraint.constant = messageSize.height
    }
}

// MARK: - Private drawing

private extension MyToBeVisionViewController {

    func updateReadyState() {
        isLoading = !(interactor?.isReady() ?? false)
    }

    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
    }

	func updateContainerHeight() {
        let height: CGFloat = textViewsContainer.subviews.map { $0.frame.height }.reduce(0, +)
        containerHeight.constant = height + imageViewVision.bounds.height
	}
}

// MARK: - Actions

private extension MyToBeVisionViewController {

    @IBAction private func didTapEdit() {
        isEditing = !isEditing
        edit(isEditing)
    }

    @IBAction func didTapImage() {
        imagePickerController.show(in: self, deletable: (tempImageURL != nil || tempImage != nil))
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }

    @IBAction func didTapCreateVision() {
        interactor?.makeVisionGeneratorAndPresent()
    }

    @IBAction func didTapShareButton() {
        interactor?.shareMyToBeVision()
    }
}

// MARK: - Sync

private extension MyToBeVisionViewController {

    func toBeVisionDidUpdate() {
        let toBeVision = interactor?.myToBeVision
        subtitleLabel.attributedText = toBeVision?.formattedSubtitle
        if headlineTextView.attributedText != toBeVision?.formattedHeadline && toBeVision?.headLine != nil {
            headlineTextView.attributedText = toBeVision?.formattedHeadline
        }
        if messageTextView.attributedText != toBeVision?.formattedVision {
            messageTextView.attributedText = toBeVision?.formattedVision
        }

        if tempImage != nil {
            imageViewVision.image = tempImage
        } else {
            imageViewVision.kf.setImage(with: toBeVision?.imageURL, placeholder: R.image.tbv_placeholder())
        }
        syncImageControls(animated: false)
        view.layoutIfNeeded()
    }

    func saveToBeVisison() {
        guard var toBeVision = interactor?.myToBeVision else { return }
        if toBeVision.headLine != headlineTextView.text {
            toBeVision.headLine = headlineTextView.text
        }
        if toBeVision.text != messageTextView.text {
            toBeVision.text = messageTextView.text
            toBeVision.lastUpdated = Date()
        }
        if tempImageURL == nil, toBeVision.imageURL != nil {
            toBeVision.imageURL = nil
            toBeVision.lastUpdated = Date()
        }

        interactor?.saveToBeVision(image: tempImage, toBeVision: toBeVision)
        syncShareButton()
    }

    func edit(_ isEditing: Bool) {
        self.isEditing = isEditing
        headlineTextView.isEditable = isEditing
        messageTextView.isEditable = isEditing
        imageViewVision.isUserInteractionEnabled = isEditing
        syncImageControls(animated: isEditing)
        syncNavigationButtons(isEditing)
        syncEditingViews(!isEditing)
        if isEditing == true {
            headlineTextView.becomeFirstResponder()
            tempImageURL = interactor?.myToBeVision?.imageURL
            MyToBeVisionViewController.page = .editToBeVision
            eventTracker?.track(.didShowPage(self, from: nil))
        } else {
            MyToBeVisionViewController.page = .tabBarItemToBeVision
            eventTracker?.track(.didShowPage(self, from: nil))
            view.endEditing(isEditing)
        }
    }

    @objc func saveEdit() {
        guard let toBeVision = interactor?.myToBeVision else { return }
        subtitleLabel.attributedText = toBeVision.formattedSubtitle
        edit(false)
        saveToBeVisison()
        scrollToTop()
    }

    @objc func cancelEdit() {
        tempImage = nil
        edit(false)
        scrollToTop()
    }

    func scrollToTop() {
        let topPoint = CGPoint(x: 0, y: -contentInset.top)
        scrollView.setContentOffset(topPoint, animated: true)
    }

    func syncNavigationButtons(_ isEditing: Bool) {
        let leftButton = UIBarButtonItem()
        leftButton.tintColor = .white
        leftButton.image =  isEditing == true ? nil : R.image.ic_menu()
        leftButton.title = isEditing == true ? R.string.localized.alertButtonTitleCancel() : nil
        let rightButton = UIBarButtonItem()
        rightButton.image = isEditing == true ? nil : R.image.explainer_ico()
        rightButton.title = isEditing == true ? R.string.localized.alertButtonTitleSave() : nil
        rightButton.tintColor = .white
        interactor?.navigationItem.configure(leftButton: leftButton,
                                             rightButton: rightButton,
                                             tabTitles: [R.string.localized.meSectorMyWhyVisionTitle().uppercased()],
                                             style: .dark)
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        editButton.setImage(R.image.ic_edit()?.withRenderingMode(.alwaysTemplate), for: .selected)
        editButton.imageView?.tintColor = .azure
        generatorButton.setImage(R.image.ic_generator()?.withRenderingMode(.alwaysTemplate), for: .normal)
        generatorButton.setImage(R.image.ic_generator()?.withRenderingMode(.alwaysTemplate), for: .selected)
        generatorButton.imageView?.tintColor = .azure
        shareButton.setImage(R.image.ic_share_fancy()?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.setImage(R.image.ic_share_fancy()?.withRenderingMode(.alwaysTemplate), for: .selected)
        syncShareButton()
    }

    func syncShareButton() {
        let isSharedBlocked = interactor?.isShareBlocked()
        shareButton.imageView?.tintColor = isSharedBlocked == true ? .azure20 : .azure
        shareButton.setTitleColor(isSharedBlocked == true ? .azure20 : .azure, for: .normal)
    }

    func syncEditingViews(_ areHidden: Bool) {
        let isEmptyState = interactor?.isEmptyState()
        imageEditButton.isEnabled = !areHidden
        editIconImageView.isHidden = areHidden
        editImageLabel.isHidden = areHidden
        subtitleLabel.isHidden = !areHidden
        headlineTextView.isHidden = isEmptyState == true
        navigationItem.rightBarButtonItem?.isEnabled = isEmptyState == false
        navigationItem.rightBarButtonItem?.tintColor = isEmptyState == true ? .clear : .white
        view.layoutIfNeeded()
    }

    func syncImageControls(animated: Bool) {
        let hasImage = interactor?.myToBeVision?.imageURL != nil
        let buttonAlpha: CGFloat
        if hasImage {
            buttonAlpha = isEditing == true ? 1 : 0
        } else {
            buttonAlpha = isEditing == true ? 1 : 0.3
        }
        imageEditButton.isEnabled = !hasImage || isEditing
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.editImageLabel.alpha = buttonAlpha
            self.editIconImageView.alpha = buttonAlpha
            self.imageViewVision.alpha = self.isEditing ? 0.25 : 1
        }
    }
}

// MARK: - UITextViewDelegate, UITextView private extension

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        headlineTextView.attributedText = headlineTextView.text.formattedHeadline
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
        resizeTextViewsHeight()
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == headlineTextView {
            headlineTextView.attributedText = textView.text.formattedHeadline
        } else if textView == messageTextView {
            scrollToBottom()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == headlineTextView && text == "\n" {
            headlineTextView.resignFirstResponder()
            messageTextView.becomeFirstResponder()
            messageTextView.text.removeLast()
            scrollToBottom()
        }
        return true
    }

    func scrollToBottom() {
        let padding = UIDevice.isVersion10 ? Layout.padding_150 : Layout.padding_50
        let bottomPoint = CGPoint(x: 0, y: messageTextView.bounds.maxY + padding)
        scrollView.setContentOffset(bottomPoint, animated: false)
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {
    func deleteImage() {
        tempImage = nil
        tempImageURL = nil
        imageViewVision.kf.setImage(with: nil, placeholder: R.image.tbv_placeholder())
        RestartHelper.clearRestartRouteInfo()
    }

    func cancelSelection() {
        edit(true)
        RestartHelper.clearRestartRouteInfo()
    }

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        tempImage = image
        RestartHelper.clearRestartRouteInfo()
    }
}

// MARK: - NSAttributedString

private extension MyToBeVisionModel.Model {

    var formattedHeadline: NSAttributedString? {
        guard let headLine = headLine else { return nil }
        return NSAttributedString(string: headLine.uppercased(),
                                  letterSpacing: 2,
                                  font: .H1MainTitle,
                                  lineSpacing: 3,
                                  textColor: .white)
    }

    var formattedSubtitle: NSAttributedString? {
        guard
            let date = lastUpdated,
            let timeInterval = DateComponentsFormatter.timeIntervalToString(-date.timeIntervalSinceNow, isShort: true)
            else { return nil }
        let text = R.string.localized.meSectorMyWhyVisionWriteDate(timeInterval).uppercased()
        return NSAttributedString(string: text, letterSpacing: 2, font: .H7Tag, lineSpacing: 0, textColor: .white30)
    }

    var formattedVision: NSAttributedString? {
        guard let text = text else { return nil }
        return NSAttributedString(string: text,
                                  letterSpacing: -0.4,
                                  font: .DPText,
                                  lineSpacing: 10.0,
                                  textColor: .white)
    }
}

// MARK: - String

private extension String {

    var formattedHeadline: NSAttributedString? {
        return NSAttributedString(string: self.uppercased(),
                                  letterSpacing: 2,
                                  font: .H1MainTitle,
                                  lineSpacing: 3,
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
        let height = isKeyboardShowing ? keyboardFrame.height : Layout.padding_64
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        UIView.animate(withDuration: Animation.duration_06, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - TopNavigationBarDelegate

extension MyToBeVisionViewController: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        if isEditing == true {
            cancelEdit()
            toBeVisionDidUpdate()
        } else {
            AppDelegate.current.appCoordinator.tabBarCoordinator?.navigationItem(navigationItem,
                                                                                 leftButtonPressed: button)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        if isEditing == true {
            saveEdit()
        } else {
            AppDelegate.current.appCoordinator.tabBarCoordinator?.navigationItem(navigationItem,
                                                                                 rightButtonPressed: button)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}

extension MyToBeVisionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0 {
            self.imageHeightConstraint.constant = 0
        } else {
            self.imageHeightConstraint.constant = -offsetY
        }
        self.scrollView?.updateConstraints()
    }
}
