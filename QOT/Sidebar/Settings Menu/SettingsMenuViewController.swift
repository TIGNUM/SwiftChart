//
//  SettingsMenuViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import Kingfisher

protocol SettingsMenuViewControllerDelegate: class {
    func didTapGeneral(in viewController: SettingsMenuViewController)
    func didTapNotifications(in viewController: SettingsMenuViewController)
    func didTapSecurity(in viewController: SettingsMenuViewController)
}

final class SettingsMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgeView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!

    @IBOutlet weak var generalButton: UIButton!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var securityButton: UIButton!

    private let disposeBag = DisposeBag()
    fileprivate let viewModel: SettingsMenuViewModel

    weak var delegate: SettingsMenuViewControllerDelegate?

    init(viewModel: SettingsMenuViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerDequeueable(SettingsMenuCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 29, bottom: 0, right: 29)

        imgeView.kf.setImage(with: viewModel.profile.photoURL)
        imgeView.layer.cornerRadius = 10

        titleLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.profile.name.uppercased(), letterSpacing: -2, font: UIFont(name:"Simple-Regular", size:32.0), lineSpacing: 0, textColor: nil)
        positionLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.profile.position.uppercased(), letterSpacing: 2, font: UIFont(name:"BentonSans", size:11.0), lineSpacing: 4, textColor: nil)

        generalButton.setAttributedTitle(prepareAndSetTextAttributes(string: R.string.localized.sidebarSettingsMenuGeneralButton().uppercased(), letterSpacing: -0.8, font:  UIFont(name:"Simple-Regular", size:20.0), lineSpacing: 0, textColor: nil), for: UIControlState.normal)
        notificationsButton.setAttributedTitle(prepareAndSetTextAttributes(string: R.string.localized.sidebarSettingsMenuNotificationsButton().uppercased(), letterSpacing: -0.8, font:  UIFont(name:"Simple-Regular", size:20.0), lineSpacing: 0, textColor: nil), for: UIControlState.normal)
        securityButton.setAttributedTitle(prepareAndSetTextAttributes(string: R.string.localized.sidebarSettingsMenuSecurityButton().uppercased(), letterSpacing: -0.8, font:  UIFont(name:"Simple-Regular", size:20.0), lineSpacing: 0, textColor: nil), for: UIControlState.normal)

    }

    func prepareAndSetTextAttributes(string: String, letterSpacing: CGFloat, font: UIFont?, lineSpacing: CGFloat, textColor: UIColor?) -> NSMutableAttributedString {
        let defaultFont: UIFont = UIFont(name:"Simple-Regular", size: 14.0)!
        let defaultColor: UIColor = UIColor.white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttributes([NSFontAttributeName: font ?? defaultFont], range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttributes([NSForegroundColorAttributeName: textColor ?? defaultColor], range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }

    // MARK: - delegateMethods

    @IBAction func generalAction(_ sender: Any) {
        delegate?.didTapGeneral(in: self)
    }

    @IBAction func notyficationAction(_ sender: Any) {
        delegate?.didTapNotifications(in: self)
    }

    @IBAction func securityAction(_ sender: Any) {
        delegate?.didTapSecurity(in: self)
    }
}

extension SettingsMenuViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tileCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.tile(at: indexPath.row)
        let cell: SettingsMenuCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        
        cell.timeLabel.attributedText = prepareAndSetTextAttributes(string: item.title, letterSpacing: 1, font: UIFont(name:"Simple-Regular", size:14.0), lineSpacing: 2, textColor: nil)
        cell.titleLabel.attributedText = prepareAndSetTextAttributes(string: item.subtitle.uppercased(), letterSpacing: 2, font: UIFont(name:"BentonSans", size: 11.0), lineSpacing: 3.2, textColor: UIColor.init(colorLiteralRed: 255.0, green: 255.0, blue: 255.0, alpha: 0.3))

        return cell
    }
}
