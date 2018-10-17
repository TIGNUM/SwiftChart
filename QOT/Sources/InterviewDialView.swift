//
//  InteviewDialView.swift
//
//  Created by Javier Sanz Rozalen on 15/12/2017.
//  Copyright © 2017 Javier Sanz Rozalen. All rights reserved.
//

import UIKit

protocol DialSelectionDelegate: class {
    func selectedIndexDidChange(_ index: Int?, view: InterviewDialView)
    func didTouchUp(index: Int?, view: InterviewDialView)
}

struct Segment {
    let centerAngle: CGFloat
    let deltaAngle: CGFloat

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
            let segment = Segment(centerAngle: centerAngle, deltaAngle: deltaAngle)
            segments.append(segment)
        }
        return segments
    }
}

class InterviewDialView: UIView {

    struct Config {
        let ringWidth: CGFloat
    }

    private var segmentLabels: [Index: UILabel] = [:]
    private let selectedLayer = SelectedLayer()
    private var config = Config(ringWidth: 64)
    private var segments = Segment.makeSegments()
    private let bottomRingLayer = CAShapeLayer()
    private let horseshoeLayer = CAShapeLayer()
    private let partitionsLayer = CAShapeLayer()
    private let internalRingLayer = CAShapeLayer()
    private let linesLayer = CAShapeLayer()
    private var selectedIndex: Int?
    weak var delegate: DialSelectionDelegate!
    let tapGestureRecognizer = UITapGestureRecognizer()
    let panGestureRecognizer = UIPanGestureRecognizer()

    private var interRadius: CGFloat {
        return outerRadius - config.ringWidth
    }

    private var outerRadius: CGFloat {
        return bounds.width / 2
    }

    private var centerRadius: CGFloat {
        return outerRadius - (config.ringWidth / 2)
    }

    private var centerPoint: CGPoint {
        return bounds.center
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
        layoutSegmentDivision()
        selectedLayer.frame = bounds
        syncSelectedSegmentLayer()
    }

    // MARK: - Layers setup

    private func setup() {
        setupGestureRecognizers()
        partitionsLayer.addSublayer(linesLayer)
        setupBottomRingLayer()
        setupHorseshoeLayer()
        setupInternalRing()
        for i in 0..<segments.count {
            let label = segmentLabel(index: i)
            label.text = String(i + 1)
        }
        setupLinesLayer()
        layer.addSublayer(selectedLayer)
    }

