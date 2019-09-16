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

    @IBOutlet weak var hourlyStackView: UIStackView!

    //Allow access section
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var accessButtonHeightConstraint: NSLayoutConstraint!

    private var viewModel: WeatherViewModel?
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        accessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    @IBAction func didTapAllowAccessButton(_ sender: Any) {
        viewModel?.updateLocationPermissionStatus { [weak self] (status) in
            switch status {
            case .notSet:
                self?.viewModel?.requestLocationPermission { [weak self] (granted) in
                    self?.delegate?.didChangeLocationPermission(granted: granted)
                }
            case .denied:
                UIApplication.openAppSettings()
            default:
                break
            }
        }
    }

    func configure(with model: WeatherViewModel?) {
        viewModel = model
        ThemeText.dailyBriefTitle.apply(viewModel?.bucketTitle?.uppercased(), to: bucketTitleLabel)
        ThemeText.weatherIntro.apply(viewModel?.intro, to: introLabel)
        if let weather = viewModel?.domainModel?.weather {
            ThemeText.weatherDescription.apply(weather.shortDescription, to: weatherDescriptionLabel)
            ThemeText.weatherTitle.apply(weather.title, to: weatherTitleLabel)
            ThemeText.weatherBody.apply(weather.body, to: weatherBodyLabel)
            if let weatherType = WeatherType.init(rawValue: weather.shortDescription ?? "") {
                weatherImageView.image = image(for: weatherType, largeSize: true, isNight: isNight(currentDate: weather.currentDate, sunriseDate: weather.sunriseDate, sunsetDate: weather.sunsetDate))
            } else {
                weatherImageView.setImage(url: weather.imageURL, placeholder: UIImage(named: "placeholder_large"))
            }
        }
        setupUIAccordingToLocationPermissions()
        populateHourlyViews()
    }

    // MARK: Private
    private func populateHourlyViews() {
        guard let weatherModel = viewModel?.domainModel?.weather,
            let forecast = weatherModel.forecast,
            let nowHourlyView = R.nib.weatherHourlyView.instantiate(withOwner: self).first as? WeatherHourlyView else {
            return
        }

        nowHourlyView.setTime(text: R.string.localized.weatherNow())
        setupHourlyImage(for: nowHourlyView,
                         isNight: isNight(currentDate: weatherModel.currentDate, sunriseDate: weatherModel.sunriseDate, sunsetDate: weatherModel.sunsetDate),
                         and: weatherModel.imageURL,
                         and: weatherModel.shortDescription)
        hourlyStackView.addArrangedSubview(nowHourlyView)

        for forecastModel in forecast {
            guard let hourlyView = R.nib.weatherHourlyView.instantiate(withOwner: self).first as? WeatherHourlyView,
                let date = forecastModel.date else {
                return
            }
            hourlyView.setTime(text: DateFormatter.HH.string(from: date))
            setupHourlyImage(for: hourlyView,
                             isNight: isNight(currentDate: forecastModel.date, sunriseDate: weatherModel.sunriseDate, sunsetDate: weatherModel.sunsetDate),
                             and: forecastModel.imageURL,
                             and: forecastModel.shortDescription)
            hourlyStackView.addArrangedSubview(hourlyView)
        }
    }

    private func setupUIAccordingToLocationPermissions() {
        var accessTitle = ""
        var accessButtonTitle = ""
        var accessButtonHeight: CGFloat = 0
        switch viewModel?.locationPermissionStatus {
        case .notSet?:
            accessButtonTitle = viewModel?.requestLocationPermissionButtonTitle ?? ""
            accessTitle = viewModel?.requestLocationPermissionDescription ?? ""
            accessButtonHeight = ThemeButton.accent40.defaultHeight
        case .denied?:
            accessTitle = viewModel?.deniedLocationPermissionDescription ?? ""
            accessButtonTitle = viewModel?.deniedLocationPermissionButtonTitle ?? ""
            accessButtonHeight = ThemeButton.accent40.defaultHeight
        default:
            break
        }
        ThemeText.weatherTitle.apply(accessTitle, to: accessLabel)
        accessButton.setTitle(accessButtonTitle, for: .normal)
        accessButtonHeightConstraint.constant = accessButtonHeight

    }

    private func setupHourlyImage(for hourlyView: WeatherHourlyView,
                                  isNight: Bool,
                                  and imageURL: URL?,
                                  and shortDescription: String?) {
        if let weatherType = WeatherType.init(rawValue: shortDescription ?? ""),
            let hourlyImage = image(for: weatherType, largeSize: false, isNight: isNight) {
            hourlyView.set(image: hourlyImage)
        } else {
            if let url = imageURL {
                hourlyView.set(imageUrl: url, placeholder: UIImage(named: "placeholder_small"))
            } else if let fallbackDescription = shortDescription {
                hourlyView.setFallback(text: fallbackDescription)
            }
        }
    }

    private func image(for type: WeatherType, largeSize: Bool, isNight: Bool) -> UIImage? {
        let imageName: String
        switch type {
        case .clearSky:
            imageName = isNight ? (largeSize ? "night_clear_sky_large" : "night_clear_sky_small") : (largeSize ? "day_clear_sky_large" : "day_clear_sky_small")
        case .cloudy:
            imageName = isNight ? (largeSize ? "night_cloudy_large" : "night_cloudy_small") : (largeSize ? "day_cloudy_large" : "day_cloudy_small")
        case .rain:
            imageName = largeSize ? "rain_large" : "rain_small"
        case .thunderStorm:
            imageName = largeSize ? "thunderstorm_large" : "thunderstorm_small"
        case .snow:
            imageName = largeSize ? "snow_large" : "snow_small"
        case .mist:
            imageName = largeSize ? "mist_large" : "mist_small"
        }
        return UIImage(named: imageName) ?? UIImage()

    }

    func isNight(currentDate: Date?, sunriseDate: Date?, sunsetDate: Date?) -> Bool {
        guard let currenTime = currentDate,
        let sunrise = sunriseDate,
        let sunset = sunsetDate else {
                return false
        }
        return (currenTime < sunrise) || (currenTime > sunset)
    }
}
