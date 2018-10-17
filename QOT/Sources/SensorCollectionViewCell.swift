//
//  SensorCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 22.05.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SensorCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var sensorNameLabel: UILabel!
    @IBOutlet private weak var connectLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Setup

    func setupView() {
        backgroundColor = .white8
        corner(radius: Layout.CornerRadius.eight.rawValue)
        sensorNameLabel.font = .H7Title
        sensorNameLabel.textColor = .white
        connectLabel.font = .H7Title
        connectLabel.textColor = .addSensorConnectGray
    }

    func configure(image: UIImage, sensorName: String, fitbitState: User.FitbitState?) {
        imageView.image = image
        sensorNameLabel.addCharactersSpacing(spacing: 2, text: sensorName, uppercased: true)
        if let fitbitState = fitbitState {
            connectLabel.addCharactersSpacing(spacing: 2, text: fitbitState.rawValue, uppercased: true)
        }
    }
}
