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

    fileprivate var containerView: ContainerView = ContainerView()

    init(frame: CGRect, columns: [EventGraphView.Column], dayNames: [String]) {
        super.init(frame: frame)
        containerView.setup(columns: columns, dayNames: dayNames)
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

    func setupAverageLine(level: CGFloat, lineType: LineType) {
        let position = bounds.height * level
        let frame = CGRect(x: bounds.minX + 5, y: bounds.height - position, width: bounds.width - 15, height: 0)
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

    func setup() {
        addLines()
        addSubview(containerView)
    }

    func loadSubViews() {
        containerView.frame = bounds
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
        line.lineWidth = 1.5
        line.lineDashPattern = [1.5, 3]
        line.path = linePath.cgPath
        return line
    }
}
