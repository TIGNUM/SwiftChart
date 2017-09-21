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

// MARK: - String

extension String {
    
    var removeFilePrefix: String {
        return replacingOccurrences(of: "file://", with: "")
    }
}

// MARK: - UIFont

extension UIFont {
    
    class func simpleFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.simple.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    class func bentonBookFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonBook.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
    
    class func bentonRegularFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonRegular.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }

    class func bentonCondLightFont(ofSize: CGFloat) -> UIFont {
        return (UIFont(name: FontName.bentonSansCondLight.rawValue, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize))
    }
}

// MARK: - NSAttributedString

extension NSAttributedString {

    internal class func create(for string: String, withColor color: UIColor, andFont font: UIFont, letterSpacing: CGFloat = 1) -> NSAttributedString {
        let attributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: color,
            .font: font,
            .kern: letterSpacing
        ]
        
        return NSAttributedString(string: string, attributes: attributes)
    }
}

// MARK: - UIBezierPath

extension UIBezierPath {

    class func hexagonPath(forRect rect: CGRect) -> UIBezierPath {
        let cornerRadius = max(rect.width, rect.height) * 0.1
        let path = UIBezierPath(polygonIn: rect, sides: 6, lineWidth: 0, cornerRadius: cornerRadius, rotateByDegs: 180 / 6)
        return path
    }
    
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
            apply(CGAffineTransform(rotationAngle: degs * (CGFloat.pi / 180.0)))
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

    func removeAllSublayer() {
        sublayers?.forEach { $0.removeFromSuperlayer() }
    }
}

// MARK: - CAShapeLayer

extension CAShapeLayer {

    func glowEffect(color: UIColor, shadowRadius: CGFloat = 10, shadowOpacity: Float = 0.9, animate: Bool = true) {
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

// MARK: - CGFLoat

extension CGFloat {

    func radians() -> CGFloat {
        let b = CGFloat(Float.pi) * (self/180)
        return b
    }
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
                self.swapAt(index, element)
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

    enum FadeDirection {
        case up
        case down
    }

    @discardableResult func applyFade(origin: CGPoint = CGPoint.zero, height: CGFloat = 70.0, primaryColor: UIColor = .darkIndigo, fadeColor: UIColor = .clear, direction: FadeDirection = .down) -> UIView {
        let fadeView = UIView(frame: CGRect(origin: origin, size: CGSize(width: bounds.size.width, height: height)))
        fadeView.backgroundColor = .clear

        let fadeLayer = CAGradientLayer()
        fadeLayer.frame = fadeView.bounds

        switch direction {
        case .down:
            fadeLayer.colors = [primaryColor.cgColor, primaryColor.cgColor, fadeColor.cgColor]
        case .up:
            fadeLayer.colors = [fadeColor.cgColor, primaryColor.cgColor, primaryColor.cgColor]
        }

        fadeView.layer.addSublayer(fadeLayer)

        addSubview(fadeView)
        return fadeView
    }

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
    
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            log("couldnt take screenshot")
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func applyHexagonMask() {
        let clippingBorderPath = UIBezierPath.hexagonPath(forRect: bounds)
        let borderMask = CAShapeLayer()
        borderMask.path = clippingBorderPath.cgPath
        layer.mask = borderMask
    }
}

// MARK: - UIWindow

extension UIWindow {
    func setRootViewControllerWithFadeAnimation(_ viewController: UIViewController, duration: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.rootViewController = viewController
        }, completion: { _ in
            completion?()
        })
    }
    
    func clear() {
        subviews.forEach { (view: UIView) in
            view.removeFromSuperview()
        }
        rootViewController = nil
    }
}

// MARK: - UIImage

extension UIImage {

    // This is a static func because of a possible bug causing a crash: @see: https://petercompernolle.com/2015/excbadaccess-with-coreimage
    static func makeGrayscale(_ image: UIImage) -> UIImage? {
        guard let image = CIImage(image: image), let filter = CIFilter(name: "CIPhotoEffectNoir") else {
            return nil
        }

        filter.setDefaults()
        filter.setValue(image, forKey: kCIInputImageKey)

        let context = CIContext(options: nil)
        if let output = filter.outputImage, let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    
    // @see adapted from https://stackoverflow.com/questions/6496441/creating-a-uiimage-from-a-uicolor-to-use-as-a-background-image-for-uibutton
    static func from(color: UIColor, size: CGSize) -> UIImage? {
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
    
    convenience init?(dataUrl: URL) {
        do {
            let data = try Data(contentsOf: dataUrl)
            self.init(data: data)
        } catch {
            log(error)
            return nil
        }
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
    
    func setImageFromResource(_ resource: MediaResource, defaultImage: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        if let localURL = resource.localURL {
            image = UIImage(dataUrl: localURL)
            completion?(image, nil)
        } else if let remoteURL = resource.remoteURL {
            let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
            kf.setImage(with: remoteURL, placeholder: defaultImage, options: options, progressBlock: nil, completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, url: URL?) in
                completion?(image, error)
            })
        } else if let defaultImage = defaultImage {
            image = defaultImage
            completion?(image, nil)
        } else {
            completion?(nil, nil)
        }
    }
}

// MARK: - UIButton

extension UIButton {
    
    func setImageFromResource(_ resource: MediaResource, defaultImage: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        if let localURL = resource.localURL {
            let image = UIImage(dataUrl: localURL)
            setImage(image, for: .normal)
            completion?(image, nil)
        } else if let remoteURL = resource.remoteURL {
            let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
            kf.setImage(with: remoteURL, for: .normal, placeholder: defaultImage, options: options, progressBlock: nil, completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, url: URL?) in
                completion?(image, error)
            })
        } else if let defaultImage = defaultImage {
            setImage(defaultImage, for: .normal)
            completion?(defaultImage, nil)
        } else {
            completion?(nil, nil)
        }
    }
    
    func setBackgroundImageFromResource(_ resource: MediaResource, defaultImage: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        if let localURL = resource.localURL {
            let image = UIImage(dataUrl: localURL)
            setBackgroundImage(image, for: .normal)
            completion?(image, nil)
        } else if let remoteURL = resource.remoteURL {
            let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
            kf.setBackgroundImage(with: remoteURL, for: .normal, placeholder: defaultImage, options: options, progressBlock: nil, completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, url: URL?) in
                completion?(image, error)
            })
        } else if let defaultImage = defaultImage {
            setBackgroundImage(defaultImage, for: .normal)
            completion?(defaultImage, nil)
        } else {
            completion?(nil, nil)
        }
    }
}

// MARK: - UITableView

extension UITableView {
    
    func reloadDataWithAnimation(duration: TimeInterval = 0.35) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        })
    }
    
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

// MARK: - UIResponder

extension UIResponder {
    
    func findParentResponder<T>() -> T? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let result = responder as? T {
                return result
            }
        }
        return nil
    }
}

// MARK: - SequSequenceType

extension Sequence where Iterator.Element == String {
    
    func mondayFirst(withWeekend: Bool = true) -> [String] {
        let selfCast = self as? [String]

        guard var week = selfCast else { return [] }

        let tempDay = week.first

        week.removeFirst()

        if !withWeekend {
            week.removeLast()
        } else if let day = tempDay {
            week.append(day)
        }

        return week
    }
}

// MARK: - Double

extension Double {

    var toFloat: CGFloat {
        return CGFloat(self)
    }

    var toInt: Int {
        return Int(self)
    }
}

extension DoubleObject {

    var toFloat: CGFloat {
        return self.value.toFloat
    }

    var toInt: Int {
        return self.value.toInt
    }
}
