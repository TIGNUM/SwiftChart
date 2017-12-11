//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RSKImageCropper
import Kingfisher
import Anchorage

protocol MyToBeVisionViewControllerDelegate: class {

    func didTapClose(in viewController: MyToBeVisionViewController)
}

class MyToBeVisionViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var minimiseButton: UIBarButtonItem!
    @IBOutlet weak var headlineTextView: PlaceholderTextView!
    @IBOutlet weak var headlineTextViewHightConstrant: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: PlaceholderTextView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewPlaceholder: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageEditLabel: UILabel!
    @IBOutlet weak var circleContainerView: UIView!
    @IBOutlet weak var gradientView: UIView!
    private let imagePickerController: ImagePickerController
    private var imageTapRecogniser: UITapGestureRecognizer!
    let viewModel: MyToBeVisionViewModel
    weak var delegate: MyToBeVisionViewControllerDelegate?

    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.gradientView.layer.addSublayer(layer)
        return layer
    }()

    // MARK: - Init

    init(viewModel: MyToBeVisionViewModel, permissionsManager: PermissionsManager) {
        self.viewModel = viewModel
        imagePickerController = ImagePickerController(cropShape: .circle, imageQuality: .low, imageSize: .small, permissionsManager: permissionsManager)

        super.init(nibName: nil, bundle: nil)

        imagePickerController.delegate = self
        imageTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(imageButtonPressed(_:)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

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

        textViewDidChange(headlineTextView) // flush height constraint change

        if messageTextView.contentInset.bottom == 0 {
            messageTextView.contentInset.bottom = imageViewContainer.bounds.height
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBeingDismissed {
            edit(false)
        }
        tearDownNotifications()
    }

    // MARK: - Internal

    func edit() {
        isEditing = !isEditing
        edit(isEditing)
    }
}

// MARK: - Private

private extension MyToBeVisionViewController {

    func drawCircles() {
        let color = UIColor(white: 1, alpha: 0.08)
        circleContainerView.removeSubLayers()
        var center = view.center; center.x *= 0.2; center.y *= 1.1
        let circleLayer1 = CAShapeLayer.circle(
            center: center,
            radius: view.bounds.width * 0.55,
            fillColor: .clear,
            strokeColor: color
        )
        circleLayer1.lineDashPattern = [1, 2]
        circleContainerView.layer.addSublayer(circleLayer1)

        let circleLayer2 = CAShapeLayer.circle(
            center: center,
            radius: view.bounds.width * 0.9,
            fillColor: .clear,
            strokeColor: color
        )
        circleContainerView.layer.addSublayer(circleLayer2)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func edit(_ isEditing: Bool) {
        headlineTextView.isEditable = isEditing
        messageTextView.isEditable = isEditing
        editButton.tintColor = isEditing ? .white : .white40
        imageView.alpha = isEditing ? 0.25 : 1.0
        setupMessageText(editing: isEditing)

        UIView.animate(withDuration: 0.5) {
            self.setImageButton(isEditing: isEditing)
        }
    }

    func setupView() {
        setupNavigation()
        setupLabels()
        messageTextView.delegate = self
        messageTextView.returnKeyType = .done
        messageTextView.tintColor = .white
        headlineTextView.tintColor = .white

        if let profileImageResource = viewModel.profileImageResource {
            imageView.setImageFromResource(profileImageResource)
        }

        setImageButton(isEditing: false)
        imageView.addGestureRecognizer(imageTapRecogniser)
        editButton.tintColor = .white40
    }

    func setImageButton(isEditing: Bool) {
        if imageView.image == nil {
            imageViewPlaceholder.isHidden = false
            imageButton.alpha = isEditing == true ? 1 : 0.3
            imageButton.isEnabled = true
            imageEditLabel.alpha = isEditing == true ? 1 : 0.3
            imageTapRecogniser.isEnabled = true
        } else {
            imageViewPlaceholder.isHidden = true
            imageButton.alpha = isEditing == true ? 1 : 0
            imageButton.isEnabled = isEditing == true
            imageEditLabel.alpha = isEditing == true ? 1 : 0
            imageTapRecogniser.isEnabled = isEditing
        }
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
        headlineTextView.autocapitalizationType = .allCharacters
        headlineTextView.placeholderDelegate = self
        headlineTextView.attributedText = NSMutableAttributedString(
            string: viewModel.headline?.uppercased() ?? "",
            letterSpacing: 2,
            font: Font.H1MainTitle,
            lineSpacing: 3.0,
            textColor: UIColor.white)
        headlineTextView.textContainer.maximumNumberOfLines = 2
        headlineTextView.textContainer.lineFragmentPadding = 0
        headlineTextView.textContainerInset = .zero
        headlineTextView.set(placeholderText: R.string.localized.meSectorMyWhyVisionHeadlinePlaceholder(), placeholdeColor: UIColor.white)

        setupMessageText(editing: false)

        subtitleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.dateText,
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 0,
            textColor: .white30)

        imageEditLabel.font = Font.DPText
        imageEditLabel.textColor = .white
    }

    func setupMessageTextGradientLayer() {

        gradientLayer.frame = gradientView.frame
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0.2)
    }

    func setupMessageText(editing: Bool) {
        messageTextView.alpha = 1
        messageTextView.placeholderDelegate = self
        messageTextView.attributedText = NSMutableAttributedString(
            string: viewModel.text ?? (editing ? "" : R.string.localized.meSectorMyWhyVisionMessagePlaceholder()),
            letterSpacing: -0.4,
            font: Font.DPText,
            lineSpacing: 10.0,
            textColor: UIColor.white)
        messageTextView.set(placeholderText: R.string.localized.meSectorMyWhyVisionMessagePlaceholder(), placeholdeColor: UIColor.white)
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 10.0, right: 0.0)
    }

    func maskImageView(imageView: UIImageView) {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 0, y: 56))
        clippingBorderPath.addCurve(
            to: CGPoint(x: view.bounds.size.width, y: 56),
            controlPoint1: CGPoint(x: view.bounds.size.width/2 - 50, y: 0),
            controlPoint2: CGPoint(x: view.bounds.size.width/2 + 50, y: 0)
        )
        clippingBorderPath.addLine(to: CGPoint(x: view.bounds.size.width, y: view.bounds.size.height + 30))
        clippingBorderPath.addLine(to: CGPoint(x: 0, y: view.bounds.size.height + 30))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        imageView.layer.mask = borderMask
    }
}

