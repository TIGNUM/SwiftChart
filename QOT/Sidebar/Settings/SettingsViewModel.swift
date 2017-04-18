//
//  SettingsViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

struct Setting {
    enum `Data` {
        case bool(value: Bool)
        case integer(min: Int, max: Int, value: Int)
        case text(value: String)
    }
    
    let title: String
    private(set) var data: Data
    
    fileprivate mutating func update(value: Any) {
        func coerce<T>(_ value: Any) -> T {
            guard let coerced = value as? T else {
                fatalError("Failed to update \(self) with value: ()")
            }
            return coerced
        }

        switch data {
        case .bool(_):
            self.data = .bool(value: coerce(value))
        case .integer(let min, let max, _):
            self.data = .integer(min: min, max: max, value: coerce(value))
        case .text(_):
            self.data = .text(value: coerce(value))
        }
    }
}

final class SettingsViewModel {
    private var settings: [Setting] = mockSettings()
    
    func updateSetting(at index: Index, value: Any) {
        settings[index].update(value: value)
    }
    
    var itemCount: Int {
        return settings.count
    }
    
    func item(at index: Index) -> Setting {
        return settings[index]
    }
}

private func mockSettings() -> [Setting] {
    return [
        Setting(title: "Name", data: .text(value: "John")),
        Setting(title: "Receive Push Notifications", data: .bool(value: false)),
        Setting(title: "Maximum Push Notifications", data: .integer(min: 0, max: 50, value: 10))
    ]
}
