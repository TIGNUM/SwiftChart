//
//  PreparationStepIntermediary.swift
//  QOT
//
//  Created by Sam Wyndham on 26.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Freddy

struct PreparationCheckIntermediary: DownSyncIntermediary {

    let preparationID: Int
    let contentID: Int
    let contentItemID: Int
    var covered: Date?
    
    init(json: JSON) throws {
        self.preparationID = try json.getItemValue(at: .userPreparationId)
        self.contentID = try json.getItemValue(at: .contentId)
        self.contentItemID = try json.getItemValue(at: .contentItemId)
        
        do {
            self.covered = try json.getDate(at: .covered)
        } catch {
            self.covered = nil
        }
    }
}
