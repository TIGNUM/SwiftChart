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

        backgroundColor = .white8
        layer.cornerRadius = 8.0
        sensorNameLabel.font = Font.H7Title
        sensorNameLabel.textColor = .white
        connectLabel.font = Font.H7Title
        connectLabel.textColor = UIColor(red: 2/255, green: 149/255, blue: 208/255, alpha: 1.0)
    }
    
    func setup(image: UIImage, sensorName: String, fitbitState: User.FitbitState) {
        imageView.image = image
        sensorNameLabel.addCharactersSpacing(spacing: 2, text: sensorName, uppercased: true)
        connectLabel.addCharactersSpacing(spacing: 2, text: fitbitState.rawValue, uppercased: true)
    }
}
