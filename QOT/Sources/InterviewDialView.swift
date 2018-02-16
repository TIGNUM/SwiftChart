//
//  InteviewDialView.swift
//
//  Created by Javier Sanz Rozalen on 15/12/2017.
//  Copyright © 2017 Javier Sanz Rozalen. All rights reserved.
//

import UIKit

protocol DialSelectionDelegate: class {
    func selectedIndexDidChange(_ index: Int?, view: InterviewDialView)
}

struct Segment {
    let centerAngle: CGFloat
    let deltaAngle: CGFloat
    let label: UILabel

    var startAngle: CGFloat {
        return centerAngle - (deltaAngle / 2)
    }

    var endAngle: CGFloat {
        return centerAngle + (deltaAngle / 2)
    }

    static func makeSegments() -> [Segment] {
        let startAngle: CGFloat = 135
        let deltaAngle: CGFloat = 27
        var segments: [Segment] = []
        for i in 0...9 {
            let centerAngle = (startAngle + (deltaAngle / 2)) + (deltaAngle * CGFloat(i))
            let label = UILabel()
            label.text = String(i + 1)
            let segment = Segment(
                centerAngle: centerAngle,
                deltaAngle: 27,
                label: label
            )
            segments.append(segment)
        }
        return segments
    }
}

class InterviewDialView: UIView {

    struct Config {
        let ringWidth: CGFloat
    }

    weak var selectionDelegate: DialSelectionDelegate!
    var config = Config(ringWidth: 64)
    var segments = Segment.makeSegments()
    let bottomRingLayer = CAShapeLayer()
    let horseshoeLayer = CAShapeLayer()
    let partitionsLayer = CAShapeLayer()
    let internalRingLayer = CAShapeLayer()
    let selectedSegementGradientLayer = CAGradientLayer()
    let selectedSegementBorderLayer = CAShapeLayer()
    let gradientLayerContainer = CAShapeLayer()
    let linesLayer = CAShapeLayer()
    var centerLabel = UILabel()
    var selectedIndex: Int?

