//
//  Swizzle.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol Swizzle {
    var classID: AnyClass { get }
    var originalSelector: Selector { get }
    var newSelector: Selector { get }
    var originalMethod: Method? { get }
    var newMethod: Method? { get }
    var isSwizzled: Bool { get set } // @note: initial value should be false
    
    mutating func swizzle()
}

extension Swizzle {
    mutating func swizzle() {
        isSwizzled = !isSwizzled
        if
            let originalMethod = originalMethod,
            let newMethod = newMethod {
                method_exchangeImplementations(originalMethod, newMethod)
        }
    }
}
