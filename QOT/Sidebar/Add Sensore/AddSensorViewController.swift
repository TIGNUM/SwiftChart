//
//  AddSensorViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol AddSensorViewControllerDelegate: class {
    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController)
}

final class AddSensorViewController: UIViewController {

    fileprivate let viewModel: AddSensorViewModel

    @IBOutlet var viewTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    weak var delegate: AddSensorViewControllerDelegate?

    init(viewModel: AddSensorViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitleLabel.attributedText = prepareAndSetTextAttributes(string: "SENSORS", letterSpacing: 2, font: UIFont(name:"Simple-Regular", size: 24.0), lineSpacing: 0)
        headerLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.heading.uppercased(), letterSpacing: 2, font: UIFont(name:"Simple-Regular", size: 24.0), lineSpacing: 0)
        textLabel.attributedText = prepareAndSetTextAttributes(string: viewModel.text, letterSpacing: 0, font: UIFont(name:"BentonSans-Book", size: 16.0), lineSpacing: 0)

        collectionView.registerDequeueable(SensorCollectionViewCell.self)
        collectionView.contentInset.left = 36.0
    }

    func prepareAndSetTextAttributes(string: String, letterSpacing: CGFloat, font: UIFont?, lineSpacing: CGFloat) -> NSMutableAttributedString {
        let defaultFont: UIFont = UIFont(name:"Simple-Regular", size: 14.0)!
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttributes([NSFontAttributeName: font ?? defaultFont], range: NSRange(location: 0, length: string.utf16.count))
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }
}
extension AddSensorViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: SensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)

        cell.imageView.image = item.image

        return cell
    }
}
