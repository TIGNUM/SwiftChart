//
//  User+Convenience.swift
//  QOT
//
//  Created by karmic on 30.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy
import qot_dal

extension QDMUser {

    var weightPickerItems: UserMeasurement {
        if let weight = weight, let unit = weightUnit {
            switch unit {
            case "kg":
                return UserMeasurement.weight(kilograms: Double(weight), unit: "kg")
            case "lbs":
                let lbs = Measurement(value: Double(weight), unit: UnitMass.pounds)
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
        if let height = height, let unit = heightUnit {
            switch unit {
            case "cm":
                let centimeters = Measurement(value: Double(height), unit: UnitLength.centimeters)
                let meters = centimeters.converted(to: .meters)
                return UserMeasurement.height(meters: meters.value, unit: "cm")
            case "ft":
                let feet = Measurement(value: Double(height), unit: UnitLength.feet)
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
