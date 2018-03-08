//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class MyToBeVisionViewController: UIViewController, MyToBeVisionViewControllerInterface {

    // MARK: - Properties

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var minimiseButton: UIBarButtonItem!
    @IBOutlet weak var headlineTextView: PlaceholderTextView!
    @IBOutlet weak var headlineConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: PlaceholderTextView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageButton: UIButton! // FIXME: Make UIImageView
    @IBOutlet weak var imageEditLabel: UILabel!
    @IBOutlet weak var circleContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    private var imagePickerController: ImagePickerController!
    private var imageTapRecogniser: UITapGestureRecognizer!

    private var toBeVision: MyToBeVisionModel.Model?
    var interactor: MyToBeVisionInteractor?
    var router: MyToBeVisionRouter?
    var permissionsManager: PermissionsManager!

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        gradientView.layer.addSublayer(layer)
        return layer
    }()

    // MARK: - Init

    init(configurator: Configurator<MyToBeVisionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
        imagePickerController = ImagePickerController(cropShape: .circle,
                                                      imageQuality: .low,
                                                      imageSize: .small,
                                                      permissionsManager: permissionsManager)
        imagePickerController.delegate = self
        imageTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(imageButtonPressed(_:)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.viewDidLoad()
        setupView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setupMessageTextGradientLayer()
        maskImageView(imageView: imageView)
        drawCircles()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if messageTextView.contentInset.bottom == 0 {
            messageTextView.contentInset.bottom = imageViewContainer.bounds.height
        }

        if headlineTextView.numberOfLines > 1 {
            headlineTextView.flashScrollIndicators()
        }

        headlineTextView.setContentOffset(.zero, animated: false)
        setHeadlineHeight()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startObservingKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBeingDismissed == true {
            edit(false)
        }
        stopObservingKeyboard()
    }

    // MARK: - Internal

    func edit() {
        isEditing = !isEditing
        edit(isEditing)
    }

    // MARK: - MyToBeVision View Contoller Interface

    func setup(with toBeVision: MyToBeVisionModel.Model) {
        self.toBeVision = toBeVision
        toBeVisionDidUpdate()
    }

    func update(with toBeVision: MyToBeVisionModel.Model) {
        if toBeVision != self.toBeVision {
            self.toBeVision = toBeVision
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

// MARK: - Private drawing

private extension MyToBeVisionViewController {

    func drawCircles() {
        // FIXME: We should try to avoid removing sublayers
        circleContainerView.removeSubLayers()
        var center = view.center; center.x *= 0.2; center.y *= 1.1
        let circleLayer1 = CAShapeLayer.circle(center: center,
                                               radius: view.bounds.width * 0.55,
                                               fillColor: .clear,
                                               strokeColor: .whiteLight8)
        circleLayer1.lineDashPattern = [1, 2]
        circleContainerView.layer.addSublayer(circleLayer1)
        let circleLayer2 = CAShapeLayer.circle(center: center,
                                               radius: view.bounds.width * 0.9,
                                               fillColor: .clear,
                                               strokeColor: .whiteLight8)
        circleContainerView.layer.addSublayer(circleLayer2)
    }

    func maskImageView(imageView: UIImageView) {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 0, y: 56))
        clippingBorderPath.addCurve(to: CGPoint(x: view.bounds.size.width, y: 56),
                                    controlPoint1: CGPoint(x: view.bounds.size.width/2 - 50, y: 0),
                                    controlPoint2: CGPoint(x: view.bounds.size.width/2 + 50, y: 0))
        clippingBorderPath.addLine(to: CGPoint(x: view.bounds.size.width, y: view.bounds.size.height + 30))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: view.bounds.size.height + 30))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        imageView.layer.mask = borderMask
    }
}

// MARK: - Setup

private extension MyToBeVisionViewController {

    func setupView() {
        setupNavigation()
        setupLabels()
        syncImageControls(animated: false)
        imageView.addGestureRecognizer(imageTapRecogniser)
        editButton.tintColor = .white40
    }

