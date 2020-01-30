//
//  MyQOTAdminChooseBucketsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQOTAdminChooseBucketsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQOTAdminChooseBucketsWorker()
    private let presenter: MyQOTAdminChooseBucketsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQOTAdminChooseBucketsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQOTAdminChooseBucketsInteractorInterface
extension MyQOTAdminChooseBucketsInteractor: MyQOTAdminChooseBucketsInteractorInterface {
    func getHeaderTitle() -> String {
        return "DAILY CHECKIN BUCKETS"
    }

    func getDoneButtonTitle() -> String {
        return AppTextService.get(.daily_brief_daily_check_in_questionnaire_section_footer_button_done)
    }

    func getDatasourceCount() -> Int {
        return worker.datasource.count
    }

    func getBucketTitle(at index: Int) -> String {
        return worker.datasource[index].key
    }

    func isSelected(at index: Int) -> Bool {
        return worker.datasource[index].value
    }

    func setSelected(_ selected: Bool, at index: Int) {
        worker.datasource[index].value = selected
    }

    func showSelectedBucketsInDailyBrief() {
        var selectedBuckets: [DailyBriefBucketName] = []
        for object in worker.datasource where object.value {
            selectedBuckets.append(object.key)
        }
        DailyBriefService.main.setGeneratedBucketNamesForToday(bucketNames: selectedBuckets)
    }
}
