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
    private let userService = qot_dal.UserService.main
    var model: MyPrepsModel?
    var recModel: RecoveriesModel?
    var mindModel: MindsetShiftersModel?

    // MARK: - Functions
    func preparations(completion: @escaping (MyPrepsModel?) -> Void) {
        userService.getUserPreparations { [weak self] (preparations, initialized, error) in
            var prepItems = [MyPrepsModel.Items]()
            preparations?.forEach {
                let dateString = $0.eventDate?.eventDateString
                let prepItem = MyPrepsModel.Items(title: $0.name ?? "",
                                                  date: dateString ?? "",
                                                  eventType: $0.eventType ?? "",
                                                  qdmPrep: $0)
                prepItems.append(prepItem)
            }
            self?.model = MyPrepsModel(prepItems: prepItems)
            completion(self?.model)
        }
    }

    func recoveries(completion: @escaping (RecoveriesModel?) -> Void) {
        qot_dal.UserService.main.getRecovery3D { [weak self] (recoveries, initialized, error) in
            var recoveryItems = [RecoveriesModel.Items]()
            recoveries?.forEach {
                let recoveryItem = RecoveriesModel.Items(title: $0.causeAnwser?.subtitle ?? "",
                                                         date: $0.createdAt?.eventDateString ?? "",
                                                         qdmRec: $0)
                recoveryItems.append(recoveryItem)
            }
            self?.recModel = RecoveriesModel(prepItems: recoveryItems)
            completion(self?.recModel)
        }
    }

    func mindsetShifters(completion: @escaping (MindsetShiftersModel?) -> Void) {
        userService.getMindsetShifters { [weak self] (mindsetShifters, initialized, error) in
            var mindsetItems = [MindsetShiftersModel.Items]()
            mindsetShifters?.forEach {
                let mindsetItem = MindsetShiftersModel.Items(title: $0.triggerAnswer?.subtitle ?? "",
                                                             date: $0.createdAt?.eventDateString ?? "",
                                                             qdmMind: $0)
                mindsetItems.append(mindsetItem)
            }
            self?.mindModel = MindsetShiftersModel(prepItems: mindsetItems)
            completion(self?.mindModel)
        }
    }

    func createModels(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        preparations(completion: { (myPrepsModel) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.enter()
        recoveries(completion: { (myPrepsModel) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.enter()
        mindsetShifters(completion: { (myPrepsModel) in
            dispatchGroup.leave()
            completion()
        })
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}

extension MyPrepsWorker {
    func remove(segmentedControl: Int, at indexPath: IndexPath, completion: @escaping () -> Void) {
        if segmentedControl == 0 {
            if let qdmPrep = model?.prepItems[indexPath.row].qdmPrep {
                PreparationManager.main.delete(preparation: qdmPrep) { [weak self] in
                    self?.model?.prepItems.remove(at: indexPath.row)
                    completion()
                }
            }
        } else if segmentedControl == 1 {
            if let qdmMind = mindModel?.prepItems[indexPath.row].qdmMind {
            MindsetShiftersManager.main.delete(mindsetShifter: qdmMind) { [weak self] in
                self?.mindModel?.prepItems.remove(at: indexPath.row)
                completion()
                }
            }
        } else if segmentedControl == 2 {
            if let qdmRec = recModel?.prepItems[indexPath.row].qdmRec {
            Recovery3DManager.main.delete(recovery: qdmRec) { [weak self] in
                self?.recModel?.prepItems.remove(at: indexPath.row)
                completion()
                }
            }
        }
    }
}
