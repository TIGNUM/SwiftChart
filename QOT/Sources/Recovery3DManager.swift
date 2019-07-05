//
//  3DRecoveryManager.swift
//  QOT
//
//  Created by Anais Plancoulaine on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class Recovery3DManager {

    private let userService: qot_dal.UserService?
    static var main = Recovery3DManager()

    private init() {
        self.userService = qot_dal.UserService.main
    }
}

extension Recovery3DManager {

    func update(recovery: QDMRecovery3D, _ completion: @escaping (QDMRecovery3D?) -> Void) {
        userService?.updateRecovery3D(recovery) { (recovery, error) in
            if let error = error {
                log("Error while trying to update 3D Recovery: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion(recovery)
        }
    }

    func delete(recovery: QDMRecovery3D, completion: @escaping () -> Void) {
        userService?.deleteRecovery3D(recovery) { (error) in
            if let error = error {
                log("Error while trying to delete recovery: \(error.localizedDescription)", level: QDLogger.Level.debug)
            }
            completion()
        }
    }

//    func getAll(_ completion: @escaping (_ recoveries: [QDMRecovery3D]?) -> Void) {
//        userService?.getRecovery3Ds { (recoveries, initialized, error) in
//            if let error = error {
//                log("Error while trying to get recoveries: \(error.localizedDescription)", level: QDLogger.Level.debug)
//            }
//            completion(recoveries)
//        }
//    }
//
//    func get(for qotId: String, _ completion: @escaping (_ recovery: QDMRecovery3D?) -> Void) {
//        userService?.getRecovery3Ds { (recoveries, initialized, error) in
//            if let error = error {
//                log("Error while trying to get recoveries: \(error.localizedDescription)", level: QDLogger.Level.debug)
//            }
//            let recovery = recoveries?.filter { $0.qotId == qotId }.first
//            completion(recovery)
//        }
//    }
}
