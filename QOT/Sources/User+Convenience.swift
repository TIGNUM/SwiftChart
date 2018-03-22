//
//  User+Convenience.swift
//  QOT
//
//  Created by karmic on 30.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

extension User {

    var weightPickerItems: UserMeasurement {
        if let weight = weight.value, let unit = weightUnit {
            switch unit {
            case "kg":
                return UserMeasurement.weight(kilograms: weight, unit: "kg")
            case "lbs":
                let lbs = Measurement(value: weight, unit: UnitMass.pounds)
                let kilos = lbs.converted(to: .kilograms)
                return UserMeasurement.weight(kilograms: kilos.value, unit: "lbs")
            default:
                return UserMeasurement.weight(kilograms: 60, unit: "kg")
            }
        } else {
            return UserMeasurement.weight(kilograms: 60, unit: "kg")
        }
    }

    var heightPickerItems: UserMeasurement {
        if let height = height.value, let unit = heightUnit {
            switch unit {
            case "cm":
                let centimeters = Measurement(value: height, unit: UnitLength.centimeters)
                let meters = centimeters.converted(to: .meters)
                return UserMeasurement.height(meters: meters.value, unit: "cm")
            case "ft":
                let feet = Measurement(value: height, unit: UnitLength.feet)
                let meters = feet.converted(to: .meters)
                return UserMeasurement.height(meters: meters.value, unit: "ft")
            default:
                return UserMeasurement.height(meters: 1.7, unit: "cm")
            }
        } else {
            return UserMeasurement.height(meters: 1.7, unit: "cm")
        }
    }
}
