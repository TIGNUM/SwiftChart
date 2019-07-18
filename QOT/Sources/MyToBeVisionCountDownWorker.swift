//
//  MyToBeVisionCountDownWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionCountDownWorker {

    private weak var delegate: MyToBeVisionCountDownViewControllerProtocol?

    init(delegate: MyToBeVisionCountDownViewControllerProtocol?) {
        self.delegate = delegate
    }

    func shouldSkip() {
        delegate?.shouldSkip()
    }

    func shouldDismiss() {
        delegate?.shouldDismiss()
    }
}