    fileprivate let grad = RadialGradientLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(recognizer:)))
        addGestureRecognizer(tapGestureRecognizer)

        partitionsLayer.addSublayer(linesLayer)
        setupBottomRingLayer()
        setupHorseshoeLayer()
        setupInternalRing()
        segments.forEach { (segment) in
            addSubview(segment.label)
        }
        layer.addSublayer(grad)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutBottomRingLayer()
        layoutHorseshoeLayer()
        layoutInternalRing()
        layoutLabels(center: centerPoint)
        segmentDivision()
        grad.frame = bounds
        syncSelectedSegmentLayer()
    }

    func updateConfig(_ config: Config) {
        self.config = config
        setNeedsLayout()
    }

    var interRadius: CGFloat {
        return outerRadius - config.ringWidth
    }

    var outerRadius: CGFloat {
        return bounds.width / 2
    }

    var centerRadius: CGFloat {
        return outerRadius - (config.ringWidth / 2)
    }

    var centerPoint: CGPoint {
        return bounds.center
    }

    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .recognized else { return }
        let point = recognizer.location(in: self)
        let newSelectedIndex = segmentIndex(at: point)
        if newSelectedIndex != selectedIndex {
            selectedIndex = newSelectedIndex
            syncSelectedSegmentLayer()
            selectionDelegate?.selectedIndexDidChange(newSelectedIndex, view: self)
        }
    }

    func setSelected(index: Int?) {
        if index != selectedIndex {
            selectedIndex = index
            syncSelectedSegmentLayer()
        }
    }

    private func syncSelectedSegmentLayer() {
        if let index = selectedIndex {
            grad.isHidden = false
            let segment = segments[index]
            let segmentGradientPath = UIBezierPath.horseshoe(center: centerPoint,
                                                             innerRadius: (bounds.width / 2) - config.ringWidth,
                                                             outerRadius: bounds.width / 2,
                                                             startAngle: segment.startAngle,
                                                             endAngle: segment.endAngle)
            segmentGradientPath.close()
            gradientLayerContainer.path = segmentGradientPath.cgPath
            grad.mask = gradientLayerContainer
        } else {
            grad.isHidden = true
        }
    }

    private func setupHorseshoeLayer() {
        layer.addSublayer(horseshoeLayer)
        horseshoeLayer.fillColor = UIColor(red: 0.15, green: 0.18, blue: 0.22, alpha: 1.0).cgColor
        horseshoeLayer.opacity = 0.6
    }

    private func layoutHorseshoeLayer() {
        let outer = bounds.width / 2
        let inner = outer - config.ringWidth
        horseshoeLayer.path = UIBezierPath.horseshoe(center: centerPoint,
                                                     innerRadius: inner,
                                                     outerRadius: outer,
                                                     startAngle: 135,
                                                     endAngle: 45).cgPath
    }

    private func setupInternalRing() {
        layer.addSublayer(internalRingLayer)
        internalRingLayer.fillColor = UIColor.clear.cgColor
        internalRingLayer.strokeColor = UIColor.white.cgColor
        internalRingLayer.opacity = 0.08
    }

    private func layoutInternalRing() {
        let outer = (bounds.width / 2) - config.ringWidth
        internalRingLayer.path = UIBezierPath.circlePath(center: centerPoint, radius: outer).cgPath
    }

    private func setupBottomRingLayer() {
        layer.addSublayer(bottomRingLayer)
        bottomRingLayer.fillColor = UIColor(red: 0.10, green: 0.11, blue: 0.14, alpha: 1.0).cgColor
        bottomRingLayer.fillRule = kCAFillRuleEvenOdd
        bottomRingLayer.opacity = 0.65
    }

    private func layoutBottomRingLayer() {
        let outer = bounds.width / 2
        let inner = outer - config.ringWidth
        bottomRingLayer.path = UIBezierPath.horseshoe(center: centerPoint,
                                                      innerRadius: inner,
                                                      outerRadius: outer,
                                                      startAngle: 45,
                                                      endAngle: 135).cgPath
    }

    private func layoutLabels(center: CGPoint) {
        segments.forEach { (segment) in
            segment.label.textColor = .white
            segment.label.font = Font.H5SecondaryHeadline
            segment.label.sizeToFit()
            segment.label.center = center.shifted(centerRadius, with: segment.centerAngle)
        }
    }

    func segmentIndex(at point: CGPoint) -> Int? {

        for (index, segment) in segments.enumerated() {
            let segmentPath = UIBezierPath.horseshoe(center: centerPoint,
                                                             innerRadius: (bounds.width / 2) - config.ringWidth,
                                                             outerRadius: bounds.width / 2,
                                                             startAngle: segment.startAngle,
                                                             endAngle: segment.endAngle)
            if segmentPath.contains(point) {
                return index
            }
        }
        return nil
    }

    private func setupCircleLayers() {
        bottomRingLayer.fillColor = UIColor(red: 0.00, green: 0.11, blue: 0.19, alpha: 1.0).cgColor
        partitionsLayer.fillColor = UIColor(red: 0.52, green: 0.49, blue: 0.41, alpha: 1.0).cgColor
    }

    private func segmentDivision() {
        let totalLinesPath = UIBezierPath()
        segments.forEach { (segment) in
            if segments[segments.count - 1].label != segment.label {
                let currentPoint = centerPoint.shifted(interRadius + 20, with: segment.endAngle)
                let endPoint = currentPoint.shifted(config.ringWidth - 35, with: segment.endAngle)
                let linePath = UIBezierPath.linePath(from: currentPoint, to: endPoint)
                totalLinesPath.append(linePath)
            }
        }

        linesLayer.strokeColor = UIColor.white.cgColor
        linesLayer.fillColor = UIColor.clear.cgColor
        linesLayer.lineWidth = 0.6
        linesLayer.opacity = 0.3
        linesLayer.path = totalLinesPath.cgPath
        layer.addSublayer(linesLayer)
    }
}

private class RadialGradientLayer: CALayer {

    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    required override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        needsDisplayOnBoundsChange = true
        addSublayer(borderLayer)

        borderLayer.lineWidth = 1
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        backgroundColor = UIColor.clear.cgColor
    }

    let borderLayer = CAShapeLayer()

    override func layoutSublayers() {
        super.layoutSublayers()

        let borderPath = UIBezierPath.circlePath(center: bounds.center, radius: (bounds.width / 2) - 0.5)
        borderLayer.path = borderPath.cgPath
    }

    let colors = [UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
    let locations: [CGFloat] = [0, 1]

    override func draw(in ctx: CGContext) {
        ctx.saveGState()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = min(bounds.width / 2.0, bounds.height / 2.0)
        ctx.drawRadialGradient(gradient!,
                               startCenter: center,
                               startRadius: 0.0,
                               endCenter: center,
                               endRadius: radius,
                               options: CGGradientDrawingOptions(rawValue: 0))

    }
}
