//
//  PartnersViewController.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import iCarousel

protocol PartnersViewControllerDelegate: class {
    func didTapClose(in viewController: UIViewController, animated: Bool)
    func didTapChangeImage(at index: Index, in viewController: UIViewController)
}

class PartnersViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UIScrollViewDelegate, UITextFieldDelegate {

    // MARK: - Properties

    @IBOutlet private weak var bigLabel: UILabel!
    @IBOutlet weak var carousel: iCarousel! = iCarousel()
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate let viewModel: PartnersViewModel
    weak var delegate: PartnersViewControllerDelegate?
    var valueEditing: Bool = false

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
        carousel.type = .linear
        carousel.isPagingEnabled = true
        carousel.contentOffset = CGSize(width: -65, height: 0)

        bigLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.headline, letterSpacing: 2, font: UIFont(name:"Simple-Regular", size: 36.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.left)
    }

    func prepareAndSetTextAttributes(string: String, letterSpacing: CGFloat, font: UIFont?, lineSpacing: CGFloat, paragraphStyleAlignemnt: NSTextAlignment?) -> NSMutableAttributedString {
        let defaultFont: UIFont = UIFont(name:"Simple-Regular", size: 14.0)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = paragraphStyleAlignemnt!
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttributes([NSFontAttributeName: font ?? defaultFont], range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }

    @IBAction func editCurrentItem(_ sender: Any) {
        guard let view = carousel.currentItemView as? CarouselCellView else {
            return
        }
        if valueEditing {
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

    func scrollAnimated(topInset: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.top = topInset
        }
    }
}
extension PartnersViewController {

    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.itemCount
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = CarouselCellView(frame: CGRect(x: carousel.frame.origin.x, y: carousel.frame.origin.y, width: 186.0, height: 424.0))
        view.setViewsTextFieldsDelegate(delegate: self)

        view.imageView.image = viewModel.item(at: index).profileImage
        view.textFieldName.attributedText = prepareAndSetTextAttributes(string: viewModel.item(at: index).name.uppercased(), letterSpacing: -1.1, font: UIFont(name:"Simple-Regular", size: 24.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.left)

        view.textFieldSurname.attributedText = prepareAndSetTextAttributes(string: viewModel.item(at: index).surename.uppercased(), letterSpacing: -1.1, font: UIFont(name:"Simple-Regular", size: 24.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.left)

        view.textFieldMail.attributedText = prepareAndSetTextAttributes(string: viewModel.item(at: index).email, letterSpacing: 0, font: UIFont(name:"BentonSans-Book", size: 12.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.left)

        view.textFieldSubtitle.attributedText = prepareAndSetTextAttributes(string: viewModel.item(at: index).relationship.uppercased(), letterSpacing: 2, font: UIFont(name:"BentonSans", size: 11.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.left)

        view.initialsLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.item(at: index).initials.uppercased(), letterSpacing: 2, font: UIFont(name:"Simple-Regular", size: 36.0), lineSpacing: 0, paragraphStyleAlignemnt: NSTextAlignment.center)

        return view
    }

    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {

        return option == .spacing ? value * 1.1 : value
    }

    func carouselWillBeginDragging(_ carousel: iCarousel) {
        if valueEditing {
            guard let view: CarouselCellView = carousel.currentItemView as? CarouselCellView else {
                return
            }
            view.edit(isEnabled: false)
            view.update(viewModel: viewModel)
            view.hideKeyboard()
            scrollAnimated(topInset: 0)
        }
    }

    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if valueEditing {
            guard let view: CarouselCellView = carousel.currentItemView as? CarouselCellView else {
                return
            }
            view.edit(isEnabled: true)
        }
    }

    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        guard let view: CarouselCellView = carousel.currentItemView as? CarouselCellView else {
            return
        }
        view.hideKeyboard()
        scrollAnimated(topInset: 0)
    }

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
