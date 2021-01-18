//
//  UINavigationController+Extension.swift
//  QOT
//
//  Created by Anais Plancoulaine on 04.11.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

extension UINavigationController {

    func popViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
