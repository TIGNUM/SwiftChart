//
//  UINavigationBar+Style.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func applyDefaultStyle() {
        titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.H6NavigationTitle]
        let dummyImage = UIImage()
        setBackgroundImage(dummyImage, for: .default)
        shadowImage = dummyImage
        isTranslucent = true
    }

    func applyClearStyle() {
        titleTextAttributes = [.font: UIFont.ApercuBold15,
                               .foregroundColor: UIColor.white,
                               .kern: 0.88]
        let dummyImage = UIImage()
        setBackgroundImage(dummyImage, for: .default)
        shadowImage = dummyImage
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
    }

    func applyDarkBluryStyle() {
        titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.H6NavigationTitle]
        isTranslucent = true
        barStyle = .black
    }

    func applyNavyStyle() {
        titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.H6NavigationTitle]
        isTranslucent = false
        barTintColor = .navy
    }

    func applyNighModeStyle() {
        let dummyImage = UIImage()
        setBackgroundImage(dummyImage, for: .default)
        shadowImage = dummyImage
        isTranslucent = false
        barTintColor = .nightModeBackground
    }

    private func pointTest(button: UIBarButtonItem, point: CGPoint, with event: UIEvent?) -> Bool {
        if let view = button.value(forKey: "view") as? UIView {
            let position = view.convert(point, from: self)
            if view.point(inside: position, with: event) {
                return true
            }
        }
        return false
    }

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let items = items else { return true }

        for item in items {
            for item in item.leftBarButtonItems ?? [] {
                if pointTest(button: item, point: point, with: event) {
                    return true
                }
            }
            for item in item.rightBarButtonItems ?? [] {
                if pointTest(button: item, point: point, with: event) {
                    return true
                }
            }

            if let backBarButtonItem = item.backBarButtonItem,
                pointTest(button: backBarButtonItem, point: point, with: event) {
                return true
            }
        }
        return false
    }

}
