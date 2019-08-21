//
//  MyDataScreenWorker.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit
import qot_dal

final class MyDataScreenWorker {

    // MARK: - Properties
    private let dataService: qot_dal.MyDataService

    // MARK: - Init
    
    init(dataService: qot_dal.MyDataService) {
        self.dataService = dataService
    }
    
//    func getMyDataResults() {
//        MyDataService.main.getDailyCheckInResults(from: Date().dateAfterDays(-10),
//                                                  to: Date(),
//                                                  { (result, initiated, error) in
//        })
//    }
}


extension MyDataScreenWorker: MyDataWorkerInterface {
    func myDataSections() -> MyDataScreenModel {
        return MyDataScreenModel(myDataItems: MyDataSection.allCases.map {
                        return MyDataScreenModel.Item(myDataSection: $0,
                                                      title: ScreenTitleService.main.myDataSectionTitles(for: $0),
                                                      subtitle: ScreenTitleService.main.myDataSectionSubtitles(for: $0))
        })
    }
}
