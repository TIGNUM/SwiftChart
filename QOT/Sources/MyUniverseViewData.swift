//
//  MyUniverseViewData.swift
//  QOT
//
//  Created by Lee Arromba on 29/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

struct MyUniverseViewData {
    struct Sector {
        let type: StatisticsSectionType
        let title: String
        let titleColor: UIColor
        let titleSize: CGFloat
        let startAngle: CGFloat
        let endAngle: CGFloat
        let lines: [Line]

        func angle(for lineIndex: Int) -> CGFloat {
            guard lineIndex >= lines.startIndex, lineIndex < lines.endIndex else { return 0 }
            let meanAverageAngle = (endAngle - startAngle) / CGFloat(lines.count - 1)
            return startAngle + (meanAverageAngle * CGFloat(lineIndex))
        }

        func midAngle() -> CGFloat {
            return (startAngle + endAngle) / 2
        }
    }
    struct Line {
        let color: UIColor
        let dot: Dot
        let chartType: ChartType
    }
    struct Dot {
        let fillColor: UIColor
        let strokeColor: UIColor
        let lineWidth: CGFloat
        let radius: CGFloat
        let distance: CGFloat
        var circumference: CGFloat {
            return radius * 2.0
        }
    }
    struct Partner {
        let imageURL: URL?
        let initials: String
    }

    let profileImageURL: URL?
    let partners: [Partner]
    let weeklyChoices: [WeeklyChoice]
    let myToBeVisionText: String
    let sectors: [Sector]
}

// MARK: - Equatable

extension MyUniverseViewData: Equatable {
    static func == (lhs: MyUniverseViewData, rhs: MyUniverseViewData) -> Bool {
        return lhs.profileImageURL == rhs.profileImageURL
            && lhs.partners == rhs.partners
            && lhs.weeklyChoices == rhs.weeklyChoices
            && lhs.myToBeVisionText == rhs.myToBeVisionText
            && lhs.sectors == rhs.sectors
    }
}

extension MyUniverseViewData.Partner: Equatable {
    static func == (lhs: MyUniverseViewData.Partner, rhs: MyUniverseViewData.Partner) -> Bool {
        return lhs.imageURL == rhs.imageURL
            && lhs.initials == rhs.initials
    }
}

extension MyUniverseViewData.Sector: Equatable {
    static func == (lhs: MyUniverseViewData.Sector, rhs: MyUniverseViewData.Sector) -> Bool {
        return lhs.type == rhs.type
            && lhs.title == rhs.title
            && lhs.titleColor == rhs.titleColor
            && lhs.titleSize == rhs.titleSize
            && lhs.startAngle == rhs.startAngle
            && lhs.endAngle == rhs.endAngle
            && lhs.lines == rhs.lines
    }
}

extension MyUniverseViewData.Line: Equatable {
    static func == (lhs: MyUniverseViewData.Line, rhs: MyUniverseViewData.Line) -> Bool {
        return lhs.color == rhs.color
            && lhs.dot == rhs.dot
            && lhs.chartType == rhs.chartType
    }
}

extension MyUniverseViewData.Dot: Equatable {
    static func == (lhs: MyUniverseViewData.Dot, rhs: MyUniverseViewData.Dot) -> Bool {
        return lhs.fillColor == rhs.fillColor
            && lhs.strokeColor == rhs.strokeColor
            && lhs.lineWidth == rhs.lineWidth
            && lhs.radius == rhs.radius
            && lhs.distance == rhs.distance
    }
}
