//
//  UserMeasurement.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class UserMeasurement {

    struct Option {

        let unit: String
        let values: [(value: Double, title: String)]
    }

    let options: [Option]
    private(set) var valueIndex: Int = 0
    private(set) var unitIndex: Int = 0

    init(options: [Option], value: Double, unit: String) {
        self.options = options
        unitIndex = options.index { $0.unit == unit } ?? 0
        let values = options[unitIndex].values.map { $0.value }
        valueIndex = indexOfClosestValue(to: value, in: values) ?? 0
    }

    var columnCount: Int {
        return 2
    }

    func rowCount(column: Int) -> Int {
        switch column {
        case 0:
            return options[unitIndex].values.count
        case 1:
            return options.count
        default:
            fatalError("Invalid column")
        }
    }

    func title(row: Int, column: Int) -> String? {
        switch column {
        case 0:
            return options[unitIndex].values[row].title
        case 1:
            return options[row].unit
        default:
            fatalError("Invalid column")
        }
    }

    var selectedValue: Double {
        return options[unitIndex].values[valueIndex].value
    }

    func update(valueIndex: Int) {
        self.valueIndex = valueIndex
    }

    func update(unit: String) {
        let existingValue = selectedValue
        let newUnitIndex = options.index { $0.unit == unit } ?? 0
        let values = options[newUnitIndex].values.map { $0.value }
        let newValueIndex = indexOfClosestValue(to: existingValue, in: values) ?? 0

        unitIndex = newUnitIndex
        valueIndex = newValueIndex
    }

    func currentTitle() -> String {
        let value = title(row: valueIndex, column: 0) ?? "0"
        return "\(value) \(options[unitIndex].unit)"
    }

    private func indexOfClosestValue(to searchValue: Double, in values: [Double]) -> Int? {
        var best: (index: Int, delta: Double)?
        for (index, value) in values.enumerated() {
            let delta = abs(searchValue - value)
            if let candidate = best {
                if delta < candidate.delta {
                    best = (index, delta)
                } else {
                    break
                }
            } else {
                best = (index, delta)
            }
        }
        return best?.index
    }

    static func weight(kilograms: Double, unit: String) -> UserMeasurement {
        var kilogramsValues: [(value: Double, title: String)] = []
        for weight in stride(from: 1.0, to: 501.0, by: 1.0) {
            let kilograms = Measurement(value: weight, unit: UnitMass.kilograms)
            let displayValue = String(format: "%.1f", weight)
            kilogramsValues.append((kilograms.value, displayValue))
        }
        let kilogramsOption = Option(unit: "kg", values: kilogramsValues)

        var poundsValues: [(value: Double, title: String)] = []
        for weight in stride(from: 1.0, to: 1105.0, by: 1.0) {
            let pounds = Measurement(value: weight, unit: UnitMass.pounds)
            let kilograms = pounds.converted(to: .kilograms)
            let displayValue = String(format: "%d", Int(weight))
            poundsValues.append((kilograms.value, displayValue))
        }
        let poundsOption = Option(unit: "lbs", values: poundsValues)

        return UserMeasurement(options: [poundsOption, kilogramsOption], value: kilograms, unit: unit)
    }

    static func height(meters: Double, unit: String) -> UserMeasurement {
        let formatter = LengthFormatter()
        formatter.isForPersonHeightUse = true
        formatter.numberFormatter.locale = Locale(identifier: "en_US")
        formatter.unitStyle = .short
        formatter.numberFormatter.maximumFractionDigits = 0

        var feetValues: [(value: Double, title: String)] = []
        for inches in stride(from: 1.0, to: 120.0, by: 1.0) {
            let inches = Measurement(value: inches, unit: UnitLength.inches)
            let meters = inches.converted(to: .meters).value
            let displayValue = formatter.string(fromMeters: meters)
            feetValues.append((meters, displayValue))
        }
        let feetOption = Option(unit: "ft", values: feetValues)

        var centimeterValues: [(value: Double, title: String)] = []
        for height in stride(from: 1.0, to: 300.0, by: 1.0) {
            let centimeters = Measurement(value: height, unit: UnitLength.centimeters)
            let meters = centimeters.converted(to: .meters).value
            let displayValue = String(format: "%d", Int(height))
            centimeterValues.append((meters, displayValue))
        }
        let meterOption = Option(unit: "cm", values: centimeterValues)

        return UserMeasurement(options: [feetOption, meterOption], value: meters, unit: unit)
    }
}
