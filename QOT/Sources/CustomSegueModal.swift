//
//  CustomSegueModal.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 19/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class CustomSegueModal: UIStoryboardSegue {
    private let duration: TimeInterval = 0.5

    override func perform() {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop

        source.view.window!.layer.add(transition, forKey: kCATransition)
        source.present(destination, animated: false, completion: nil)
    }
}
