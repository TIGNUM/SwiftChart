//
//  MindsetShiftersManager.swift
//  QOT
//
//  Created by Anais Plancoulaine on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MindsetShiftersManager {

    private let userService: qot_dal.UserService?
    static var main = MindsetShiftersManager()

    private init() {
        self.userService = qot_dal.UserService.main
    }
}

extension MindsetShiftersManager {

    func update(mindsetShifter: QDMMindsetShifter, _ completion: @escaping (QDMMindsetShifter?) -> Void) {
        userService?.updateMindsetShifter(mindsetShifter) { (mindsetShifter, error) in
            if let error = error {
                log("Error while trying to update mindsetShifter: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion(mindsetShifter)
        }
    }

    func delete(mindsetShifter: QDMMindsetShifter, completion: @escaping () -> Void) {
        userService?.deleteMindsetShifter(mindsetShifter) { (error) in
            if let error = error {
                log("Error while trying to delete mindsetshifter: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion()
        }
    }

    func getAll(_ completion: @escaping (_ mindsetShifters: [QDMMindsetShifter]?) -> Void) {
        userService?.getMindsetShifters { (mindsetShifters, initialized, error) in
            if let error = error {
                log("Error while trying to get mindset shifters: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion(mindsetShifters)
        }
    }


    func get(for qotId: String, _ completion: @escaping (_ preparation: QDMMindsetShifter?) -> Void) {
        userService?.getMindsetShifters{ (mindsetShifters, initialized, error) in
            if let error = error {
                log("Error while trying to get mindsetShifters: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            let mindsetShifter = mindsetShifters?.filter { $0.qotId == qotId }.first
            completion(mindsetShifter)
        }
    }
}