    func setupNavigation() {
        navigationBar.topItem?.title = R.string.localized.meSectorMyWhyVisionTitle().uppercased()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: Font.H6NavigationTitle]
        let dummyImage = UIImage()
        navigationBar.setBackgroundImage(dummyImage, for: .default)
        navigationBar.shadowImage = dummyImage
        navigationBar.isTranslucent = true
    }

    func setupLabels() {
        setupHeadlineText(editing: false)
        setupMessageText(editing: false)
        imageEditLabel.font = Font.DPText
        imageEditLabel.textColor = .white
    }

    func setupHeadlineText(editing: Bool) {
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.alpha = 1
        headlineTextView.set(placeholderText: R.string.localized.meSectorMyWhyVisionHeadlinePlaceholder().uppercased(),
                             placeholdeColor: .white)
        headlineTextView.textContainer.lineFragmentPadding = 0
        setHeadlineHeight()
    }

    func setupMessageText(editing: Bool) {
        messageTextView.alpha = 1
        messageTextView.set(placeholderText: R.string.localized.meSectorMyWhyVisionMessagePlaceholder(),
                            placeholdeColor: .white)
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 10.0, right: 0.0)
    }

    func setupMessageTextGradientLayer() {
        gradientLayer.frame = gradientView.frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.2)
    }
}

// MARK: - Sync

private extension MyToBeVisionViewController {

    func toBeVisionDidUpdate() {
        if headlineTextView.attributedText != toBeVision?.formattedHeadline {
            headlineTextView.attributedText = toBeVision?.formattedHeadline
        }
        if messageTextView.attributedText != toBeVision?.formattedVision {
            messageTextView.attributedText = toBeVision?.formattedVision
        }

        subtitleLabel.attributedText = toBeVision?.formattedSubtitle
        imageView.kf.setImage(with: toBeVision?.imageURL)
    }

    func syncImageControls(animated: Bool) {
        let hasImage = toBeVision?.imageURL != nil
        imageView.isHidden = !hasImage
        imageViewPlaceholder.isHidden = hasImage
        let buttonAlpha: CGFloat
        if hasImage {
            buttonAlpha = isEditing == true ? 1 : 0
        } else {
            buttonAlpha = isEditing == true ? 1 : 0.3
        }
        imageTapRecogniser.isEnabled = !hasImage || isEditing
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.imageButton.alpha = buttonAlpha
            self.imageEditLabel.alpha = buttonAlpha
            self.imageView.alpha = self.isEditing ? 0.25 : 1
        }
    }

    func edit(_ isEditing: Bool) {
        self.isEditing = isEditing
        headlineTextView.isEditable = isEditing
        messageTextView.isEditable = isEditing
        editButton.tintColor = isEditing ? .white : .white40
        setupMessageText(editing: isEditing)
        syncImageControls(animated: true)
    }
}

// MARK: - Actions

private extension MyToBeVisionViewController {

    @IBAction func closeAction(_ sender: Any) {
        saveToBeVisison()
        router?.close()
    }

    @IBAction func editTapped(_ sender: Any) {
        edit()
    }

    @IBAction func imageButtonPressed(_ sender: UIButton) {
        imagePickerController.show(in: self)
    }

    private func saveToBeVisison() {
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
}

// MARK: - Notifications 

extension MyToBeVisionViewController {

    override internal func keyboardWillAppear(notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        messageTextView.contentInset.bottom = rect.height
    }

    override internal func keyboardWillDisappear(notification: NSNotification) {
        messageTextView.contentInset.bottom = imageViewContainer.bounds.height
        messageTextView.setContentOffset(.zero, animated: true)
        headlineTextView.setContentOffset(.zero, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isEditing == false {
            edit()
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        // FIXME: The textView should update itself!
        if let textView = textView as? PlaceholderTextView {
            textView.didBeginEditing()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // FIXME: The textView should update itself!
        if let textView = textView as? PlaceholderTextView {
            textView.didEndEditing()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == headlineTextView, text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == headlineTextView {
            setHeadlineHeight()
        }
    }

    func setHeadlineHeight() {
        headlineConstraint.constant = headlineTextView.numberOfLines() == 1 ? 50 : 100
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        guard let toBeVision = toBeVision else { return }

        interactor?.updateToBeVisionImage(image: image, toBeVision: toBeVision)
        toBeVisionDidUpdate()
    }
}

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

// MARK: - UITextView private

private extension UITextView {

    func numberOfLines() -> Int {
        if let fontUnwrapped = self.font {
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}
