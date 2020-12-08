//
//  NewTheme.swift
//  QOT
//
//  Created by karmic on 07.12.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

enum NewThemeView {
    case dark
    case light

    enum Radius {
        case round20
        case circle
        case none
    }

    var color: UIColor {
        switch self {
        case .dark: return .black
        case .light: return .white
        }
    }

    func apply(_ view: UIView, alpha: CGFloat = 1, with radius: Radius = .none) {
        switch radius {
        case .round20:
            view.corner(radius: 20)
        case .circle:
            view.corner(radius: view.frame.size.height * 0.5)
        case .none:
            break
        }
        view.backgroundColor = color.withAlphaComponent(alpha)
    }
}
