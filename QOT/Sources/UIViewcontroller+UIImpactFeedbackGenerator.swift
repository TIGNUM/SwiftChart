//
//  UIViewcontroller+UIImpactFeedbackGenerator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 09/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

extension UIViewController {

    func generateFeedback(_ style: UIImpactFeedbackStyle = .heavy) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
