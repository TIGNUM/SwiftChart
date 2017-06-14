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
    fileprivate lazy var eventView: EventGraphView = EventGraphView()

    init(frame: CGRect, columns: [EventGraphView.Column]) {
        super.init(frame: frame)
        eventView.columns = columns
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadSubViews()
    }

    func setupAverageLine(color: UIColor, level: CGFloat, lineType: LineType) {
        let position = bounds.height * level
        let frame = CGRect(x: bounds.minX + 5, y: bounds.height - position, width: bounds.width - 15, height: 0)
        switch lineType {
        case .average:
            averageLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            averageLine.strokeColor = color.cgColor
        case .personal:
            personalLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            personalLine.strokeColor = color.cgColor
        case .team:
            teamLine.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            teamLine.strokeColor = color.cgColor
        }
    }
}

private extension ActivityChartView {

    func setup() {
        addSubview(eventView)

        addLines()
    }

    func loadSubViews() {
        eventView.frame = bounds
    }

    func addLines() {
        averageLine = createDottedLayer()
        teamLine = createDottedLayer()
        personalLine = createDottedLayer()

        layer.addSublayer(averageLine)
        layer.addSublayer(teamLine)
        layer.addSublayer(personalLine)

    }

    func createDottedLayer() -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath(roundedRect: .zero, cornerRadius: 0)
        line.strokeColor = UIColor.clear.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.frame = linePath.bounds
        line.lineWidth = 2.0
        line.lineDashPattern = [2, 4.5]
        line.path = linePath.cgPath
        return line
    }
    
    
}
