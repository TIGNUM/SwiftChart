//
//  Extensions.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIFont

extension UIFont {
    
    internal class func simpleFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.simple.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    internal class func bentonBookFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    internal class func bentonRegularFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonRegular.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {

    internal class func create(for string: String, withColor color: UIColor, andFont font: UIFont, letterSpacing: CGFloat = 1) -> NSAttributedString {
        let attributes: [String: Any] = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: font,
            NSKernAttributeName: letterSpacing
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
}

// MARK String

extension String {

    static func realmSectionFilter(filter: String) -> String {
        return String(format: "section == '%@'", filter)
    }
}

// MARK: - UIBezierPath

extension UIBezierPath {

    class func circlePath(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(Double.pi * 2)

        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
    }

    class func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, radius: CGFloat = -1) -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(sides)
        let width = min(rect.size.width, rect.size.height)
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        let radius = radius != -1 ? radius :(width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0..<sides {
            angle += theta
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }

        path.close()
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
}

// MARK: - CALayer

extension CALayer {

    func addGlowEffect(color: UIColor, shadowRadius: CGFloat = 10, shadowOpacity: Float = 0.9) {
        self.shadowColor = color.cgColor
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.shadowOffset = .zero
    }

    func removeGlowEffect() {
        self.shadowColor = UIColor.clear.cgColor
        self.shadowRadius = 0
        self.shadowOpacity = 0
        self.shadowOffset = .zero
    }
}

// MARK: - CAShapeLayer

extension CAShapeLayer {

    override func addGlowEffect(color: UIColor, shadowRadius: CGFloat = 10, shadowOpacity: Float = 0.9) {
        super.addGlowEffect(color: color, shadowRadius: shadowRadius, shadowOpacity: shadowOpacity)
    }

    class func circle(center: CGPoint, radius: CGFloat, fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius).cgPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = 1.0
        return shapeLayer
    }

    class func line(from fromPoint: CGPoint, to toPoint: CGPoint, strokeColor: UIColor) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        line.path = linePath.cgPath
        line.strokeColor = strokeColor.cgColor
        line.lineWidth = 0.4
        return line
    }
}

// MARK: - FloatingPoint

extension FloatingPoint {

    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

// MARK: - Collection

extension MutableCollection where Index == Int {

    mutating func shuffle() {
        guard count > 2 else {
            return
        }

        for index in startIndex ..< endIndex - 1 {
            let element = Int(arc4random_uniform(UInt32(endIndex - index))) + index
            if index != element {
                swap(&self[index], &self[element])
            }
        }
    }
}

extension Collection {

    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
}

// MAARK: - UIView

extension UIView {

    func removeSubViews() {
        subviews.forEach({ (subView: UIView) in
            subView.removeFromSuperview()
        })
    }

    func removeSubLayers() {
        layer.sublayers?.forEach({ (subLayer: CALayer) in
            subLayer.removeFromSuperlayer()
        })
    }
}

// MARK: - UIImage

extension UIImage {

    func convertToGrayScale() -> UIImage? {
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setDefaults()
        filter?.setValue(CoreImage.CIImage(image: self), forKey: kCIInputImageKey)

        guard
            let outputImage = filter?.outputImage,
            let cgImage = CIContext(options:nil).createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

// MARK: - UIImageView

extension UIImageView {

    convenience init(frame: CGRect, image: UIImage?) {
        self.init(frame: frame)
        self.image = image
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = frame.width * 0.5
        self.clipsToBounds = true
    }

    func setupHexagonImageView(lineWidth: CGFloat = 0) {
        let frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width + 5, height: self.bounds.size.height + 5)
        let path = UIBezierPath.roundedPolygonPath(rect: frame, lineWidth: lineWidth, sides: 6, cornerRadius: 0, rotationOffset: CGFloat(CGFloat.pi * 0.5))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        self.layer.mask = mask
    }
}

// MARK: - UIScrollView

extension UIScrollView {

    var currentPage: Int {
        guard bounds.size.width != 0 else {
            return 0
        }

        return Int(round(contentOffset.x / bounds.size.width))
    }
}
