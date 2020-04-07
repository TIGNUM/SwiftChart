//
//  StreamVideoConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.04.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class StreamVideoConfigurator {
    static func make(content: QDMContentItem?) -> (MediaPlayerViewController) -> Void {
        return { (viewController) in
        let worker = StreamVideoWorker(content: content)
        let presenter = StreamVideoPresenter(viewController: viewController)
        let interactor = StreamVideoInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
        }
    }
}
