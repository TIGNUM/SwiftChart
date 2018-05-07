//
//  AddSensorViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class AddSensorViewModel {

    enum Sensor {
        case apple
        case fitbit
        case requestDevice

        var image: UIImage {
            let size = CGSize(width: 116, height: 116)
            switch self {
            case .apple: return UIColor.red.image(size: size)
            case .fitbit: return UIImage(named: "fitbitLogo")!
            case .requestDevice: return UIColor.gray.image(size: size)
            }
        }

        var title: String {
            switch self {
            case .apple: return "##APPLE"
            case .fitbit: return R.string.localized.sidebarSensorsMenuFitbit()
            case .requestDevice: return R.string.localized.sidebarSensorsMenuRequestSensor()
            }
        }
    }

    // MARK: - Properties

    private let sensors: [Sensor] = [.fitbit, .requestDevice]
    private let services: Services

    private var sensorCollection: ContentCollection? {
        return services.contentService.contentCollection(id: 100935)
    }

    var itemCount: Int {
        return sensors.count
    }

    var fitbitState: User.FitbitState {
        return services.userService.fitbitState
    }

    var settingValue: SettingValue? {
        return services.settingsService.settingValue(key: "b2b.fitbit.authorizationurl")
    }

    var headLine: String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.h2.rawValue }.first?.valueText
    }

    var content: String? {
        guard let collection = sensorCollection else { return nil }
        return Array(collection.articleItems).filter { $0.format == ContentItemTextStyle.paragraph.rawValue }.first?.valueText
    }

    func item(at index: Index) -> Sensor {
        return sensors[index]
    }

    func recordFeedback(message: String) {
        do {
            try self.services.feedbackService.recordFeedback(message: message)
        } catch {
            log(error.localizedDescription)
        }
    }

    init(services: Services) {
        self.services = services
    }
}

// MARK: Mock data

private extension UIColor {

    func image(size: CGSize) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }
}
