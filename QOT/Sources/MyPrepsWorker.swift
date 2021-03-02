//
//  MyPrepsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyPrepsWorker {

    // MARK: - Properties
    var model: MyPrepsModel?
    var recModel: RecoveriesModel?
    var mindModel: MindsetShiftersModel?

    // MARK: - Functions
    func preparations(completion: @escaping (MyPrepsModel?) -> Void) {
        UserService.main.getUserPreparations { [weak self] (preparations, _, _) in
            var criticalItems = [MyPrepsModel.Item]()
            var everydayItems = [MyPrepsModel.Item]()
            preparations?.forEach { (preparation) in
                let dateString = DateFormatter.ddMMM.string(from: preparation.eventDate ?? Date())
                let prepItem = MyPrepsModel.Item(title: preparation.name ?? preparation.eventType ?? "",
                                                 date: dateString,
                                                 eventType: preparation.eventType ?? "",
                                                 type: preparation.type ?? "",
                                                 missingEvent: preparation.missingEvent,
                                                 calendarEventTitle: preparation.eventTitle ?? "",
                                                 qdmPrep: preparation)
                if preparation.type == "critical" {
                    criticalItems.append(prepItem)
                } else {
                    everydayItems.append(prepItem)
                }
            }
            let sortedCriticalItems = criticalItems.sorted(by: { $0.qdmPrep.eventDate ?? Date.distantFuture < $1.qdmPrep.eventDate ?? Date.distantFuture })
            let sortedEverydayItems = everydayItems.sorted(by: { $0.qdmPrep.eventDate ?? Date.distantFuture < $1.qdmPrep.eventDate ?? Date.distantFuture })
            self?.model = MyPrepsModel(items: [sortedCriticalItems, sortedEverydayItems])
            completion(self?.model)
        }
    }

    func recoveries(completion: @escaping (RecoveriesModel?) -> Void) {
        UserService.main.getRecovery3D { [weak self] (recoveries, _, _) in
            var recoveryItems = [RecoveriesModel.Item]()
            recoveries?.forEach {
                let recoveryItem = RecoveriesModel.Item(title: $0.causeAnwser?.subtitle ?? "",
                                                         date: DateFormatter.ddMMM.string(from: $0.createdAt ?? Date()),
                                                         qdmRec: $0)
                recoveryItems.append(recoveryItem)
            }
            let items = recoveryItems.sorted(by: { $0.qdmRec.createdAt ?? Date.distantFuture < $1.qdmRec.createdAt ?? Date.distantFuture })
            self?.recModel = RecoveriesModel(items: items)
            completion(self?.recModel)
        }
    }

    func mindsetShifters(completion: @escaping (MindsetShiftersModel?) -> Void) {
        UserService.main.getMindsetShifters { [weak self] (mindsetShifters, _, _) in
            var mindsetItems = [MindsetShiftersModel.Item]()
            mindsetShifters?.forEach {
                let mindsetItem = MindsetShiftersModel.Item(title: $0.triggerAnswer?.subtitle ?? "",
                                                             date: DateFormatter.ddMMM.string(from: $0.createdAt ?? Date()),
                                                             qdmMind: $0)
                mindsetItems.append(mindsetItem)
            }
            let items = mindsetItems.sorted(by: { $0.qdmMind.createdAt ?? Date.distantFuture < $1.qdmMind.createdAt ?? Date.distantFuture })
            self?.mindModel = MindsetShiftersModel(items: items)
            completion(self?.mindModel)
        }
    }

    func createModels(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        preparations(completion: { (_) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.enter()
        recoveries(completion: { (_) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.enter()
        mindsetShifters(completion: { (_) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }

    func getViewModel() -> MyPlansViewModel {
        return MyPlansViewModel(title: AppTextService.get(.my_qot_my_plans_section_header_title),
                                titleEditMode: AppTextService.get(.my_qot_my_plans_section_header_title_edit),
                                myPrepsTitle: AppTextService.get(.my_qot_my_plans_event_preps_null_state_title),
                                myPrepsBody: AppTextService.get(.my_qot_my_plans_event_preps_null_state_body),
                                mindsetShifterTitle: AppTextService.get(.my_qot_my_plans_mindset_shifts_null_state_title),
                                mindsetShifterBody: AppTextService.get(.my_qot_my_plans_mindset_shifts_null_state_body),
                                recoveryTitle: AppTextService.get(.my_qot_my_plans_recovery_plans_null_state_title),
                                recoveryBody: AppTextService.get(.my_qot_my_plans_recovery_plans_null_state_body))
    }
}

extension MyPrepsWorker {
    func remove(segmentedControl: Int, at indexPath: IndexPath, completion: @escaping () -> Void) {
            if segmentedControl == .zero {
                let item = model?.items[indexPath.section][indexPath.row]
                if let qdmPrep = item?.qdmPrep {
                    let externalIdentifier = qdmPrep.eventExternalUniqueIdentifierId?.components(separatedBy: "[//]").first
                    WorkerCalendar().deleteLocalEvent(externalIdentifier)
                    UserService.main.deleteUserPreparation(qdmPrep) { [weak self] (error) in
                        if let error = error {
                            log("Error deleteUserPreparation: \(error.localizedDescription)", level: .error)
                        }
                        self?.model?.items[indexPath.section].remove(at: indexPath.row)
                        completion()
                    }
                }
            } else if segmentedControl == 1 {
                if let qdmMind = mindModel?.items[indexPath.row].qdmMind {
                    UserService.main.deleteMindsetShifter(qdmMind) { [weak self] (error) in
                        if let error = error {
                            log("Error deleteMindsetShifter: \(error.localizedDescription)", level: .error)
                        }
                        self?.mindModel?.items.remove(at: indexPath.row)
                        completion()
                    }
                }
            } else if segmentedControl == 2 {
                if let qdmRec = recModel?.items[indexPath.row].qdmRec {
                    UserService.main.deleteRecovery3D(qdmRec) { [weak self] (error) in
                        if let error = error {
                            log("Error deleteRecovery3D: \(error.localizedDescription)", level: .error)
                        }
                        self?.recModel?.items.remove(at: indexPath.row)
                        completion()
                    }
                }
            }
        }
}
