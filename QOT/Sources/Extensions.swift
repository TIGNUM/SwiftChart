//
//  Extensions.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import qot_dal

// MARK: - String

extension String {

    var removeFilePrefix: String {
        return replacingOccurrences(of: "file://", with: "")
    }
}

// MARK: - UIFont

extension UIFont {

    class func apercuBold(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.apercuBold.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func apercuLight(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.apercuLight.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func apercuMedium(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.apercuMedium.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func apercuRegular(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.apercuRegular.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProtextRegular(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProTextRegular.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProtextLight(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProTextLight.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProtextSemibold(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProTextSemiBold.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProtextMedium(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProTextMedium.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProDisplayRegular(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProDisplayRegular.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProDisplayLight(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProDisplayLight.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProDisplayThin(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProDisplayThin.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func sfProDisplayUltralight(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.sfProDisplayUltralight.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {

    internal class func create(for string: String, withColor color: UIColor, andFont font: UIFont, letterSpacing: CGFloat = 1) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [.foregroundColor: color,
                                                        .font: font,
                                                        .kern: letterSpacing]

        return NSAttributedString(string: string, attributes: attributes)
    }
}

// MARK: - UIBezierPath

extension UIBezierPath {

    class func hexagonPath(forRect rect: CGRect) -> UIBezierPath {
        return UIBezierPath(polygonIn: rect, sides: 6, lineWidth: 0, cornerRadius: 1, rotateByDegs: 180 / 6)
    }

    class func circlePath(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(Double.pi * 2)

        return UIBezierPath(arcCenter: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    }

    class func linePath(from: CGPoint, to: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        return path
    }

    // @see adapted from https://stackoverflow.com/questions/24767978/how-to-round-corners-of-uiimage-with-hexagon-mask
    /// Create UIBezierPath for regular polygon with rounded corners
    ///
    /// - parameter rect:            The CGRect of the square in which the path should be created.
    /// - parameter sides:           How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
    /// - parameter lineWidth:       The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square. Default value 1.
    /// - parameter cornerRadius:    The radius to be applied when rounding the corners. Default value 0.
    /// - parameter rotateByDegs:    The degrees to rotate the final polygon by. Default value 0.

    convenience init(polygonIn rect: CGRect, sides: Int, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0, rotateByDegs degs: CGFloat = 0) {
        self.init()

        let theta = 2 * CGFloat.pi / CGFloat(sides)                        // how much to turn at every corner
        let offset = cornerRadius * tan(theta / 2)                  // offset from which to start rounding corners
        let squareWidth = min(rect.size.width, rect.size.height)    // width of the square

        // calculate the length of the sides of the polygon

        var length = squareWidth - lineWidth
        if sides % 4 != 0 {                                         // if not dealing with polygon which will be square with all sides ...
            length = length * cos(theta / 2) + offset / 2           // ... offset it inside a circle inside the square
        }
        let sideLength = length * tan(theta / 2)

        // start drawing at `point` in lower right corner, but center it

        var point = CGPoint(x: rect.origin.x + rect.size.width / 2 + sideLength / 2 - offset, y: rect.origin.y + rect.size.height / 2 + length / 2)
        var angle = CGFloat.pi
        move(to: point)

        // draw the sides and rounded corners of the polygon

        for _ in 0 ..< sides {
            point = CGPoint(x: point.x + (sideLength - offset * 2) * cos(angle), y: point.y + (sideLength - offset * 2) * sin(angle))
            addLine(to: point)

            let center = CGPoint(x: point.x + cornerRadius * cos(angle + .pi / 2), y: point.y + cornerRadius * sin(angle + .pi / 2))
            addArc(withCenter: center, radius: cornerRadius, startAngle: angle - .pi / 2, endAngle: angle + theta - .pi / 2, clockwise: true)

            point = currentPoint
            angle += theta
        }

        close()

        if degs != 0 {
            // @see adapted from https://stackoverflow.com/questions/13738364/rotate-cgpath-without-changing-its-position
            let center = CGPoint(x: cgPath.boundingBox.midX, y: cgPath.boundingBox.midY)
            apply(CGAffineTransform(translationX: center.x, y: center.y).inverted())
            apply(CGAffineTransform(rotationAngle: degs * (CGFloat.pi / 180)))
            apply(CGAffineTransform(translationX: center.x, y: center.y))
        }

        self.lineWidth = lineWidth           // in case we're going to use CoreGraphics to stroke path, rather than CAShapeLayer
        lineJoinStyle = .round
    }
}

// MARK: - CALayer

extension CALayer {

    func addGlowEffect(color: UIColor, shadowRadius: CGFloat = 10, shadowOpacity: Float = 0.9, animate: Bool = true) {
        self.shadowColor = color.cgColor
        self.shadowRadius = shadowRadius
        self.shadowOffset = .zero
        self.shadowOpacity = shadowOpacity

        if animate {
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = 0.0
            animation.toValue = shadowOpacity
            animation.duration = 0.5
            add(animation, forKey: "qot_shadowOpacity")
        }
    }

    func removeGlowEffect(animate: Bool = true) {
        let opacity = shadowOpacity
        shadowOpacity = 0

        if animate {
            let animation = CABasicAnimation(keyPath: "shadowOpacity")
            animation.fromValue = opacity
            animation.toValue = 0.0
            animation.duration = 0.5
            add(animation, forKey: "qot_shadowOpacity")
        }
    }
}

// MARK: - CAShapeLayer

extension CAShapeLayer {
    class func circle(center: CGPoint, radius: CGFloat, fillColor: UIColor, strokeColor: UIColor, lineWidth: CGFloat = 1.0) -> CAShapeLayer {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius).cgPath
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth

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

// MAARK: - UIView

extension UIView {
    func addHeader(with theme: ThemeView) {
        self.addSubview(UIView.headerView(with: theme))
    }

    static func headerView(with theme: ThemeView) -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let content = UIView(frame: CGRect(x: 0, y: -screenSize.height, width: screenSize.width, height: screenSize.height))
        theme.apply(content)
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.1))
        header.addSubview(content)
        return header
    }

    func removeSubViews() {
        subviews.forEach({ (subView: UIView) in
            subView.removeFromSuperview()
        })
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
}

// MARK: - UIImage

extension UIImage {
    // @see adapted from https://stackoverflow.com/questions/6496441/creating-a-uiimage-from-a-uicolor-to-use-as-a-background-image-for-uibutton
    static func from(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        guard size.width > 0, size.height > 0 else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - UITableView

extension UITableView {
    func scrollToBottom(animated: Bool) {
        let sections = numberOfSections
        guard sections > 0 else {
            return
        }
        let rows = numberOfRows(inSection: sections - 1)
        guard rows > 0 else {
            return
        }
        let indexPath = IndexPath(row: rows - 1, section: sections - 1)
        scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }

    func scrollToTop(animated: Bool) {
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
}

extension UIEdgeInsets {

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
