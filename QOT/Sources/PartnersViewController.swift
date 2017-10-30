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

protocol PartnersViewControllerDelegate: class {
    func didTapChangeImage(at index: Index)
}

class PartnersViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate weak var bigLabel: UILabel!
    @IBOutlet fileprivate weak var carousel: iCarousel! = iCarousel()
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate let viewModel: PartnersViewModel
    fileprivate let imagePickerController: ImagePickerController
    fileprivate var valueEditing: Bool = false
    fileprivate var editButton: UIBarButtonItem? {
        return navigationController?.navigationBar.topItem?.rightBarButtonItem
    }
    weak var delegate: PartnersViewControllerDelegate?
    
    // MARK: - Init

    init(viewModel: PartnersViewModel, permissionHandler: PermissionHandler) {
        self.viewModel = viewModel
        imagePickerController = ImagePickerController(cropShape: .hexagon, imageQuality: .low, imageSize: .small, permissionHandler: permissionHandler)

        super.init(nibName: nil, bundle: nil)

        imagePickerController.delegate = self
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
        view.applyFade()
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
        carousel.contentOffset = CGSize(width: -Layout.TabBarView.height, height: 0)
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
        editButton?.tintColor = .white
        valueEditing = true
        title = R.string.localized.meSectorMyWhyPartnersEditTitle()
        bigLabel.text = nil
        viewModel.updateIndex(index: carousel.currentItemIndex)
        view.edit(isEnabled: true)
    }
    
    func stopEditing() {
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }
        editButton?.tintColor = .white40
        valueEditing = false
        title = R.string.localized.meSectorMyWhyPartnersTitle()
        bigLabel.text = R.string.localized.meSectorMyWhyPartnersHeader()
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
        scrollAnimated(topInset: -120.0)
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
        imagePickerController.show(in: self)
    }
}

// MARK: - ImagePickerDelegate

extension PartnersViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        let error = viewModel.updateProfileImage(image: image)
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
