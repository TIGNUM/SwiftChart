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

    var weightPickerItems: [[String]] {
        return [
            items,
            weightUnitItems
        ]
    }

    var heightPickerItems: [[String]] {
        return [
            items,
            heightUnitItems
        ]
    }

    private var items: [String] {
        var items = [String]()
        for weight in 0...634 {
            items.append(String(format: "%d", weight))
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
