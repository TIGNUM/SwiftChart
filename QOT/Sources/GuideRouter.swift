//
//  GuideRouter.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol GuideRouterInput {

    func showMorningInterView()
}

final class GuideRouter: GuideRouterInput {

    weak var morningInterViewController: MorningInterviewViewController!

    func showMorningInterView() {
        
    }

    func passDataToNextScene() {
        
    }
}
