//
//  SensorCollectionViewCell.swift
//  QOT
//
//  Created by Type-IT on 22.05.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SensorCollectionViewCell: UICollectionViewCell, Dequeueable {

    @IBOutlet private var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8.0
    }

    func setup(image: UIImage) {
        imageView.image = image
    }
}
