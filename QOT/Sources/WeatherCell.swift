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
    // MARK: - Properties
    //Header section
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    private var baseView: QOTBaseHeaderView?

    //WeatherView section
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherBodyLabel: UILabel!
    @IBOutlet weak var hourlyStackView: UIStackView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var weatherImageViewTopConstraint: NSLayoutConstraint!

    //Allow access section
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessImageContainerView: UIView!
    @IBOutlet weak var accessImageView: UIImageView!
    @IBOutlet weak var accessButton: UIButton!
    @IBOutlet weak var accessButtonHeightConstraint: NSLayoutConstraint!

    private var viewModel: WeatherViewModel?
    weak var delegate: DailyBriefViewControllerDelegate?
    private let formatter = MeasurementFormatter()
    private let numberFormatter = NumberFormatter()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        accessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        startSkeleton()
        for arrangedView in hourlyStackView.arrangedSubviews {
            arrangedView.isHidden = true
        }
        ThemeView.level1.apply(accessImageContainerView)
        baseView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseView?.addTo(superview: headerView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hourlyStackView.removeAllArrangedSubviews()
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.minimumFractionDigits = 1
    }

    // MARK: - Actions
    @IBAction func didTapAllowAccessButton(_ sender: Any) {
        viewModel?.requestLocationPermission { [weak self] (status) in
            switch status {
            case .denied:
                UIApplication.openAppSettings()
            default:
                self?.viewModel?.requestLocationPermission(completion: { [weak self] (status) in
                    let granted = (status == .granted)
                    self?.delegate?.didChangeLocationPermission(granted: granted)
                    granted ? self?.startSkeleton() : self?.setupUIAccordingToLocationPermissions()
                })
            }
        }
    }

    // MARK: - Public
    func configure(with model: WeatherViewModel?) {
        guard let weatherViewModel = model else { return }
        for arrangedView in hourlyStackView.arrangedSubviews {
            arrangedView.isHidden = false
        }
        skeletonManager.hide()
        viewModel = weatherViewModel
        baseView?.configure(title: viewModel?.bucketTitle?.uppercased(),
                            subtitle: viewModel?.intro)
        baseView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply(viewModel?.bucketTitle?.uppercased(), to: baseView?.titleLabel)
        ThemeText.weatherIntro.apply(viewModel?.intro, to: baseView?.subtitleTextView)
        var relevantForecastModels = [QDMForecast]()
        if let weatherModel = viewModel?.domainModel?.weather {
            for forecastModel in weatherModel.forecast ?? [] where
                forecastModel.date != nil &&
                isDateAfterNow(forecastModel.date!) {
                relevantForecastModels.append(forecastModel)
            }

            guard let weather = relevantForecastModels.first else {
                return
            }
            var temperature = ""
            if let value = formatTemperature(value: weather.currentTempInCelcius?.rounded(), shortStyle: false),
                isDateAfterNow(weather.date ?? Date()) {
                temperature = value
            } else if let value = formatTemperature(value: relevantForecastModels.first?.currentTempInCelcius, shortStyle: false) {
                temperature = value
            }
            let temperatureDescription = "\(weather.shortDescription ?? "") \(temperature)"
            var lastUpdate = ""
            if let weatherDate = weather.date {
                lastUpdate = formatLastUpdatedString(date: weatherDate)
            }

            ThemeText.weatherDescription.apply(temperatureDescription, to: weatherDescriptionLabel)
            ThemeText.weatherLastUpdate.apply(lastUpdate, to: lastUpdateLabel)
            ThemeText.weatherLocation.apply(model?.locationName, to: locationLabel)
            ThemeText.weatherTitle.apply(weatherModel.title, to: weatherTitleLabel)
            ThemeText.weatherBody.apply(weatherModel.body, to: weatherBodyLabel)
            if let imageUrl = weather.imageURL {
                weatherImageView.setImage(url: imageUrl, placeholder: UIImage(named: "placeholder_large")) { (_) in /* */}
            } else if let weatherType = WeatherType.init(rawValue: weather.shortDescription ?? "") {
                weatherImageView.image = image(for: weatherType,
                                               largeSize: true,
                                               isNight: isNight(currentDate: weather.date,
                                                                sunriseDate: weatherModel.sunriseDate,
                                                                sunsetDate: weatherModel.sunsetDate))
            }
        }
        setupUIAccordingToLocationPermissions()
        populateHourlyViews(relevantForecastModels: relevantForecastModels)
    }

    // MARK: - Private

    private func isDateAfterNow(_ date: Date) -> Bool {
        return (Calendar.current.compare(Date(), to: date, toGranularity: .hour) == .orderedAscending ||
                Calendar.current.compare(Date(), to: date, toGranularity: .hour) == .orderedSame)
    }
    private func startSkeleton() {
        if let baseView = self.baseView {
            for subview in baseView.subviews {
                skeletonManager.addSubtitle(subview)
            }
        }
        skeletonManager.addSubtitle(weatherDescriptionLabel)
        skeletonManager.addSubtitle(weatherTitleLabel)
        skeletonManager.addSubtitle(weatherBodyLabel)
        skeletonManager.addOtherView(hourlyStackView)
        skeletonManager.addOtherView(weatherImageView)
        skeletonManager.addSubtitle(accessLabel)
        skeletonManager.addOtherView(accessImageView)
        skeletonManager.addOtherView(accessButton)
    }

    // MARK: Helpers
    private func formatTemperature(value: Double?, shortStyle: Bool = true) -> String? {
        if let numberValue = numberFormatter.number(from: numberFormatter.string(for: value) ?? "") as? Double {
            formatter.numberFormatter.maximumFractionDigits = 0
            formatter.unitStyle = shortStyle ? .short : .medium
            let measurement = Measurement(value: numberValue, unit: UnitTemperature.celsius)

            return formatter.string(from: measurement)
        }
        return nil
    }

    func formatLastUpdatedString(date: Date) -> String {
        return "Last updated \(date.eventDateString)"
    }

    private func populateHourlyViews(relevantForecastModels: [QDMForecast]) {
        guard let weatherModel = viewModel?.domainModel?.weather else { return }

        for (index, forecastModel) in relevantForecastModels.enumerated() {
            guard let hourlyView = R.nib.weatherHourlyView.instantiate(withOwner: self).first as? WeatherHourlyView,
                let date = forecastModel.date,
                    let temperature = formatTemperature(value: forecastModel.currentTempInCelcius) else {
                    return
            }
            if index == 0 {
                hourlyView.set(time: AppTextService.get(AppTextKey.daily_brief_section_weather_label_now),
                               temperature: temperature,
                               isNow: true)
            } else {
                hourlyView.set(time: DateFormatter.HH.string(from: date),
                               temperature: temperature,
                               isNow: false)
            }
            setupHourlyImage(for: hourlyView,
                             isNight: isNight(currentDate: forecastModel.date,
                                              sunriseDate: weatherModel.sunriseDate,
                                              sunsetDate: weatherModel.sunsetDate),
                             and: forecastModel.imageURL,
                             and: forecastModel.shortDescription,
                             isNow: false)
            hourlyStackView.addArrangedSubview(hourlyView)
        }
    }

    private func setupUIAccordingToLocationPermissions() {
        var accessTitle = ""
        var accessButtonTitle = ""
        var accessButtonHeight: CGFloat = 0
        var shouldHideHeader = false
        switch viewModel?.locationPermissionStatus {
        case .granted?, .grantedWhileInForeground?:
            shouldHideHeader = true
            accessImageView.image = nil
        case .denied?:
            accessTitle = viewModel?.deniedLocationPermissionDescription ?? ""
            accessButtonTitle = viewModel?.deniedLocationPermissionButtonTitle ?? ""
            accessButtonHeight = ThemeButton.accent40.defaultHeight
            accessImageView.image = R.image.location_permission()
        default:
            accessButtonTitle = viewModel?.requestLocationPermissionButtonTitle ?? ""
            accessTitle = viewModel?.requestLocationPermissionDescription ?? ""
            accessButtonHeight = ThemeButton.accent40.defaultHeight
            accessImageView.image = R.image.location_permission()
        }
        ThemeText.weatherTitle.apply(accessTitle, to: accessLabel)
        accessButton.setTitle(accessButtonTitle, for: .normal)
        accessButtonHeightConstraint.constant = accessButtonHeight

        headerHeightConstraint.constant = shouldHideHeader ? 0 : baseView?.calculateHeight(for: self.frame.size.width) ?? 0
        headerView.isHidden = shouldHideHeader
        accessImageView.isHidden = shouldHideHeader
        accessImageContainerView.isHidden = shouldHideHeader
        lastUpdateLabel.isHidden = !shouldHideHeader
        layoutIfNeeded()
    }

    private func setupHourlyImage(for hourlyView: WeatherHourlyView,
                                  isNight: Bool,
                                  and imageURL: URL?,
                                  and shortDescription: String?,
                                  isNow: Bool) {
        if let url = imageURL {
            hourlyView.set(imageUrl: url, placeholder: UIImage(named: "placeholder_small"))
        } else {
            if let weatherType = WeatherType.init(rawValue: shortDescription ?? ""),
                let hourlyImage = image(for: weatherType, largeSize: false, isNight: isNight) {
                hourlyView.set(image: hourlyImage, isNow: isNow)
            } else if let fallbackDescription = shortDescription {
                hourlyView.setFallback(text: fallbackDescription)
            }
        }
    }

    private func image(for type: WeatherType, largeSize: Bool, isNight: Bool) -> UIImage? {
        let imageName: String
        switch type {
        case .clearSky:
            imageName = isNight ? (largeSize ? "night_clear_sky_large" : "night_clear_sky_small") :
                                  (largeSize ? "day_clear_sky_large" : "day_clear_sky_small")
        case .cloudy:
            imageName = isNight ? (largeSize ? "night_cloudy_large" : "night_cloudy_small") :
                                  (largeSize ? "day_cloudy_large" : "day_cloudy_small")
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
