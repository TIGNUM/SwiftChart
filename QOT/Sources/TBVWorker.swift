//
//  TBVWorker.swift
//  QOT
//
//  Created by karmic on 14.09.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class TBVWorker {
    func createVision(selectedAnswers: [SelectedAnswer],
                      questionKeyWork: String,
                      questionKeyHome: String,
                      shouldSave: Bool = false,
                      completion: @escaping (QDMToBeVision?) -> Void) {
        let workIds = getSelectedIds(selectedAnswers, questionKeyWork)
        let homeIds = getSelectedIds(selectedAnswers, questionKeyHome)

        UserService.main.generateToBeVisionWith(homeIds, workIds) { (vision, error) in
            if let error = error {
                log("Error generateToBeVisionWith: \(error.localizedDescription)", level: .error)
            }

            completion(vision)
            guard var newVision = vision else { return }
            if shouldSave, SessionService.main.getCurrentSession() != nil {
                UserService.main.updateMyToBeVision(newVision, { (error) in /* WOW ;) */})
            }
        }
    }

    func getUsersTBV(_ completion: @escaping (QDMToBeVision?, Bool) -> Void) {
        UserService.main.getMyToBeVision { (tbv, initiated, error) in
            if let error = error {
                log("Error getMyToBeVision: \(error.localizedDescription)", level: .error)
            }
            completion(tbv, initiated)
        }
    }

    func save(_ image: UIImage) {
        saveToBeVisionImage(image) { (error) in
            if let error = error {
                log("Error updateMyToBeVision: \(error.localizedDescription)", level: .error)
            }
        }
    }

    func saveToBeVisionImage(_ image: UIImage, completion: @escaping (Error?) -> Void) {
        do {
            let imageURL = try image.save(withName: UUID().uuidString).absoluteString
            UserService.main.getMyToBeVision { (vision, _, _) in
                if var vision = vision {
                    vision.profileImageResource = QDMMediaResource()
                    vision.profileImageResource?.localURLString = imageURL
                    vision.modifiedAt = Date()
                    UserService.main.updateMyToBeVision(vision) { (error) in
                        completion(error)
                    }
                }
            }
        } catch {
            log("Error save TBV image: \(error.localizedDescription)", level: .error)
        }
    }

    // MARK: - Helper
    func getSelectedIds(_ selectedAnswers: [SelectedAnswer], _ questionKey: String) -> [Int] {
        return selectedAnswers
            .filter { $0.question?.key == questionKey }
            .first?.answers
            .compactMap { $0.targetId(.content) } ?? []
    }
}
