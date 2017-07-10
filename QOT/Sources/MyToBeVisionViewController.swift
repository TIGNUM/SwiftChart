//
//  MyToBeVisionViewController.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RSKImageCropper
import ImagePicker

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
    @IBOutlet weak var messageTextViewBottomConstrant: NSLayoutConstraint!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewOverlay: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    fileprivate let viewModel: MyToBeVisionViewModel
    fileprivate var imagePicker: ImagePickerController?
    fileprivate var imageTapRecogniser: UITapGestureRecognizer!
    weak var delegate: MyToBeVisionViewControllerDelegate?
    
    // MARK: - Init

    init(viewModel: MyToBeVisionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
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

        maskImageView(imageView: imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // flush height constraint change
        textViewDidChange(headlineTextView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func edit(_ isEditing: Bool) {
        if !isEditing {
            view.endEditing(true)
            configureWebView(string: messageTextView.text)
        }
        
        editButton.tintColor = isEditing ? UIColor.white40 : UIColor.white
        UIView.animate(withDuration: 0.5, animations: {
            self.messageTextView.alpha = isEditing ? 1.0 : 0.0
            self.webView.alpha = isEditing ? 0.0 : 1.0
            self.imageButton.alpha = (isEditing || self.viewModel.profileImage == nil) ? 1.0 : 0.0
        }, completion: { (_: Bool) in
            if isEditing {
                _ = self.tryFirstResponder()
            }
            self.headlineTextView.isEditable = isEditing
            self.messageTextView.isEditable = isEditing
            self.imageButton.isEnabled = isEditing
        })
    }
    
    func tryFirstResponder() -> Bool {
        if !self.headlineTextView.isFirstResponder &&
            !self.messageTextView.isFirstResponder {
            return self.headlineTextView.becomeFirstResponder()
        }
        return false
    }

    func setupView() {
        setupNavigation()
        setupLabels()
        configureWebView(string: viewModel.text)
        
        let profileImage = viewModel.profileImage
        imageView.image = profileImage
        imageButton.alpha = (profileImage == nil) ? 1.0 : 0.0
        subtitleLabel.text = viewModel.dateText
    }
    
    func setupNavigation() {
        navigationBar.topItem?.title = R.string.localized.meSectorMyWhyVisionTitle()
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: Font.H6NavigationTitle
        ]
        let dummyImage = UIImage()
        navigationBar.setBackgroundImage(dummyImage, for: .default)
        navigationBar.shadowImage = dummyImage
        navigationBar.isTranslucent = true
    }

    func setupLabels() {
        //TODO: lee localise
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
        headlineTextView.set(placeholderText: "Your Headline", placeholdeColor: UIColor.white)
        
        messageTextView.placeholderDelegate = self
        messageTextView.attributedText = NSMutableAttributedString(
            string: viewModel.text ?? "",
            letterSpacing: -0.4,
            font: UIFont(name: "BentonSans-Book", size: 16)!,
            lineSpacing: 10.0,
            textColor: UIColor.white)
        messageTextView.set(placeholderText: "Your vision - what inspires you?", placeholdeColor: UIColor.white)
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = UIEdgeInsets(top: 14.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        subtitleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.subHeadline?.uppercased() ?? "",
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 0)
    }

    func maskImageView(imageView: UIImageView) {
        let clippingBorderPath = UIBezierPath()
        clippingBorderPath.move(to: CGPoint(x: 0, y: 56))
        clippingBorderPath.addCurve(
            to: CGPoint(x: view.bounds.size.width, y: 56),
            controlPoint1: CGPoint(x: view.bounds.size.width/2 - 50, y: 5),
            controlPoint2: CGPoint(x: view.bounds.size.width/2 + 50, y: 5)
        )
        clippingBorderPath.addLine(to: CGPoint(x:  view.bounds.size.width, y: view.bounds.size.height + 15))
        clippingBorderPath.addLine(to: CGPoint(x:  0, y: view.bounds.size.height + 15))
        clippingBorderPath.close()

        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        imageViewOverlay.layer.mask = borderMask
    }

    func configureWebView(string: String?) {
        let format = "<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\"></head>" + "<body style='background:none'><div class='text'>%@</div></body></html>"
        var text: String
        if let string = string, !string.isEmpty {
            text = String(format: format, arguments: [string])
        } else {
            // TODO: lee localise
            text = String(format: format, arguments: ["Your vision - what inspires you?"])
        }
        
        let mainbundle = Bundle.main.bundlePath
        let bundleURL = NSURL(fileURLWithPath: mainbundle)
        webView.loadHTMLString(text, baseURL: bundleURL as URL)
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.scrollView.contentInset.right = 230
        webView.scrollView.contentInset.left = 21
        webView.scrollView.delegate = self
    }
}

// MARK: - Actions

extension MyToBeVisionViewController {

    @IBAction func closeAction(_ sender: Any) {
        delegate?.didTapClose(in: self)
    }
    
    @IBAction func editTapped(_ sender: Any) {
        edit()
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        present(imagePicker, animated: true, completion: nil)
        self.imagePicker = imagePicker
    }
}

// MARK: - Notifications 

extension MyToBeVisionViewController {
    func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo, let rect = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            return
        }
        messageTextViewBottomConstrant.constant = rect.height
        messageTextView.layoutIfNeeded()
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        messageTextViewBottomConstrant.constant = 0
        messageTextView.layoutIfNeeded()
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
        } else if textView == messageTextView {
            viewModel.updateText(messageTextView.text)
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
            headlineTextView.layoutIfNeeded()
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

extension MyToBeVisionViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        return
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard let selectedImage = images.first else {
            return
        }
        
        let imageCropper = RSKImageCropViewController(image: selectedImage)
        imageCropper.delegate = self
        imageCropper.dataSource = self
        imageCropper.cropMode = .custom
        imagePicker.dismiss(animated: false, completion: nil)
        present(imageCropper, animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RSKImageCropViewControllerDelegate

extension MyToBeVisionViewController: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        imagePicker?.dismiss(animated: false, completion: nil)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        imagePicker?.dismiss(animated: false, completion: nil)
        controller.dismiss(animated: true, completion: nil)
        
        let error = viewModel.updateProfileImage(croppedImage)
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
        
        imageView.image = croppedImage
    }
}

// MARK: - RSKImageCropViewControllerDataSource

extension MyToBeVisionViewController: RSKImageCropViewControllerDataSource {
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return CGRect(x: (view.frame.width - 250) * 0.5, y: (view.frame.height - 250) * 0.5, width: 250, height: 250)
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath.circlePath(center: view.center, radius: view.bounds.width / 4.0)
    }
}