    private func setupGestureRecognizers() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleGesture(recognizer:)))
        addGestureRecognizer(tapGestureRecognizer)

        panGestureRecognizer.addTarget(self, action: #selector(handleGesture(recognizer:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    private func setupHorseshoeLayer() {
        layer.addSublayer(horseshoeLayer)
        horseshoeLayer.fillColor = UIColor(red: 0.15, green: 0.18, blue: 0.22, alpha: 1.0).cgColor
        horseshoeLayer.opacity = 0.6
    }
    private func setupInternalRing() {
        layer.addSublayer(internalRingLayer)
        internalRingLayer.fillColor = UIColor.clear.cgColor
        internalRingLayer.strokeColor = UIColor.white.cgColor
        internalRingLayer.opacity = 0.08
    }
    private func setupBottomRingLayer() {
        layer.addSublayer(bottomRingLayer)
        bottomRingLayer.fillColor = UIColor(red: 0.10, green: 0.11, blue: 0.14, alpha: 1.0).cgColor
        bottomRingLayer.fillRule = kCAFillRuleEvenOdd
        bottomRingLayer.opacity = 0.65
    }

    private func setupCircleLayers() {
        bottomRingLayer.fillColor = UIColor(red: 0.00, green: 0.11, blue: 0.19, alpha: 1.0).cgColor
        partitionsLayer.fillColor = UIColor(red: 0.52, green: 0.49, blue: 0.41, alpha: 1.0).cgColor
    }

    private func setupLinesLayer() {
        linesLayer.strokeColor = UIColor.white.cgColor
        linesLayer.fillColor = UIColor.clear.cgColor
        linesLayer.lineWidth = 0.6
        linesLayer.opacity = 0.3
    }

    // MARK: - Layers configuration

    private func layoutHorseshoeLayer() {
        let outer = bounds.width / 2
        let inner = outer - config.ringWidth
        horseshoeLayer.path = UIBezierPath.horseshoe(center: centerPoint,
                                                     innerRadius: inner,
                                                     outerRadius: outer,
                                                     startAngle: 135,
                                                     endAngle: 45).cgPath
    }

    private func layoutInternalRing() {
        let outer = (bounds.width / 2) - config.ringWidth
        internalRingLayer.path = UIBezierPath.circlePath(center: centerPoint, radius: outer).cgPath
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
        for (index, segment) in segments.enumerated() {
            let label = segmentLabel(index: index)
            label.sizeToFit()
            label.center = center.shifted(centerRadius, with: segment.centerAngle)
        }
    }

    private func layoutSegmentDivision() {
        let totalLinesPath = UIBezierPath()
        segments.dropLast().forEach { (segment) in
            let currentPoint = centerPoint.shifted(interRadius + 20, with: segment.endAngle)
            let endPoint = currentPoint.shifted(config.ringWidth - 35, with: segment.endAngle)
            let linePath = UIBezierPath.linePath(from: currentPoint, to: endPoint)
            totalLinesPath.append(linePath)
        }

        linesLayer.path = totalLinesPath.cgPath
        layer.addSublayer(linesLayer)
    }

    func updateConfig(_ config: Config) {
        self.config = config
        setNeedsLayout()
    }

    // MARK: - Tap event handling

    @objc func handleGesture(recognizer: UIGestureRecognizer) {
        let point = recognizer.location(in: self)
        let newSelectedIndex = segmentIndex(at: point)
        if newSelectedIndex != selectedIndex {
            selectedIndex = newSelectedIndex
            syncSelectedSegmentLayer()
            delegate?.selectedIndexDidChange(newSelectedIndex, view: self)
        }
        if recognizer.state == .ended {
            let endPoint = recognizer.location(in: self)
            let endIndex = segmentIndex(at: endPoint)
            delegate?.didTouchUp(index: endIndex, view: self)
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
            selectedLayer.isHidden = false
            let segment = segments[index]
            let segmentGradientPath = UIBezierPath.horseshoe(center: centerPoint,
                                                             innerRadius: (bounds.width / 2) - config.ringWidth,
                                                             outerRadius: bounds.width / 2,
                                                             startAngle: segment.startAngle,
                                                             endAngle: segment.endAngle)
            segmentGradientPath.close()

            let mask = CAShapeLayer()
            mask.path = segmentGradientPath.cgPath
            selectedLayer.mask = mask
        }
    }

    private func segmentIndex(at point: CGPoint) -> Int? {

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
}

// MARK: - Private

private extension InterviewDialView {

    func segmentLabel(index: Int) -> UILabel {
        if let label = segmentLabels[index] {
            return label
        } else {
            let label = UILabel()
            label.textColor = .white
            label.font = .H5SecondaryHeadline
            addSubview(label)
            segmentLabels[index] = label
            return label
        }
    }
}

// MARK: - Private class for drawing a gradient circular shape

private class SelectedLayer: CALayer {

    let borderLayer = CAShapeLayer()
    let colors = [UIColor.white.withAlphaComponent(0.4).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
    let locations: [CGFloat] = [0, 1]

    required override init() {
        super.init()
        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
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

    override func layoutSublayers() {
        super.layoutSublayers()

        let borderPath = UIBezierPath.circlePath(center: bounds.center, radius: (bounds.width / 2) - 0.5)
        borderLayer.path = borderPath.cgPath
    }

    override func draw(in ctx: CGContext) {
        ctx.saveGState()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = min(bounds.width / 2.0, bounds.height / 2.0)
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors as CFArray,
                                        locations: locations) else { return }
        ctx.drawRadialGradient(gradient,
                               startCenter: center,
                               startRadius: 0.0,
                               endCenter: center,
                               endRadius: radius,
                               options: CGGradientDrawingOptions(rawValue: 0))
    }
}
