//
//  PartnersViewController.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import iCarousel
import RSKImageCropper
import ImagePicker

protocol PartnersViewControllerDelegate: class {
    func didTapChangeImage(at index: Index)
}

class PartnersViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate weak var bigLabel: UILabel!
    @IBOutlet fileprivate weak var carousel: iCarousel! = iCarousel()
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    fileprivate let viewModel: PartnersViewModel
    fileprivate var imagePicker: ImagePickerController?
    fileprivate var valueEditing: Bool = false
    weak var delegate: PartnersViewControllerDelegate?

    // MARK: - Init

    init(viewModel: PartnersViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setupCarousel()
        setupHeadline()
    }
}

// MARK: - Private

private extension PartnersViewController {

    func setBackgroundColor() {
        view.backgroundColor = .clear
        scrollView.backgroundColor = .clear
    }

    func setupHeadline() {
        bigLabel.attributedText = NSMutableAttributedString(
            string: viewModel.headline,
            letterSpacing: 2,
            font: Font.H1MainTitle,
            alignment: .left
        )
        bigLabel.text = R.string.localized.meSectorMyWhyPartnersHeader()
    }

    func setupCarousel() {
        carousel.type = .linear
        carousel.isPagingEnabled = true
        carousel.contentOffset = CGSize(width: -64, height: 0)
        viewModel.updateIndex(index: carousel.currentItemIndex)
    }

    func scrollAnimated(topInset: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.top = topInset
        }
    }
}

// MARK: - Actions

extension PartnersViewController {

    func editCurrentItem() {
        if valueEditing == true {
            stopEditing()
        } else {
            startEditing()
        }
    }
    
    func startEditing() {
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }
        valueEditing = true
        viewModel.updateIndex(index: carousel.currentItemIndex)
        view.edit(isEnabled: true)
    }
    
    func stopEditing() {
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }
        valueEditing = false
        view.update(viewModel: viewModel)
        view.edit(isEnabled: false)
        carousel.reloadItem(at: carousel.currentItemIndex, animated: false) // flush ui changes
        scrollAnimated(topInset: 0)
        view.hideKeyboard()
    }
}

// MARK: - iCarousel

extension PartnersViewController: iCarouselDataSource, iCarouselDelegate {

    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.itemCount
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let frame = CGRect(x: carousel.frame.origin.x, y: carousel.frame.origin.y, width: 186.0, height: 424.0)
        let view = CarouselCellView(frame: frame)
        let item = viewModel.item(at: index)
        view.setViewsTextFieldsDelegate(delegate: self)
        view.partnersViewControllerDelegate = self
        view.setup(with: item?.name,
                   surename: item?.surname,
                   email: item?.email,
                   relationship: item?.relationship,
                   initials: item?.initials,
                   profileImageResource: item?.profileImageResource)
        return view
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return option == .spacing ? value * 1.1 : value
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        viewModel.updateIndex(index: carousel.currentItemIndex)
    }
    
    func carouselDidEndDecelerating(_ carousel: iCarousel) {
        // FIXME: seems like iCarousel dismisses keyboard on each right swipe. so if we're editing, we bring the keyboard back up by triggering startEditing() again
        if valueEditing {
            startEditing()
        }
    }
}

// MARK: - UITextFieldDelegate

extension PartnersViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollAnimated(topInset: -120)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollAnimated(topInset: 0)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if valueEditing == true {
            stopEditing()
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if valueEditing == false {
            startEditing()
        }
        return true
    }
}

// MARK: - PartnersViewControllerDelegate

extension PartnersViewController: PartnersViewControllerDelegate {

    func didTapChangeImage(at index: Index) {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
        present(imagePicker, animated: true, completion: nil)
        self.imagePicker = imagePicker
    }

    private func presentImagePicker(for type: UIImagePickerControllerSourceType) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

// MARK: - ImagePickerDelegate

extension PartnersViewController: ImagePickerDelegate {

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

extension PartnersViewController: RSKImageCropViewControllerDelegate {

    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        imagePicker?.dismiss(animated: false, completion: nil)
        controller.dismiss(animated: true, completion: nil)
    }

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        imagePicker?.dismiss(animated: false, completion: nil)
        controller.dismiss(animated: true, completion: nil)
      
        let error = viewModel.updateProfileImage(image: croppedImage)
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
        
        viewModel.save()
        carousel.reloadData()
    }
}

// MARK: - RSKImageCropViewControllerDataSource

extension PartnersViewController: RSKImageCropViewControllerDataSource {

    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return CGRect(x: (view.frame.width - 250) * 0.5, y: (view.frame.height - 250) * 0.5, width: 250, height: 250)
    }

    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }

    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath.hexagonPath(forRect: controller.maskRect)
    }
}

// MARK: - CustomPresentationAnimatorDelegate

extension PartnersViewController: CustomPresentationAnimatorDelegate {
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        scrollView.transform = animator.isPresenting ? CGAffineTransform(translationX: 0.0, y: 100.0) : .identity
        parent?.view.alpha = animator.isPresenting ? 0.0 : 1.0
        return { [unowned self] in
            self.scrollView.transform = animator.isPresenting ? .identity : CGAffineTransform(translationX: 0.0, y: 100.0)
            self.parent?.view.alpha = animator.isPresenting ? 1.0 : 0.0
        }
    }
}
