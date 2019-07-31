//
//  MySprintsInfoAlertViewModel.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 24/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MySprintsInfoAlertViewModel {
    let isFullscreen: Bool
    let style: InfoAlertView.Style
    let icon: UIImage
    let title: String
    let message: NSAttributedString
    let transparent: Bool
}
