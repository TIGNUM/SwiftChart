//
//  MyToBeVisionTrackerWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TBVRateHistoryWorker: WorkerTeam {

    lazy var title = isDataType ? AppTextService.get(.my_qot_my_tbv_tbv_tracker_data_section_header_title) :
                                  AppTextService.get(.my_qot_my_tbv_tbv_tracker_result_section_header_title)

    lazy var subtitle = isDataType ? AppTextService.get(.my_qot_my_tbv_tbv_tracker_data_section_header_subtitle) :
                                     AppTextService.get(.my_qot_my_tbv_tbv_tracker_result_section_header_body)

    lazy var isDataType = displayType == .data
    lazy var teamHeader = AppTextService.get(.my_x_team_tbv_tracker_data_header_title)
    lazy var teamSubtitle = AppTextService.get(.my_x_my_tbv_tbv_tracker_data_section_team_header)
    lazy var teamTitle = AppTextService.get(.my_x_team_tbv_tracker_data_title)
    lazy var graphTitle = AppTextService.get(.my_qot_my_tbv_tbv_tracker_data_section_my_tbv_title)
    private let displayType: TBVGraph.DisplayType
    private let team: QDMTeam?
    var dataModel: ToBeVisionReport?

    init(_ displayType: TBVGraph.DisplayType, team: QDMTeam?) {
        self.displayType = displayType
        self.team = team
    }

    func getData(_ completion: @escaping (ToBeVisionReport?) -> Void) {
        if let team = team {
            getTeamReport(team, completion)
        } else {
            getPersonalReport(completion)
        }
    }

    func setSelection(for date: Date) {
        dataModel?.selectedDate = date
    }

    var sentences: [QDMToBeVisionSentence] {
        if let dataModel = dataModel {
            return dataModel.report.sentences.filter { ($0.ratings[dataModel.selectedDate] ?? -1) > 0 }.sorted(by: { $0.sortOrder < $1.sortOrder })
        }
        return []
    }

    var selectedDate: Date {
        return dataModel?.selectedDate ?? Date()
    }

    var average: [Date: Double] {
        return dataModel?.report.averages ?? [:]
    }

    var days: [Date] {
        return dataModel?.report.dates.sorted(by: <) ?? []
    }
}

// MARK: - Private
private extension TBVRateHistoryWorker {
    func getPersonalReport(_ completion: @escaping (ToBeVisionReport) -> Void) {
        UserService.main.getToBeVisionTrackingReport(last: 3) { [weak self] (report) in
            guard let strongSelf = self, let date = report.dates.sorted(by: <).last else { return }
            strongSelf.dataModel = ToBeVisionReport(title: strongSelf.title,
                                                    subtitle: strongSelf.subtitle,
                                                    selectedDate: date,
                                                    report: report)
            completion(strongSelf.dataModel!)
        }
    }

    func getTeamReport(_ team: QDMTeam, _ completion: @escaping (ToBeVisionReport?) -> Void) {
        getLatestClosedPolls(for: team) { [weak self] (polls) in
            if let polls = polls, polls.isEmpty == false {
                UserService.main.getTeamToBeVisionTrackingReport(polls: polls) { (report) in
                    if let strongSelf = self,
                       let date = report.dates.sorted(by: <).last {
                        strongSelf.dataModel = ToBeVisionReport(title: strongSelf.title,
                                                                subtitle: strongSelf.subtitle,
                                                                selectedDate: date,
                                                                report: report)
                        completion(strongSelf.dataModel)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
