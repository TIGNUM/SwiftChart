//
//  DecisionTreeWorker+TBV.swift
//  QOT
//
//  Created by karmic on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

extension DecisionTreeWorker {
    func fetchToBeVision() {
        qot_dal.UserService.main.getMyToBeVision { [weak self] (vision, status, _) in
            self?.visionText = vision?.text
        }
    }

    var workQuestion: QDMQuestion? {
        switch type {
        case .toBeVisionGenerator:
            return questions.filter { $0.key == QuestionKey.ToBeVision.Work }.first
        case .mindsetShifterTBV,
             .mindsetShifterTBVOnboarding:
            return questions.filter { $0.key == QuestionKey.MindsetShifterTBV.Work }.first
        default: return nil
        }
    }

    var homeQuestion: QDMQuestion? {
        switch type {
        case .toBeVisionGenerator:
            return questions.filter { $0.key == QuestionKey.ToBeVision.Home }.first
        case .mindsetShifterTBV,
             .mindsetShifterTBVOnboarding:
            return questions.filter { $0.key == QuestionKey.MindsetShifterTBV.Home }.first
        default: return nil
        }
    }

    /// Generates the vision based on the list of selected `Answer`
    func createVision(from answers: [QDMAnswer], completion: @escaping (String) -> Void) {
        var workSelections: [QDMAnswer] = []
        var homeSelections: [QDMAnswer] = []
        for answer in answers {
            workQuestion?.answers.forEach {
                if $0.remoteID == answer.remoteID {
                    workSelections.append(answer)
                }
            }
            homeQuestion?.answers.forEach {
                if $0.remoteID == answer.remoteID {
                    homeSelections.append(answer)
                }
            }
        }
        string(from: workSelections) { (workVision) in
            self.string(from: homeSelections) { (homeVision) in
                let vision = [workVision, homeVision].joined(separator: "\n\n")
                self.updateVisionText(vision)
                self.createdTBV = (vision, workSelections.compactMap { $0.subtitle }, homeSelections.compactMap { $0.subtitle })
                completion(vision)
            }
        }
    }

    func string(from answers: [QDMAnswer], completion: @escaping (String) -> Void) {
        var visionList: [String] = []
        let targetIDs = answers.compactMap { $0.decisions.first(where: { $0.targetType == TargetType.content.rawValue })?.targetTypeId }
        qot_dal.UserService.main.getUserData { (user) in
            qot_dal.ContentService.main.getContentCollectionsByIds(targetIDs) { (contentCollections) in
                contentCollections?.forEach { (contentCollection) in
                    let userGender = user?.gender.uppercased() ?? "NEUTRAL"
                    let genderQueryNeutral = "GENDER_NEUTRAL"
                    let genderQuery = String(format: "GENDER_%@", userGender)
                    let filteredItems = contentCollection.contentItems.filter {
                        $0.searchTags.contains(genderQuery) || $0.searchTags.contains(genderQueryNeutral)
                    }
                    if filteredItems.isEmpty == false {
                        let randomItemText = filteredItems[filteredItems.randomIndex].valueText
                        visionList.append(randomItemText)
                    }
                }
                completion(visionList.joined(separator: " "))
            }
        }
    }

    func updateVisionText(_ visionText: String) {
        qot_dal.UserService.main.getMyToBeVision { (vision, _, _) in
            if var tmpVision = vision {
                tmpVision.text = visionText
                qot_dal.UserService.main.updateMyToBeVision(tmpVision) { (error) in
                    if let error = error {
                        qot_dal.log("Error while updating TBV: \(error.localizedDescription)", level: .error)
                    }
                }
            }
        }
    }

    func saveToBeVision(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        do {
            let imageURL = try image.save(withName: UUID().uuidString).absoluteString
            qot_dal.UserService.main.getMyToBeVision { (vision, _, _) in
                if var vision = vision {
                    vision.profileImageResource = QDMMediaResource()
                    vision.profileImageResource?.localURLString = imageURL
                    vision.modifiedAt = Date()
                    qot_dal.UserService.main.updateMyToBeVision(vision) { (error) in
                        completion(error)
                    }
                }
            }
        } catch {
            qot_dal.log("Error while saving TBV imag: \(error.localizedDescription)", level: .error)
        }
    }
}

extension DecisionTreeWorker {
    func showTBV(targetQuestionId: Int) {
        if userHasToBeVision == false {
            interactor?.openShortTBVGenerator { [weak self] in
                self?.showNextQuestion(targetId: Prepare.Key.perceived.questionID)
            }
        } else {
            showNextQuestion(targetId: targetQuestionId)
        }
    }
}
