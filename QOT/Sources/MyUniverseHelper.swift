//
//  MyUniverseHelper.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

struct MyUniverseHelper {

    private static var dataCenterPoints = [[CGPoint]]()

    static func radius(for load: CGFloat, layout: Layout.MeSection, radiusOffset: CGFloat = 0) -> CGFloat {
        let factor: CGFloat = layout.radiusMaxLoad
        let offset: CGFloat = (layout.profileImageWidth * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4) - radiusOffset
    }
}

// MARK: - Center Points

extension MyUniverseHelper {

    static func collectCenterPoints(layout: Layout.MeSection, sectors: [Sector], relativeCenter: CGPoint) {
        dataCenterPoints.removeAll()

        sectors.forEach { (sector: Sector) in
            let centerPoints = sector.spikes.map({ relativeCenter.shifted(radius(for: $0.spikeLoad(), layout: layout, radiusOffset: sector.type.lineWidth(load: $0.spikeLoad()) + $0.spikeLoad() * 6.6), with: $0.angle) })
            dataCenterPoints.append(centerPoints)
        }
    }
}

// MARK: - Data Point Connections

extension MyUniverseHelper {

    static func dataPointConnections(sectors: [Sector], layout: Layout.MeSection, center: CGPoint) -> [CAShapeLayer] {
        var connections = [CAShapeLayer]()
        dataCenterPoints.forEach { (points: [CGPoint]) in
            points.forEach({ (point: CGPoint) in
                connections.append(
                    CAShapeLayer.line(from: center, to: point, strokeColor: Color.MeSection.whiteStrokeLight)
                )
            })
        }
        return connections
    }

    static func myWhySpikes(layout: Layout.MeSection) -> [CAShapeLayer] {
        let shiftedXPos = (layout.profileImageWidth * 0.2)
        let yPos = layout.profileImageViewFrame.origin.y + layout.profileImageWidth * 0.5
        let originPoint = CGPoint(x: -shiftedXPos, y: yPos)
        let visionPoint = originPoint.shifted(radius(for: 0.25, layout: layout), with: 310)
        let choicesPoint = originPoint.shifted(radius(for: 0.4, layout: layout), with: 10)
        let partnersPoint = originPoint.shifted(radius(for: 0.55, layout: layout), with: 70)

        return [
            CAShapeLayer.line(from: originPoint, to: visionPoint, strokeColor: Color.Default.whiteMedium),
            CAShapeLayer.line(from: originPoint, to: choicesPoint, strokeColor: Color.Default.whiteMedium),
            CAShapeLayer.line(from: originPoint, to: partnersPoint, strokeColor: Color.Default.whiteMedium)
        ]
    }
}

// MARK: - Data Points

extension MyUniverseHelper {

    static func dataPoints(sectors: [Sector], layout: Layout.MeSection) -> [ChartDataPoint] {
        var dataPoints = [ChartDataPoint]()
        for (dataIndex, centerPoints) in dataCenterPoints.enumerated() {
            for (centerIndex, center) in centerPoints.enumerated() {
                guard dataIndex < sectors.count else {
                    return []
                }

                let sector = sectors[dataIndex]

                guard centerIndex < sector.spikes.count else {
                    return []
                }

                let spike = sector.spikes[centerIndex]
                let radius = MyUniverseHelper.radius(for: spike.spikeLoad(), layout: layout)
                let circumference = (spike.spikeLoad() * 6.6) * 2
                let dot = MyUniverseHelper.dot(
                    fillColor: fillColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type, layout: layout),
                    strokeColor: strokeColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type, layout: layout),
                    center: center,
                    radius: circumference / 2,
                    lineWidth: sector.type.lineWidth(load: spike.load)
                )
                // @note we have to manually store the frame because it's .zero in CALayer
                // @see https://stackoverflow.com/questions/8662724/setting-correct-frame-of-a-newly-created-cashapelayer
                let frame = dot.path?.boundingBox ?? .zero
                let minSize: CGFloat = 40.0 // minimum width & height
                let padding = circumference < minSize ? minSize - circumference : 0
                dataPoints.append(ChartDataPoint(dot: dot, sector: sector, frame: frame.insetBy(dx: -padding, dy: -padding)))
            }
        }
        return dataPoints
    }
}

// MARK: - Sector Labels

extension MyUniverseHelper {

    static func attributedString(for sector: Sector, layout: Layout.MeSection, screenType: MyUniverseViewController.ScreenType) -> NSAttributedString {
        let text = sector.labelType.text.uppercased()
        let criticalLoads = sector.spikes.filter { (spike: Spike) -> Bool in
            let distanceCenter = radius(for: spike.spikeLoad(), layout: layout)
            return distanceCenter > average(for: spike.load, layout: layout)
        }

        if criticalLoads.isEmpty {
            return Style.sector(text, .white40).attributedString(lineSpacing: screenType.lineSpacingSectorTitle)
        }

        return Style.sector(text, .cherryRedTwo).attributedString(lineSpacing: screenType.lineSpacingSectorTitleCritical)
    }
}

// MARK: - ScrollView

extension MyUniverseHelper {

    static func createScrollView(_ frame: CGRect, layout: Layout.MeSection) -> UIScrollView {
        let scrollView = UIScrollView(frame: frame)
        scrollView.bounces = false
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: (frame.width * 2) - (layout.scrollViewOffset * 3.5),
            height: frame.height - 84
            // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )
        return scrollView
    }
}

// MARK: - Private

private extension MyUniverseHelper {

    static func dot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let dotLayer = CAShapeLayer.circle(
            center: center,
            radius: radius,
            fillColor: fillColor,
            strokeColor: strokeColor
        )

        dotLayer.lineWidth = lineWidth
        dotLayer.addGlowEffect(color: fillColor)
        return dotLayer
    }

    static func fillColor(radius: CGFloat, load: CGFloat, sectorType: SectorType, layout: Layout.MeSection) -> UIColor {
        let isCritical = radius > average(for: load, layout: layout)

        switch sectorType {
        case .load: return isCritical ? Color.MeSection.redFilled : .white
        case .bodyBrain: return isCritical ? Color.MeSection.redFilledBodyBrain : Color.MeSection.whiteStrokeLight
        }
    }

    static func strokeColor(radius: CGFloat, load: CGFloat, sectorType: SectorType, layout: Layout.MeSection) -> UIColor {
        let isCritical = radius > average(for: load, layout: layout)

        switch sectorType {
        case .load: return isCritical ? Color.MeSection.redStroke : Color.MeSection.whiteStroke
        case .bodyBrain: return isCritical ? Color.MeSection.redFilled : .white
        }
    }

    static func average(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        return (layout.radiusAverageLoad - (load * 4))
    }
}
