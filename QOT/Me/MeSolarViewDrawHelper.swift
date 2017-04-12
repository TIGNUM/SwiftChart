//
//  MeSolarViewDrawHelper.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

struct MeSolarViewDrawHelper {

    fileprivate static var dataCenterPoints = [[CGPoint]]()
    fileprivate static var connectionCenterPoitns = [[CGPoint]]()

    static func radius(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        let factor: CGFloat = layout.radiusMaxLoad
        let offset: CGFloat = (layout.profileImageWidth * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)
    }
}

// MARK: - Center Points

extension MeSolarViewDrawHelper {

    static func collectCenterPoints(layout: Layout.MeSection, sectors: [Sector], relativeCenter: CGPoint) {
        sectors.forEach { (sector: Sector) in
            let centerPoints = sector.spikes.map({ relativeCenter.shifted(radius(for: $0.spikeLoad(), layout: layout), with: $0.angle) })
            dataCenterPoints.append(centerPoints)
            connectionCenterPoitns.append(centerPoints)
        }
    }

    static func addAditionalConnectionPoints(sectors: [Sector], layout: Layout.MeSection) {
        for (sectorIndex, sector) in sectors.enumerated() {
            var centerPoints = [CGPoint]()

            for index in stride(from: 0, to: sector.spikes.count, by: 2) {
                let centerPoint = dataCenterPoints[sectorIndex][index]
                centerPoints.append(centerPoint)
                centerPoints.append(layout.connectionCenter)
            }

            connectionCenterPoitns.append(centerPoints)
        }
    }
}

// MARK: - Data Point Connections

extension MeSolarViewDrawHelper {

    static func dataPointConnections(sectors: [Sector], layout: Layout.MeSection) -> [CAShapeLayer] {
        var connections = [CAShapeLayer]()
        MeSolarViewDrawHelper.addAditionalConnectionPoints(sectors: sectors, layout: layout)
        connectionCenterPoitns.shuffled().forEach { (centerPopints: [CGPoint]) in
            for (index, center) in centerPopints.shuffled().enumerated() {
                let nextIndex = (index + 1)

                guard nextIndex < centerPopints.count else {
                    return
                }

                let nextCenter = centerPopints[nextIndex]
                connections.append(
                    CAShapeLayer.line(from: center, to: nextCenter, strokeColor: UIColor(white: 1, alpha: 0.2))
                )
            }
        }
        return connections
    }
}

// MARK: - Data Points

extension MeSolarViewDrawHelper {

    static func dataPoints(sectors: [Sector], layout: Layout.MeSection) -> [CAShapeLayer] {
        var dots = [CAShapeLayer]()
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
                let radius = MeSolarViewDrawHelper.radius(for: spike.spikeLoad(), layout: layout)

                dots.append(
                    MeSolarViewDrawHelper.dot(
                        fillColor: fillColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type, layout: layout),
                        strokeColor: strokeColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type, layout: layout),
                        center: center,
                        radius: (spike.spikeLoad() * 8),
                        lineWidth: sector.type.lineWidth(load: spike.load)
                    )
                )
            }
        }
        return dots
    }
}

// MARK: - Sector Labels

extension MeSolarViewDrawHelper {

    static func labelValues(for sector: Sector, layout: Layout.MeSection) -> (attributedString: NSAttributedString, widthOffset: CGFloat) {
        let text = sector.label.text.uppercased()
        let criticalLoads = sector.spikes.filter { (spike: Spike) -> Bool in
            let distanceCenter = radius(for: spike.spikeLoad(), layout: layout)
            return distanceCenter > average(for: spike.load, layout: layout)
        }

        if criticalLoads.isEmpty == true {
            return (attributedString: AttributedString.MeSection.sectorTitle(text: text), widthOffset: 0)
        }

        return (attributedString: AttributedString.MeSection.sectorTitleCritical(text: text), widthOffset: 20)
    }
}

// MARK: - Private

private extension MeSolarViewDrawHelper {

    static func dot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: fillColor,
            strokeColor: strokeColor
        )

        shapeLayer.lineWidth = lineWidth
        shapeLayer.addGlowEffect(color: fillColor)
        return shapeLayer
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
