//
//  CustomSeguePush.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 20/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class CustomSeguePush: UIStoryboardSegue {
    private let duration: TimeInterval = 0.25

    override func perform() {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop

        source.view.window!.layer.add(transition, forKey: kCATransition)
        source.present(destination, animated: false, completion: nil)
    }
}
