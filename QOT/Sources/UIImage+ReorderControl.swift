//
//  UIImage+ReorderControl.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 17/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UIImage {
    static func qot_reorderControlImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 7, height: 17))

        let image = renderer.image { ctx in
            drawImage(in: ctx.cgContext)
        }
        return image
    }

    private static func drawImage(in context: CGContext) {
        context.setFillColor(UIColor.accent75.cgColor)
        context.setStrokeColor(UIColor.accent75.cgColor)

        let space = 3
        let dimension = 2
        for x in 0...1 {
            for y in 0...3 {
                let offset = (space+dimension)
                let rectangle = CGRect(x: x*offset, y: y*offset, width: dimension, height: dimension)
                context.fill(rectangle)
            }
        }
    }
}
