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
    weak var topTabBarScrollViewDelegate: TopTabBarScrollViewDelegate?

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
    }

    func setupCarousel() {
        carousel.type = .linear
        carousel.isPagingEnabled = true
        carousel.contentOffset = CGSize(width: -64, height: 0)
        scrollView.delegate = self
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
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }

        if valueEditing == true {
            valueEditing = false
            view.update(viewModel: viewModel)
            view.edit(isEnabled: false)
            scrollAnimated(topInset: 0)
            view.hideKeyboard()
        } else {
            valueEditing = true
            view.edit(isEnabled: true)
        }
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
        view.setup(with: item.name,
                   surename: item.surename,
                   email: item.email,
                   relationship: item.relationship,
                   initials: item.initials,
                   profileImage: item.profileImage
        )

        return view
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {

        return option == .spacing ? value * 1.1 : value
    }

    func carouselWillBeginDragging(_ carousel: iCarousel) {
        if valueEditing == true {
            guard let view = carousel.currentItemView as? CarouselCellView else {
                return
            }

            view.edit(isEnabled: false)
            view.update(viewModel: viewModel)
            view.hideKeyboard()
            scrollAnimated(topInset: 0)
        }
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if valueEditing == true {
            guard let view = carousel.currentItemView as? CarouselCellView else {
                return
            }

            view.edit(isEnabled: true)
        }
    }

    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }

        view.hideKeyboard()
        scrollAnimated(topInset: 0)
    }
}

// MARK: - UIScrollViewDelegate

extension PartnersViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.didScrollUnderTopTabBar(delegate: topTabBarScrollViewDelegate)
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
        textField.resignFirstResponder()
        scrollAnimated(topInset: 0)
        return false
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
        viewModel.updateProfileImage(image: croppedImage)
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
        return UIBezierPath.roundedPolygonPath(rect: controller.maskRect, lineWidth: 0, sides: 6, rotationOffset: CGFloat(CGFloat.pi * 0.5))
    }
}
