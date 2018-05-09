//
//  SettingFormat.swift
//  QOT
//
//  Created by Sam Wyndham on 07.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

enum SettingFormat: String, JSONDecodable {
    case boolean = "BOOLEAN"
    case int = "LONG"
    case text = "TEXT"
    case occurrence = "OCCURRENCE"
}
