//
//  WeatherHourlyView.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 13/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class WeatherHourlyView: UIView {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var fallbackWeatherLabel: UILabel!

    public func setTime(text: String) {
        ThemeText.weatherHourlyLabelNow.apply(text, to: timeLabel)
    }

    public func setFallback(text: String) {
        ThemeText.weatherHourlyLabelNow.apply(text, to: fallbackWeatherLabel)
        imageView.isHidden = true
        fallbackWeatherLabel.isHidden = false
    }

    public func set(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        fallbackWeatherLabel.isHidden = true
    }

    public func set(imageUrl: URL?, placeholder: UIImage?) {
        guard let url = imageUrl else {
            return
        }
        imageView.setImage(url: url, placeholder: placeholder ?? UIImage())
        imageView.isHidden = false
        fallbackWeatherLabel.isHidden = true
    }
}
