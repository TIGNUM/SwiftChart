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
                let dateString = $0.eventDate != nil ? DateFormatter.myPrepsTime.string(from: $0.eventDate!) : ""
                let prepItem = MyPrepsModel.Items(title: $0.eventTitle ?? "",
                                                  date: dateString,
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
            var prepItems = [RecoveriesModel.Items]()
            recoveries?.forEach {
                let prepItem = RecoveriesModel.Items(title: $0.fatigueAnswer?.title ?? "",
                                                  date: DateFormatter.myPrepsTime.string(from: $0.createdAt ?? Date(timeInterval: -3600, since: Date())),
                                                  qdmRec: $0)
                prepItems.append(prepItem)
            }
            self?.recModel = RecoveriesModel(prepItems: prepItems)
            completion(self?.recModel)
        }
    }

    func mindsetShifters(completion: @escaping (MindsetShiftersModel?) -> Void) {
        userService.getMindsetShifters { [weak self] (mindsetShifters, initialized, error) in
            var prepItems = [MindsetShiftersModel.Items]()
            mindsetShifters?.forEach {
                let prepItem = MindsetShiftersModel.Items(title: $0.triggerAnswer?.title ?? "",
                                                  date: DateFormatter.myPrepsTime.string(from: $0.createdAt ?? Date(timeInterval: -3600, since: Date())),
                                                  qdmMind: $0)
                prepItems.append(prepItem)
            }
            self?.mindModel = MindsetShiftersModel(prepItems: prepItems)
            completion(self?.mindModel)
        }
    }

    func createModels(completion: @escaping () -> Void) {
        createRecModel()
        createMindModel()
        createPrepModel(completion)
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

    func createPrepModel(_ completion: @escaping () -> Void) {
        preparations() { (myPrepsModel) in
            self.model = myPrepsModel
            completion()
        }
    }

    //TODO: Remove createMindModel and createRecModel
    func createMindModel() {
        let homeAnswerIds = [100036, 100037, 100038]
        let workAnswerIds = [100036, 100037, 100038]
        let lowPerformanceAnswerIds = [100036, 100037, 100038]
        let reactionsAnswerIds = [100036, 100037, 100038]
        let highPerformanceContentItemIds = [100034, 100035, 100037]
        let toBeVisionText = "Unit Tests have always nice benefits"
        let triggerAnswerId = 100036
        let title = "Pointless Meetings"
        qot_dal.UserService.main.createMindsetShifter(triggerAnswerId: triggerAnswerId,
                                                      toBeVisionText: toBeVisionText,
                                                      reactionsAnswerIds: reactionsAnswerIds,
                                                      lowPerformanceAnswerIds: lowPerformanceAnswerIds,
                                                      workAnswerIds: workAnswerIds,
                                                      homeAnswerIds: homeAnswerIds,
                                                      highPerformanceContentItemIds: highPerformanceContentItemIds) { (mindsetShifter, error) in
                                                      let dateString = mindsetShifter?.createdAt != nil ? DateFormatter.myPrepsTime.string(from: (mindsetShifter?.createdAt!)!) : ""
                                                      let items = MindsetShiftersModel.Items(title: title, date: dateString, qdmMind: mindsetShifter! )
                                                      let myModel = MindsetShiftersModel(prepItems: [items])
                                                      self.mindModel = myModel
        }
    }

    func createRecModel() {
        let fatigueAnswerId = 100036
        let causeAnwserId = 100037
        let causeContentItemId = 100034
        let exclusiveContentCollectionIds = [100025, 100026, 100028]
        let suggestedSolutionsContentCollectionIds = [100029, 100030, 100031]
        let title = "Lack of Coordination"
         qot_dal.UserService.main.createRecovery3D(fatigueAnswerId: fatigueAnswerId,
                                                   causeAnwserId: causeAnwserId,
                                                   causeContentItemId: causeContentItemId,
                                                   exclusiveContentCollectionIds: exclusiveContentCollectionIds,
                                                   suggestedSolutionsContentCollectionIds: suggestedSolutionsContentCollectionIds) { (recovery3D, error) in
                                                    let dateString = recovery3D?.createdAt != nil ? DateFormatter.myPrepsTime.string(from: (recovery3D?.createdAt!)!) : ""
                                                    let items = RecoveriesModel.Items(title: title, date: dateString, qdmRec: recovery3D!)
                                                    let myModel = RecoveriesModel(prepItems: [items])
                                                    self.recModel = myModel
        }
    }
}
