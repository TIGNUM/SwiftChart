//
//  AddSensorViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol AddSensorViewControllerDelegate: class {
    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController)
}

final class AddSensorViewController: UIViewController {

    fileprivate let viewModel: AddSensorViewModel

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 36, bottom: 10, right: 59)

        return UICollectionView(
            layout: layout,
            delegate: self,
            dataSource: self,
            dequeables: SensorCollectionViewCell.self,
            RequestDeviceSensorCollectionViewCell.self
        )
    }()

    fileprivate lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.delegate = self
        view.addSubview(self.contentView)
        return view
    }()

    fileprivate lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(self.titleLabel)
        view.addSubview(self.collectionView)
        view.addSubview(self.headerLabel)
        view.addSubview(self.textLabel)
        return view
    }()

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.addCharactersSpacing(spacing: 2, text: R.string.localized.sidebarSensorsMenuSensors(), uppercased: true)
        label.textColor = .white
        label.font = Font.H3Subtitle

        return label
    }()

    fileprivate lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.H3Subtitle

        label.addCharactersSpacing(spacing: 2, text: self.viewModel.heading, uppercased: true)
        label.numberOfLines = 0
        return label
    }()

    fileprivate lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.prepareAndSetTextAttributes(text: self.viewModel.text, font: Font.DPText, alignment: .left, lineSpacing: 13)
        label.numberOfLines = 0
        return label
    }()

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

        setUpHierarchy()
        setUpLayout()
    }
}

// MARK: - Collection View DataSource and Delegate

extension AddSensorViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath.row)

        switch item {
        case .fitbit, .apple:
            let cell: SensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(image: item.image, sensorName: item.title)

            return cell
        case .requestDevice:
            let cell: RequestDeviceSensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(title: item.title)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 207)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapSensor(viewModel.item(at: indexPath.row), in: self)
    }
}

private extension AddSensorViewController {

    func setUpHierarchy() {
        view.addSubview(scrollView)
    }

    func setUpLayout() {
        scrollView.verticalAnchors == view.verticalAnchors
        scrollView.horizontalAnchors == view.horizontalAnchors

        contentView.leftAnchor == scrollView.leftAnchor
        contentView.rightAnchor == scrollView.rightAnchor
        contentView.topAnchor == scrollView.topAnchor
        contentView.bottomAnchor == scrollView.bottomAnchor
        contentView.widthAnchor == scrollView.widthAnchor

        titleLabel.topAnchor == contentView.topAnchor + Layout.TabBarView.height + 46
        titleLabel.leftAnchor == contentView.leftAnchor + 36
        titleLabel.rightAnchor == contentView.rightAnchor - 59
        titleLabel.heightAnchor == 36

        collectionView.topAnchor == titleLabel.bottomAnchor + 14
        collectionView.horizontalAnchors == contentView.horizontalAnchors
        collectionView.heightAnchor == 220

        headerLabel.topAnchor == collectionView.bottomAnchor + 52
        headerLabel.horizontalAnchors == titleLabel.horizontalAnchors

        textLabel.topAnchor == headerLabel.bottomAnchor + 17
        textLabel.horizontalAnchors == titleLabel.horizontalAnchors
        textLabel.bottomAnchor == contentView.bottomAnchor - 12

        view.layoutIfNeeded()
    }
}
