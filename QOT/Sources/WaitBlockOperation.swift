//
//  WaitBlockOperation.swift
//  QOT
//
//  Created by Lee Arromba on 21/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class WaitBlockOperation: ConcurrentOperation {
    // @note optional block parameter because of possible swift @escaping bug
    // if you try to escape the parameter, it doesnt compile with "Cannot convert value of type '(((() -> Void))?) -> ()' to expected argument type '((() -> Void)) -> Void'"
    // safe to assume it's never nil, @see implementation in execute()
    let block: (((() -> Void)?) -> Void)

    init(block: @escaping (((() -> Void)?) -> Void)) {
        self.block = block
    }

    override func execute() {
        block({ [unowned self] in
            self.finish()
        })
    }
}