// MARK: - Actions

private extension MyToBeVisionViewController {

    @IBAction func closeAction(_ sender: Any) {
        delegate?.didTapClose(in: self)
    }

    @IBAction func editTapped(_ sender: Any) {
        edit()
    }

    @IBAction func imageButtonPressed(_ sender: UIButton) {
        imagePickerController.show(in: self)
    }
}

// MARK: - Notifications 

private extension MyToBeVisionViewController {

    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard
            let userInfo = notification.userInfo,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        messageTextView.contentInset.bottom = rect.height
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        messageTextView.contentInset.bottom = imageViewContainer.bounds.height
        messageTextView.contentOffset = .zero
    }
}

// MARK: - UITextViewDelegate

extension MyToBeVisionViewController: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if !isEditing {
            edit()
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if let textView = textView as? PlaceholderTextView {
            textView.didBeginEditing()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == headlineTextView {
            viewModel.updateHeadline(headlineTextView.text)
            setupLabels()
        } else if textView == messageTextView {
            viewModel.updateText(messageTextView.text)
            setupLabels()
        }
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
        if textView == headlineTextView, let font = textView.font {
            let numOfLines = floorf(Float(textView.contentSize.height / font.lineHeight))
            if numOfLines == 1 {
                headlineTextViewHightConstrant.constant = 50
            } else if numOfLines == 2 {
                headlineTextViewHightConstrant.constant = 100
            }
            view.layoutIfNeeded()
        } else if textView == messageTextView, textView.text.count >= 1 {
            if textView.text.first(where: {$0 == "\n"}) != nil {
                textView.text = textView.text.replacingOccurrences(of: "\n", with: "")
                textView.resignFirstResponder()
            }
        }
    }
}

// MARK: - MyToBeVisionViewController: Place

extension MyToBeVisionViewController: PlaceholderTextViewDelegate {

    func placeholderDidChange(_ placeholderTextView: PlaceholderTextView) {
        textViewDidChange(placeholderTextView)
    }
}

// MARK: - UIScrollViewDelegate

extension MyToBeVisionViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == headlineTextView, scrollView.contentOffset.y > 0 {
            scrollView.contentOffset = .zero
        }
    }
}

// MARK: - ImagePickerDelegate

extension MyToBeVisionViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        let error = viewModel.updateProfileImage(image)
        guard error == nil else {
            let alertController = UIAlertController(
                title: R.string.localized.meSectorMyWhyPartnersPhotoErrorTitle(),
                message: R.string.localized.meSectorMyWhyPartnersPhotoErrorMessage(),
                preferredStyle: .alert)
            let alertAction = UIAlertAction(
                title: R.string.localized.meSectorMyWhyPartnersPhotoErrorOKButton(),
                style: .default)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return
        }

        imageView.image = image
        setupLabels()
        setImageButton(isEditing: isEditing)
    }
}
