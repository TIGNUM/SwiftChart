//
//  SittingMovementChartView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ActivityChartView: UIView {

    enum LineType {
        case average
        case personal
        case team
    }

    fileprivate var averageLine = CAShapeLayer()
    fileprivate var teamLine = CAShapeLayer()
    fileprivate var personalLine = CAShapeLayer()
    fileprivate let myStatistics: MyStatistics
    fileprivate var containerView: ContainerView = ContainerView()

    init(frame: CGRect, dayNames: [String], myStatistics: MyStatistics) {
        self.myStatistics = myStatistics
        super.init(frame: frame)

        guard let activityData = (columns(myStatistics: myStatistics) as? MyStatisticsDataActivity)?.data else {
            return
        }
        
        containerView.setup(columns: activityData, dayNames: dayNames)
        setupView()
    }

    private func columns(myStatistics: MyStatistics) -> MyStatisticsData {
        var data: [EventGraphData] = []
        let threshold = StatisticsThreshold<CGFloat>(
            upperThreshold: myStatistics.upperThreshold.toFloat,
            lowerThreshold: myStatistics.lowerThreshold.toFloat
        )

        myStatistics.dataPoints.forEach { (doubleObject: DoubleObject) in
            data.append(EventGraphData(start: 1, end: doubleObject.toFloat))
        }

        return MyStatisticsDataActivity(
            teamAverage: myStatistics.teamAverage.toFloat/10,
            dataAverage: myStatistics.dataAverage.toFloat/10,
            userAverage: myStatistics.userAverage.toFloat/10,
            threshold: threshold,
            data: data
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.frame = bounds
    }

    func setupAverageLine(level: CGFloat, lineType: LineType) {
        let padding: CGFloat = 7
        let separatorHeight: CGFloat = 1
        let height = bounds.height - padding - separatorHeight
        let position = height * (level / 10) /// FIXME: level have to be a value bewtween 0...1 
        let frame = CGRect(x: bounds.minX + padding, y: bounds.height - position, width: bounds.width - 2 * padding, height: 0)
        switch lineType {
        case .average:
            averageLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            averageLine.strokeColor = UIColor.cherryRedTwo30.cgColor
        case .personal:
            personalLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            personalLine.strokeColor = UIColor.white8.cgColor
        case .team:
            teamLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            teamLine.strokeColor = UIColor.azure20.cgColor
        }
    }
}

private extension ActivityChartView {

    func setupView() {
        averageLine = createDottedLayer()
        teamLine = createDottedLayer()
        personalLine = createDottedLayer()

        layer.addSublayer(averageLine)
        layer.addSublayer(teamLine)
        layer.addSublayer(personalLine)
        addSubview(containerView)
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
}
