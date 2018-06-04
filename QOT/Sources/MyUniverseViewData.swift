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
    let myToBeVisionHeadline: String
    let myToBeVisionText: String
    let sectors: [Sector]
    let isLoading: Bool
}

// MARK: - Equatable

extension MyUniverseViewData: Equatable {
    static func == (lhs: MyUniverseViewData, rhs: MyUniverseViewData) -> Bool {
        return lhs == rhs
    }
}

extension MyUniverseViewData.Partner: Equatable {
    static func == (lhs: MyUniverseViewData.Partner, rhs: MyUniverseViewData.Partner) -> Bool {
        return lhs == rhs
    }
}

extension MyUniverseViewData.Sector: Equatable {
    static func == (lhs: MyUniverseViewData.Sector, rhs: MyUniverseViewData.Sector) -> Bool {
        return lhs == rhs
    }
}

extension MyUniverseViewData.Line: Equatable {
    static func == (lhs: MyUniverseViewData.Line, rhs: MyUniverseViewData.Line) -> Bool {
        return lhs == rhs
    }
}

extension MyUniverseViewData.Dot: Equatable {
    static func == (lhs: MyUniverseViewData.Dot, rhs: MyUniverseViewData.Dot) -> Bool {
        return lhs == rhs
    }
}
