//
//  SittingMovementChartView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ActivityChartView: UIView {

    enum AverageLineType {
        case data
        case personal
        case team

        static var allValues: [AverageLineType] {
            return [.data, .personal, .team]
        }

        var strokeColor: CGColor {
            switch self {
            case .data: return UIColor.cherryRedTwo30.cgColor
            case .personal: return UIColor.white8.cgColor
            case .team: return UIColor.azure20.cgColor
            }
        }

        func averageValue(myStatistics: MyStatistics) -> CGFloat {
            switch self {
            case .data: return myStatistics.dataAverage.toFloat
            case .personal: return myStatistics.userAverage.toFloat
            case .team: return myStatistics.teamAverage.toFloat
            }
        }
    }

    // MARK: - Properties

    fileprivate let myStatistics: MyStatistics
    fileprivate let containerView: ContainerView = ContainerView()

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.frame = bounds
    }
}

// MARK: - Private

private extension ActivityChartView {

    func setupView() {
        setupContainerView()
        setupAverageLine()
    }

    func setupContainerView() {
        guard let activityData = (columns(myStatistics: myStatistics) as? MyStatisticsDataActivity)?.data else {
            return
        }
        
        let dayNames = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)
        containerView.setup(columns: activityData, dayNames: dayNames)
        addSubview(containerView)
    }

    func setupAverageLine() {
        let padding: CGFloat = 7
        let separatorHeight: CGFloat = 1
        let height = bounds.height - padding - separatorHeight

        AverageLineType.allValues.forEach { (averageLineType: AverageLineType) in
            let position = height * averageLineType.averageValue(myStatistics: myStatistics)
            let xPos = bounds.minX + padding
            let yPos = bounds.height - position
            let width = bounds.width - 2 * padding
            let frame = CGRect(x: xPos, y: yPos, width: width, height: 0)
            let averageLayer = createDottedLayer()
            averageLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            averageLayer.strokeColor = averageLineType.strokeColor
            layer.addSublayer(averageLayer)
        }
    }

    func createDottedLayer() -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath(roundedRect: .zero, cornerRadius: 0)
        line.strokeColor = UIColor.clear.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.frame = linePath.bounds
        line.lineWidth = 1.5
        line.lineDashPattern = [1.5, 3]
        line.path = linePath.cgPath

        return line
    }

    func columns(myStatistics: MyStatistics) -> MyStatisticsData {
        var data: [EventGraphData] = []
        let threshold = StatisticsThreshold<CGFloat>(
            upperThreshold: myStatistics.upperThreshold.toFloat,
            lowerThreshold: myStatistics.lowerThreshold.toFloat
        )

        myStatistics.dataPoints.forEach { (doubleObject: DoubleObject) in
            data.append(EventGraphData(start: 1, end: doubleObject.toFloat))
        }

        return MyStatisticsDataActivity(
            teamAverage: myStatistics.teamAverage.toFloat,
            dataAverage: myStatistics.dataAverage.toFloat,
            userAverage: myStatistics.userAverage.toFloat,
            threshold: threshold,
            data: data,
            fillColumn: myStatistics.key == StatisticCardType.activitySittingMovementRatio.rawValue
        )
    }
}
