//
//  WaitBlockOperation.swift
//  QOT
//
//  Created by Lee Arromba on 21/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class WaitBlockOperation: ConcurrentOperation {
    let block: (@escaping () -> Void) -> Void

    init(block: @escaping (@escaping () -> Void) -> Void) {
        self.block = block
    }

    override func execute() {
        block({ [unowned self] in
            self.finish()
        })
    }
}
