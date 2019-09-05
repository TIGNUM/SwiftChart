//
//  SensorViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SensorViewController: UIViewController {

    // MARK: - Properties

    var interactor: SensorInteractorInterface?
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var sensorsTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var wearablesTitleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var topConstraint: NSLayoutConstraint!
	private var sensors = [SensorModel]()
    private var contentSize: CGSize {
        var height: CGFloat = 150
        containerView.subviews.forEach { height += $0.frame.height }
        return CGSize(width: view.bounds.width, height: height)
    }

    // MARK: - Init

    init(configure: Configurator<SensorViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        interactor?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentSize
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = R.string.localized.sidebarSensorsMenuSensors().uppercased()
    }
}

// MARK: - Actions

private extension SensorViewController {

    func setupView() {
        view.backgroundColor = .navy
        collectionView.registerDequeueable(SensorCollectionViewCell.self)
        collectionView.registerDequeueable(RequestDeviceSensorCollectionViewCell.self)
        sensorsTitleLabel.font = .H3Subtitle
        wearablesTitleLabel.font = .H3Subtitle
        setCustomBackButton()
    }
}

// MARK: - SensorViewControllerInterface

extension SensorViewController: SensorViewControllerInterface {

    func setup(sensors: [SensorModel], headline: String, content: String) {
        self.sensors = sensors
        wearablesTitleLabel.addCharactersSpacing(spacing: 2, text: headline, uppercased: true)
        textLabel.setAttrText(text: content, font: .DPText, alignment: .left, lineSpacing: 13)
        reload()
    }

    @objc func reload() {
        collectionView.reloadData()
    }
}

// MARK: - CollectionViewDelegate, UICollectionViewDataSource

extension SensorViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sensors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sensors.item(at: indexPath.row)
        switch item.sensor {
        case .fitbit:
            let cell: SensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(image: item.sensor.image, sensorName: item.sensor.title, fitbitState: item.state)
            return cell
        case .requestDevice:
            let cell: RequestDeviceSensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(title: item.sensor.title)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sensor = sensors.item(at: indexPath.row)
        interactor?.didTapSensor(sensor: sensor)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SensorViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 72
        let verticalPadding: CGFloat = 16
        let cellSpacing: CGFloat = 10
        let numberOfItems: CGFloat = sensors.count > 0 ? CGFloat(sensors.count) : 2
        return CGSize(width: ((collectionView.bounds.width - horizontalPadding - cellSpacing) / numberOfItems),
                      height: collectionView.bounds.size.height - verticalPadding)
    }
}
