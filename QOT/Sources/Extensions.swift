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
import Anchorage

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

    class func horseshoe(center: CGPoint,
                         innerRadius: CGFloat,
                         outerRadius: CGFloat,
                         startAngle: CGFloat,
                         endAngle: CGFloat) -> UIBezierPath {
        let start = startAngle.degreesToRadians
        let end = endAngle.degreesToRadians
        let path = UIBezierPath(arcCenter: center,
                                radius: outerRadius,
                                startAngle: start,
                                endAngle: end,
                                clockwise: true)
        path.addArc(withCenter: center,
                    radius: innerRadius,
                    startAngle: end,
                    endAngle: start,
                    clockwise: false)
        path.close()
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

// MAARK: - UIView

extension UIView {

    var isVisible: Bool {
        get { return !isHidden }
        set { isHidden = !newValue }
    }

    enum FadeViewLocation {
        case top
        case bottom
    }

    func addHeader(with color: UIColor) {
        self.addSubview(UIView.headerView(with: color))
    }

    static func headerView(with color: UIColor) -> UIView {
        let screenSize = UIScreen.main.bounds.size
        let content = UIView(frame: CGRect(x: 0, y: -screenSize.height, width: screenSize.width, height: screenSize.height))
        content.backgroundColor = color
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 0.1))
        header.addSubview(content)
        return header
    }

    @discardableResult func addFadeView(at location: FadeViewLocation,
                                        height: CGFloat = 70.0,
                                        primaryColor: UIColor = .darkIndigo,
                                        fadeColor: UIColor = .clear) -> GradientView {
        guard height > 0 else {
            assertionFailure("height must be > 0")
            return GradientView(colors: [], locations: [])
        }

        let fadeView: GradientView
        switch location {
        case .top:
            fadeView = GradientView(colors: [primaryColor, fadeColor], locations: [0.5, 1])
        case .bottom:
            fadeView = GradientView(colors: [fadeColor, primaryColor], locations: [0, 0.5])
        }

        addSubview(fadeView)
        fadeView.horizontalAnchors == horizontalAnchors
        fadeView.heightAnchor == height
        switch location {
        case .top:
            fadeView.topAnchor == topAnchor
        case .bottom:
            fadeView.bottomAnchor == bottomAnchor
        }

        return fadeView
    }

    enum FadeMaskLocation {
        case top
        case bottom
        case topAndBottom
    }

    @discardableResult func setFadeMask(at location: FadeMaskLocation,
                                        height: CGFloat = 70.0,
                                        primaryColor: CGColor = UIColor.black.cgColor) -> CALayer {
        guard height > 0 else {
            assertionFailure("height must be > 0")
            return CALayer()
        }
        let fadeColor = UIColor.clear.cgColor

        let wrapperLayer = CALayer()
        wrapperLayer.backgroundColor = fadeColor

        switch location {
        case .top:
            wrapperLayer.frame = bounds.offsetBy(dx: 0, dy: safeMargins.top / 2)

            let fadeLayer = CAGradientLayer()
            fadeLayer.colors = [fadeColor, fadeColor, primaryColor]
            fadeLayer.frame = CGRect(x: 0, y: 0, width: wrapperLayer.bounds.width, height: height)

            let contentLayer = CALayer()
            contentLayer.backgroundColor = primaryColor
            contentLayer.frame = CGRect(x: 0, y: height, width: wrapperLayer.bounds.width, height: wrapperLayer.bounds.height - height)

            wrapperLayer.addSublayer(fadeLayer)
            wrapperLayer.addSublayer(contentLayer)
        case .bottom:
            wrapperLayer.frame = bounds

            let fadeLayer = CAGradientLayer()
            fadeLayer.colors = [primaryColor, fadeColor, fadeColor]
            fadeLayer.frame = CGRect(x: 0, y: wrapperLayer.bounds.height - height, width: wrapperLayer.bounds.width, height: height)

            let contentLayer = CALayer()
            contentLayer.backgroundColor = primaryColor
            contentLayer.frame = CGRect(x: 0, y: 0, width: wrapperLayer.bounds.width, height: wrapperLayer.bounds.height - height)

            wrapperLayer.addSublayer(fadeLayer)
            wrapperLayer.addSublayer(contentLayer)
        case .topAndBottom:
            wrapperLayer.frame = bounds.insetBy(dx: 0, dy: safeMargins.top / 2)

            let topFadeLayer = CAGradientLayer()
            topFadeLayer.colors = [fadeColor, fadeColor, primaryColor]
            topFadeLayer.frame = CGRect(x: 0, y: 0, width: wrapperLayer.bounds.width, height: height)

            let bottomFadeLayer = CAGradientLayer()
            bottomFadeLayer.colors = [primaryColor, fadeColor, fadeColor]
            bottomFadeLayer.frame = CGRect(x: 0, y: wrapperLayer.bounds.height - height, width: wrapperLayer.bounds.width, height: height)

            let contentLayer = CALayer()
            contentLayer.backgroundColor = primaryColor
            contentLayer.frame = CGRect(x: 0, y: height, width: wrapperLayer.bounds.width, height: wrapperLayer.bounds.height - (height * 2.0))

            wrapperLayer.addSublayer(topFadeLayer)
            wrapperLayer.addSublayer(bottomFadeLayer)
            wrapperLayer.addSublayer(contentLayer)
        }

        layer.mask = wrapperLayer
        return wrapperLayer
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

    var safeVerticalAnchors: AnchorPair<NSLayoutYAxisAnchor, NSLayoutYAxisAnchor> {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.verticalAnchors
        } else {
            return verticalAnchors
        }
    }

    var safeEdgeAnchors: EdgeAnchors {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.edgeAnchors
        } else {
            return edgeAnchors
        }
    }

    var safeMargins: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return safeAreaInsets
        } else {
            return layoutMargins
        }
    }

    func addBlackNavigationView() {
        let blackTopView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: Layout.statusBarHeight * 2))
        blackTopView.backgroundColor = .black
        addSubview(blackTopView)
    }

    func showLoader() {
        let view = Skeleton.showLoader()
        self.addSubview(view)
        view.addConstraints(to: self)
        self.layoutIfNeeded()
    }

    func removeLoadingSkeleton() {
        guard let view = self.viewWithTag(Skeleton.tag) else { return }
        view.removeFromSuperview()
    }

    func showLoadingSkeleton(with types: [SkeletonType]) {
        let view = Skeleton.show(types)
        addSubview(view)
        view.addConstraints(to: self)
        self.layoutIfNeeded()
    }
}

