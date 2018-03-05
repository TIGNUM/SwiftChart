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

    var weightUnitItems: [String] {
        do {
            return try unitItems(for: weightUnitsJSON, jsonKey: .name)
        } catch {
            return []
        }
    }

    var weightIncrementItems: [Double] {
        do {
            return try incrementItems(for: weightUnitsJSON, jsonKey: .increment)
        } catch {
            return []
        }
    }

    var heightUnitItems: [String] {
        do {
            return try unitItems(for: heightUnitsJSON, jsonKey: .name)
        } catch {
            return []
        }
    }

    var heightIncrementItems: [Double] {
        do {
            return try incrementItems(for: heightUnitsJSON, jsonKey: .increment)
        } catch {
            return []
        }
    }

    var weightPickerItems: [String: [(value: Double, displayValue: String)]] {
        return [
            "kg": kiloItems,
            "lbs": poundItems
        ]
    }

    var heightPickerItems: [String: [(value: Double, displayValue: String)]] {
        return [
            "cm": centimeterItems,
            "ft": feetItems
        ]
    }

    private var centimeterItems: [(value: Double, displayValue: String)] {
        var items = [(value: Double, displayValue: String)]()

        for value in stride(from: 0.0, to: 300.0, by: 1.0) {
            let item = (value, String(format: "%.0f", value))
            items.append(item)
        }
        return items
    }

    private var feetItems: [(value: Double, displayValue: String)] {
        var items = [(value: Double, displayValue: String)]()
        for feet in stride(from: 0, to: 100, by: 1.0) {
            for inch in stride(from: 0, to: 11, by: 1.0) {
                let item = (inch, String(format: "%.0f'%.0f''", feet, inch))
                items.append(item)
            }
        }
        return items
    }

    private var kiloItems: [(value: Double, displayValue: String)] {
        var items = [(value: Double, displayValue: String)]()
        for value in stride(from: 0.0, to: 300.0, by: 1.0) {
            let item = (value, String(format: "%.0f", value))
            items.append(item)
        }
        return items
    }

    private var poundItems: [(value: Double, displayValue: String)] {
        var items = [(value: Double, displayValue: String)]()
        for value in stride(from: 0.0, to: 300.0, by: 1.0) {
            let item = (value, String(format: "%.0f", value))
            items.append(item)
            print(item)
        }
        return items
    }

    private func incrementItems(for jsonString: String, jsonKey: JsonKey) throws -> [Double] {
        let json = try JSON(jsonString: jsonString)
        let units = try json.getArray()

        return try units.map { try $0.getItemValue(at: jsonKey) }
    }

    private func unitItems(for jsonString: String, jsonKey: JsonKey) throws -> [String] {
        let json = try JSON(jsonString: jsonString)
        let units = try json.getArray()

        return try units.map { try $0.getItemValue(at: jsonKey) }
    }
}
