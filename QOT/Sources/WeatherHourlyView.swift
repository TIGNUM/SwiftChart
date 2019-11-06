//
//  WeatherHourlyView.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 13/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class WeatherHourlyView: UIView {
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var fallbackWeatherLabel: UILabel!

    public func set(time: String, temperature: String, isNow: Bool = false) {
        if isNow {
            ThemeText.weatherHourlyLabelNow.apply(time, to: timeLabel)
            ThemeText.weatherHourlyLabelNow.apply(temperature, to: temperatureLabel)
        } else {
            ThemeText.weatherHourlyLabels.apply(time, to: timeLabel)
            ThemeText.weatherHourlyLabels.apply(temperature, to: temperatureLabel)
        }
    }

    public func setFallback(text: String) {
        ThemeText.weatherHourlyLabels.apply(text, to: fallbackWeatherLabel)
        imageView.isHidden = true
        fallbackWeatherLabel.isHidden = false
    }

    public func set(image: UIImage, isNow: Bool = false) {
        imageView.image = image
        imageView.tintColor = isNow ? .sand : .sand70
        imageView.isHidden = false
        fallbackWeatherLabel.isHidden = true
    }

    public func set(imageUrl: URL?, placeholder: UIImage?) {
        guard let url = imageUrl else {
            return
        }
        imageView.setImage(url: url, placeholder: placeholder ?? UIImage()) { (_) in /* */}
        imageView.isHidden = false
        fallbackWeatherLabel.isHidden = true
    }
}
