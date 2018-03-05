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

final class PartnersViewController: UIViewController, PartnersViewControllerInterface, PageViewControllerNotSwipeable {

    // MARK: - Properties

    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var bigLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var carousel: iCarousel! = iCarousel()
    @IBOutlet weak var scrollView: UIScrollView!
    private var valueEditing: Bool = false
    private var editButton: UIBarButtonItem? {
        return navigationItem.rightBarButtonItem
    }
    private var partners: [Partners.Partner] = []
    private var selectedIndex: Int = 0
    var interactor: PartnersInteractorInterface?
    var imagePickerController: ImagePickerController?

    // MARK: - Init

    init(configure: Configurator<PartnersViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        leftButton.target = self
        leftButton.action = #selector(didTapClose(_ :))
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(withImage: R.image.ic_edit())
        rightButton.target = self
        rightButton.action = #selector(didTapEdit(_ :))
        navigationItem.rightBarButtonItem = rightButton

        interactor?.viewDidLoad()
        setBackgroundColor()
        setupCarousel()
        setupHeadline()

        editButton?.tintColor = .white40
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        syncShareButton()
    }

    func setup(partners: [Partners.Partner]) {
        self.partners = partners
        carousel.reloadData()
    }

    func reload(partner: Partners.Partner) {
        guard let index = partners.index(where: { $0.localID == partner.localID }) else {
            assertionFailure("Trying to reload a partner that doesn't exist.")
            return
        }
        carousel.reloadItem(at: index, animated: false)
    }
}

// MARK: - Private

private extension PartnersViewController {

    @objc private func didTapClose(_ sender: UIBarButtonItem) {
        interactor?.didTapClose(partners: partners)
    }

    @objc private func didTapEdit(_ sender: UIBarButtonItem) {
        editCurrentItem()
    }

    var selectedPartner: Partners.Partner {
        return partners[selectedIndex]
    }

    func syncShareButton() {
        let partnersAvailable = selectedPartner.email?.isEmpty == false && selectedPartner.name?.isEmpty == false
        shareButton.isHidden = !partnersAvailable
    }

    func setBackgroundColor() {
        backgroundImageView.image = R.image._1Learn()
        view.addFadeView(at: .top)
        scrollView.backgroundColor = .clear
    }

    func setupHeadline() {
        bigLabel.attributedText = NSMutableAttributedString(
            string: R.string.localized.meSectorMyWhyPartnersHeader(),
            letterSpacing: 2,
            font: Font.H1MainTitle,
            alignment: .left
        )
    }

    func setupCarousel() {
        carousel.type = .linear
        carousel.isPagingEnabled = true
        carousel.contentOffset = CGSize(width: -Layout.TabBarView.height, height: 0)
        selectedIndex = carousel.currentItemIndex
    }

    func scrollAnimated(topInset: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.top = topInset
        }
    }

    func showShareView() {
        interactor?.didTapShare(partner: selectedPartner)
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
        selectedIndex = carousel.currentItemIndex
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
        view.edit(isEnabled: false)
        carousel.reloadItem(at: carousel.currentItemIndex, animated: false) // flush ui changes
        scrollAnimated(topInset: 0)
        view.hideKeyboard()
    }

    @IBAction private func shareButtonTapped(_ sender: UIButton) {
        showShareView()
    }
}

// MARK: - iCarousel

extension PartnersViewController: iCarouselDataSource, iCarouselDelegate {

    func numberOfItems(in carousel: iCarousel) -> Int {
        return partners.count
    }

    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = (view as? CarouselCellView) ?? CarouselCellView()
        view.frame = CGRect(x: carousel.frame.origin.x, y: carousel.frame.origin.y, width: 186.0, height: 424.0)
        let item = partners.item(at: index)
        view.setViewsTextFieldsDelegate(delegate: self)
        view.delegate = self
        view.configure(partner: item)
        return view
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        return option == .spacing ? value * 1.1 : value
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        selectedIndex = carousel.currentItemIndex
        syncShareButton()
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
        syncShareButton()
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

// MARK: - ImagePickerDelegate

extension PartnersViewController: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        let partner = partners[selectedIndex]
        interactor?.updateImage(image, partner: partner)
        carousel.reloadData()
    }
}

extension PartnersViewController: CarouselCellViewDelegate {

    func didTapChangePicture(cell: CarouselCellView) {
        imagePickerController?.show(in: self)
    }
}