// MARK: - UILabel

extension UILabel {
    func maxLines(for font: UIFont) -> Int {
        guard let text = self.text, text.count > 0 else {
            return 0
        }
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
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
        if let url = resource.url {
            if url.isFileURL {
                let image = UIImage(dataUrl: url)
                self.image = image
                completion?(image, nil)
            } else {
                let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
                kf.setImage(with: url,
                            placeholder: defaultImage,
                            options: options,
                            progressBlock: nil) { (result) in
                                switch result {
                                case .success(let value):
                                    completion?(value.image, nil)
                                case .failure(let error):
                                    completion?(nil, error)
                                }
                }
            }
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

    func prepareAndSetTitleAttributes(text: String, font: UIFont, color: UIColor, for state: UIControlState) {
        let attrString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 13
        attrString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.count))
        attrString.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.count))
        attrString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attrString, for: state)
    }

    func setImageFromResource(_ resource: MediaResource, defaultImage: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        if let url = resource.url {
            if url.isFileURL {
                let image = UIImage(dataUrl: url)
                setImage(image, for: .normal)
                completion?(image, nil)
            } else {
                let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
                kf.setImage(with: url, for: .normal, placeholder: defaultImage, options: options, progressBlock: nil,
                            completionHandler: { (result) in
                                switch result {
                                case .success(let value):
                                    completion?(value.image, nil)
                                case .failure(let error):
                                    completion?(nil, error)
                                }
                })
            }
        } else if let defaultImage = defaultImage {
            setImage(defaultImage, for: .normal)
            completion?(defaultImage, nil)
        } else {
            completion?(nil, nil)
        }
    }

    func setBackgroundImageFromResource(_ resource: MediaResource, defaultImage: UIImage? = nil, completion: ((UIImage?, Error?) -> Void)? = nil) {
        if let url = resource.url {
            if url.isFileURL {
                let image = UIImage(dataUrl: url)
                setBackgroundImage(image, for: .normal)
                completion?(image, nil)
            } else {
                let options: [KingfisherOptionsInfoItem] = [.targetCache(KingfisherManager.shared.cache)]
                kf.setBackgroundImage(with: url, for: .normal, placeholder: defaultImage, options: options, progressBlock: nil,
                                      completionHandler: { (result) in
                                        switch result {
                                        case .success(let value):
                                            completion?(value.image, nil)
                                        case .failure(let error):
                                            completion?(nil, error)
                                        }
                })
            }
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

    func scrollToTop(animated: Bool) {
        scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: animated)
    }
}

// MARK: - UIScrollView

extension UIScrollView {

    var currentPage: Int {
        guard bounds.size.width != 0 else { return 0 }

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

        guard var week = selfCast else {
            return []
        }

        let tempDay = week.first
        week.removeFirst()

        if withWeekend == false {
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

    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
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

// MARK: - Int

extension Int {

    mutating func plus(_ value: Int) {
        self += value
    }

    mutating func minus(_ value: Int) {
        self -= value
    }

    mutating func reset() {
        self = 0
    }

    var toFloat: CGFloat {
        return CGFloat(self)
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

extension Comparable {

    func constrainedTo(min minimum: Self, max maximum: Self) -> Self {
        return max(minimum, min(self, maximum))
    }
}

// MARK: - CGSize

extension CGSize {

    var ceiled: CGSize {
        return CGSize(width: ceil(width), height: ceil(height))
    }
}

// MARK: - NSMutableAttributedString

extension NSMutableAttributedString {

    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = mutableString.range(of: textToFind, options: .caseInsensitive)
        if let font = R.font.apercuBold(size: 16), range.location != NSNotFound {
            addAttribute(.foregroundColor, value: color, range: range)
            addAttribute(.font, value: font, range: range)
        }
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
