//
//  MyDataScreenModel.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import qot_dal

struct MyDataModel {
    var date: Date?
    var sleepQuality: Double?
    var sleepQuantity: Double?
    var fenDaysLoad: Double?
    var fiveDayRollingRecovery: Double?
    var fiveDayRollingLoad: Double?
    var fiveDayImpactReadiness: Double?
    
    init(withDailyCheckInResult: QDMDailyCheckInResult) {
        
    }
}

enum MyDataSection: Int, CaseIterable {
    case dailyImpact = 0
    case heatMap
    
    static var sectionValues: [MyDataSection] {
        return [.dailyImpact, .heatMap]
    }
}

struct MyDataScreenModel {
    let myDataItems: [Item]
    
    struct Item {
        let myDataSection: MyDataSection
        let title: String?
        let subtitle: String?
    }
    
    // MARK: - Properties
    
    func sectionItem(at index: Int) -> MyDataSection {
        return MyDataSection.sectionValues.item(at: index)
    }
}
