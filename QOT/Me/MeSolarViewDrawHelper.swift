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

    // MARK: - Properties

    fileprivate static var dataCenterPoints = [[CGPoint]]()
    fileprivate static var connectionCenterPoitns = [[CGPoint]]()

    static func collectCenterPoints(layout: Layout.MeSection, sectors: [Sector], relativeCenter: CGPoint) {
        sectors.forEach { (sector: Sector) in
            var centerPoints = [CGPoint]()

            sector.spikes.forEach { (spike: Spike) in
                let centerPoint = CGPoint().shiftedCenter(
                    radius(for: spike.spikeLoad(), layout: layout),
                    with: spike.angle,
                    to: relativeCenter
                )

                centerPoints.append(centerPoint)
            }

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
                        fillColor: fillColor(radius: radius, load: spike.spikeLoad(), layout: layout),
                        strokeColor: strokeColor(radius: radius, load: spike.spikeLoad(), layout: layout),
                        center: center,
                        radius: (spike.load * 8)
                    )
                )
            }
        }
        return dots
    }

    private static func dot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat) -> CAShapeLayer {
        let circlePath = UIBezierPath.circlePath(center: CGPoint(x: 100, y: 100), radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: fillColor,
            strokeColor: strokeColor
        )
        shapeLayer.lineWidth = radius * 2
        shapeLayer.shadowColor = UIColor.green.cgColor// strokeColor.cgColor
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowOpacity = 0.9
        shapeLayer.shadowOffset = .zero
        return shapeLayer
    }

    static func radius(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        let factor: CGFloat = layout.radiusMaxLoad
        let offset: CGFloat = (layout.profileImageWidth * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)
    }

    static func fillColor(radius: CGFloat, load: CGFloat, layout: Layout.MeSection) -> UIColor {
        return radius > average(for: load, layout: layout) ? Color.MeSection.redFilled : .white
    }

    static func strokeColor(radius: CGFloat, load: CGFloat, layout: Layout.MeSection) -> UIColor {
        return radius > average(for: load, layout: layout) ? Color.MeSection.redStroke : Color.MeSection.whiteStroke
    }

    static func labelValues(for sector: Sector, layout: Layout.MeSection) -> (font: UIFont, textColor: UIColor, widthOffset: CGFloat) {
        let criticalLoads = sector.spikes.filter { (spike: Spike) -> Bool in
            let distanceCenter = radius(for: spike.spikeLoad(), layout: layout)
            return distanceCenter > average(for: spike.load, layout: layout)
        }

        if criticalLoads.isEmpty == true {
            return (font: Font.MeSection.sectorDefault, textColor: Color.MeSection.whiteLabel, widthOffset: 0)
        }

        return (font: Font.MeSection.sectorRed, textColor: Color.MeSection.redFilled, widthOffset: 15)
    }

    private static func average(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        return (layout.radiusAverageLoad - (load * 4))
    }
}
