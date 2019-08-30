//
//  BottomNavigationContainer.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 20.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

class BottomNavigationContainer: UIView {

    static private var _height: CGFloat?
    static public var height: CGFloat {
        if _height == nil {
            _height = 100
        }
        return _height!
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) as? UIButton ?? super.hitTest(point, with: event) as? UISlider else {
            return nil
        }
        return view
    }
}
