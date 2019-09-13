//
//  WeatherCell.swift
//  QOT
//
//  Created by Voicu on 11.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class WeatherCell: BaseDailyBriefCell {
    //Header section
    @IBOutlet weak var bucketTitleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!

    //WeatherView section
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherTitleLabel: UILabel!
    @IBOutlet weak var weatherBodyLabel: UILabel!

    @IBOutlet weak var hourlyScrollView: UIScrollView!
    @IBOutlet var hourlyImagesCollection: [UIImageView]!
    @IBOutlet var hourlyFallbackDescrpitionLabelsCollection: [UILabel]!
    @IBOutlet var hourlyLabelsCollection: [UILabel]!

    //Allow access section
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var accessButtonHeightConstraint: NSLayoutConstraint!

    private var locationPermission = LocationPermission()
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        accessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    @IBAction func didTapAllowAccessButton(_ sender: Any) {
        locationPermission.authorizationStatusDescription { [weak self] (string) in
            if string == "notDetermined" {
                self?.locationPermission.askPermission { [weak self] (granted) in
                    self?.delegate?.didChangeLocationPermission(granted: granted)
                }
            } else if string == "denied" {
                UIApplication.openAppSettings()
            }
        }
    }

    func configure(with model: WeatherViewModel?) {
        ThemeText.dailyBriefTitle.apply(model?.bucketTitle?.uppercased(), to: bucketTitleLabel)
        ThemeText.weatherIntro.apply(model?.intro, to: introLabel)
        if let weather = model?.domainModel?.weather {
            ThemeText.weatherDescription.apply(weather.shortDescription, to: weatherDescriptionLabel)
            ThemeText.weatherTitle.apply(weather.title, to: weatherTitleLabel)
            ThemeText.weatherBody.apply(weather.body, to: weatherBodyLabel)
            if let weatherType = WeatherType.init(rawValue: weather.shortDescription ?? "") {
                weatherImageView.image = image(for: weatherType, largeSize: true, isNight: isNight(forTime: weather.currentTime, sunrise: weather.sunrise, sunset: weather.sunset))
            } else {
                weatherImageView.setImage(url: weather.imageURL, placeholder: UIImage(named: "placeholder_large"))
            }
        }
        setupUIAccordingToLocationPermissions(with: model)
        populateHourlyViews(with: model?.domainModel?.weather)
    }

    // MARK: Private
    private func populateHourlyViews(with model: QDMWeather?) {
        guard let weatherModel = model, let forecast = weatherModel.forecast else {
            return
        }

        for label in hourlyLabelsCollection where label.tag == 999 {
            ThemeText.weatherHourlyLabelNow.apply("Now", to: label)
        }

        for imageView in hourlyImagesCollection where imageView.tag == 999 {
            setupHourlyImage(for: imageView,
                             at: 999,
                             isNight: isNight(forTime: model?.currentTime, sunrise: model?.sunrise, sunset: model?.sunset),
                             and: model?.imageURL,
                             and: model?.shortDescription)
        }

        for (index, forecastModel) in forecast.enumerated() {
            for imageView in hourlyImagesCollection where imageView.tag == index {
                setupHourlyImage(for: imageView,
                                 at: index,
                                 isNight: isNight(forTime: forecastModel.time, sunrise: model?.sunrise, sunset: model?.sunset),
                                 and: forecastModel.imageURL,
                                 and: forecastModel.shortDescription)
            }

            for label in hourlyLabelsCollection where label.tag == index {
                ThemeText.weatherHourlyLabels.apply(forecastModel.time, to: label)
            }
        }
    }

    private func setupUIAccordingToLocationPermissions(with model: WeatherViewModel?) {
        LocationPermission().authorizationStatusDescription { [weak self] (string) in
            var accessTitle = ""
            var accessButtonTitle = ""
            var accessButtonHeight: CGFloat = 0
            if string == "notDetermined" {
                accessButtonTitle = model?.requestLocationPermissionButtonTitle ?? ""
                accessTitle = model?.requestLocationPermissionDescription ?? ""
                accessButtonHeight = 40
            } else if string == "denied" {
                accessTitle = model?.deniedLocationPermissionDescription ?? ""
                accessButtonTitle = model?.deniedLocationPermissionButtonTitle ?? ""
                accessButtonHeight = 40
            }
            ThemeText.weatherTitle.apply(accessTitle, to: self?.accessLabel)
            self?.accessButton.setTitle(accessButtonTitle, for: .normal)
            self?.accessButtonHeightConstraint.constant = accessButtonHeight
        }
    }

    private func setupHourlyImage(for imageView: UIImageView,
                                  at index: Int,
                                  isNight: Bool,
                                  and imageURL: URL?,
                                  and shortDescription: String?) {
        if let weatherType = WeatherType.init(rawValue: shortDescription ?? "") {
            imageView.image = image(for: weatherType, largeSize: false, isNight: isNight)
        } else {
            weatherImageView.setImage(url: imageURL, placeholder: UIImage(named: "placeholder_small"))
            if weatherImageView.image == nil {
                for label in hourlyFallbackDescrpitionLabelsCollection where label.tag == index {
                    ThemeText.weatherHourlyLabels.apply(shortDescription, to: label)
                }
            }
        }
    }

    private func image(for type: WeatherType, largeSize: Bool, isNight: Bool) -> UIImage {
        switch type {
        case .clearSky:
            let imageaName = isNight ? (largeSize ? "night_clear_sky_large" : "night_clear_sky_small") : (largeSize ? "day_clear_sky_large" : "day_clear_sky_small")

            return UIImage(named: imageaName) ?? UIImage()
        case .cloudy:
            let imageaName = isNight ? (largeSize ? "night_cloudy_large" : "night_cloudy_small") : (largeSize ? "day_cloudy_large" : "day_cloudy_small")

            return UIImage(named: imageaName) ?? UIImage()
        case .rain:
            let imageaName = largeSize ? "rain_large" : "rain_small"

            return UIImage(named: imageaName) ?? UIImage()
        case .thunderStorm:
            let imageaName = largeSize ? "thunderstorm_large" : "thunderstorm_small"

            return UIImage(named: imageaName) ?? UIImage()
        case .snow:
            let imageaName = largeSize ? "snow_large" : "snow_small"

            return UIImage(named: imageaName) ?? UIImage()
        case .mist:
            let imageaName = largeSize ? "mist_large" : "mist_small"

            return UIImage(named: imageaName) ?? UIImage()
        }
    }

    func isNight(forTime: String?, sunrise: String?, sunset: String?) -> Bool {
        var night = false
        if let currentTime = DateFormatter.dd.date(from: forTime ?? ""),
            let sunriseTime = DateFormatter.dd.date(from: sunrise ?? ""),
            let sunsetTime = DateFormatter.dd.date(from: sunset ?? "") {
            night = (currentTime < sunriseTime) || (currentTime > sunsetTime)
        }
        return night
    }
}
