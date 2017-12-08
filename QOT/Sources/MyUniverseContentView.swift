//
//  MyUniverseswift
//  QOT
//
//  Created by Lee Arromba on 07/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MyUniverseContentViewDelegate: class {
    func myUniverseContentViewDidTapProfile(_ viewController: MyUniverseContentView)
    func myUniverseContentViewDidTapWeeklyChoice(_ viewController: MyUniverseContentView, at index: Int)
    func myUniverseContentViewDidTapPartner(_ viewController: MyUniverseContentView, at index: Int)
}

extension MyUniverseContentView {
    struct Sector {
        struct Line {
            let chartType: ChartType
            let layer: CALayer
            let point: Point
        }
        struct Point {
            let layer: CAShapeLayer
            let radius: CGFloat
        }
        let type: StatisticsSectionType
        let label: UILabel
        let lines: [Line]

        func contains(_ point: CGPoint) -> Bool {
            if label.frame.contains(point) {
                return true
            }
            for line in lines {
                if line.point.layer.position.distanceTo(point) < max(line.point.radius, 20.0) {
                    return true
                }
            }
            return false
        }
    }
}

final class MyUniverseContentView: UIView {
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var profileWrapperView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileButtonOverlay: UIImageView!

    @IBOutlet weak var visionWrapperView: UIView!
    @IBOutlet weak var visionTextLabel: UILabel!
    @IBOutlet weak var visionTitleLabel: UILabel!

    @IBOutlet weak var weeklyChoicesWrapperView: UIView!
    @IBOutlet weak var weeklyChoicesTitleLabel: UILabel!
    @IBOutlet var weeklyChoiceButtons: [UIButton]!

    @IBOutlet weak var partnersWrapperView: UIView!
    @IBOutlet weak var partnersTitleLabel: UILabel!
    @IBOutlet weak var partnersComingSoonLabel: UILabel! // FIXME: remove when feature is available
    @IBOutlet var partnerButtons: [UIButton]!

    weak var delegate: MyUniverseContentViewDelegate?
    var sectors = [Sector]()

    private let profileButtonGlowLayer: CAShapeLayer = {
        let layer = CAShapeLayer(fillColor: .clear, strokeColor: .white20, lineWidth: 5)
        layer.addGlowEffect(color: .white)
        return layer
    }()
    private let circle1 = CAShapeLayer(fillColor: .clear, strokeColor:  UIColor(white: 1, alpha: 0.08), lineWidth: 1)
    private let circle2 = CAShapeLayer(fillColor: .clear, strokeColor:  UIColor(white: 1, alpha: 0.08), lineWidth: 1)
    private let visionLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.4)
    private let weeklyChoicesLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.4)
    private let partnersLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.4)

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.insertSublayer(circle1, below: profileWrapperView.layer)
        layer.insertSublayer(circle2, below: profileWrapperView.layer)
        layer.insertSublayer(visionLine, below: profileWrapperView.layer)
        layer.insertSublayer(weeklyChoicesLine, below: profileWrapperView.layer)
        layer.insertSublayer(partnersLine, below: profileWrapperView.layer)
        layer.insertSublayer(profileButtonGlowLayer, below: profileWrapperView.layer)

        visionWrapperView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(visionTapped(_:)))
        )
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupProfileButton()
        setupCircles()
        setupMyWhyLines()
    }

    func setupMyData(for sectors: [MyUniverseViewData.Sector]) {
        guard let circle2Circumference = circle2.path?.boundingBox.width else { return }
        let center = profileWrapperView.center
        let maxDistance = circle2Circumference / 2
        let radius = profileWrapperView.bounds.width / 2.0
        var viewSectors = [Sector]()

        // maths - http://classroom.synonym.com/coordinates-distances-angles-2732.html

        sectors.forEach { sector in
            // add label for sector
            let midAngle = sector.midAngle()
            let label = UILabel()
            label.attributedText = NSMutableAttributedString(
                string: sector.title,
                letterSpacing: 2,
                font: UIFont.simpleFont(ofSize: sector.titleSize),
                textColor: sector.titleColor,
                alignment: .center
            )
            label.numberOfLines = 0
            addSubview(label)

            label.sizeToFit()
            let padding = (label.bounds.width / 2.0) + 7
            label.center = CGPoint(
                x: center.x + cos(midAngle.degreesToRadians) * (maxDistance + padding),
                y: center.y + sin(midAngle.degreesToRadians) * (maxDistance + padding)
            )

            // add lines / dots for sector
            var lines = [Sector.Line]()
            for (index, line) in sector.lines.enumerated() {
                let angle = sector.angle(for: index)
                let distance = maxDistance * line.dot.distance
                let cosAngle = cos(angle.degreesToRadians)
                let sinAngle = sin(angle.degreesToRadians)
                let padding: CGFloat = profileButtonGlowLayer.lineWidth
                let minPoint = CGPoint(
                    x: center.x + cosAngle * (radius + line.dot.circumference + padding),
                    y: center.y + sinAngle * (radius + line.dot.circumference + padding)
                )
                let x: CGFloat = angle < 90 ?
                    max((center.x + cosAngle * distance), minPoint.x) :
                    min((center.x + cosAngle * distance), minPoint.x)
                let y: CGFloat = angle < 180 ?
                    max((center.y + sinAngle * distance), minPoint.y) :
                    min((center.y + sinAngle * distance), minPoint.y)
                let point = CGPoint(x: x, y: y)

                let lineLayer = CAShapeLayer.line(from: center, to: point, strokeColor: .white40)
                let pointLayer = CAShapeLayer.circle(
                    center: .zero,
                    radius: line.dot.radius,
                    fillColor: line.dot.fillColor,
                    strokeColor: line.dot.strokeColor,
                    lineWidth: line.dot.lineWidth
                )
                pointLayer.position = point
                pointLayer.anchorPoint = CGPoint(x: 1, y: 1)
                pointLayer.addGlowEffect(color: line.dot.fillColor)

                lines.append(Sector.Line(
                    chartType: line.chartType,
                    layer: lineLayer,
                    point: Sector.Point(layer: pointLayer, radius: line.dot.radius)
                ))
                layer.insertSublayer(lineLayer, below: profileWrapperView.layer)
                layer.addSublayer(pointLayer)
            }

            viewSectors.append(Sector(type: sector.type, label: label, lines: lines))
        }

        // remove old views
        self.sectors.forEach { sector in
            sector.label.removeFromSuperview()
            sector.lines.forEach({ line in
                line.layer.removeFromSuperlayer()
                line.point.layer.removeFromSuperlayer()
            })
        }
        // save the reference
        self.sectors = viewSectors
    }

    // MARK: - private

    private func setupProfileButton() {
        let radius = profileButtonOverlay.bounds.width / 2.0
        profileButton.layer.cornerRadius = radius
        profileButtonOverlay.layer.cornerRadius = radius
        profileButtonGlowLayer.path = UIBezierPath.circlePath(center: .zero, radius: radius).cgPath
        profileButtonGlowLayer.position = profileWrapperView.center
    }

    private func setupCircles() {
        circle1.position = profileWrapperView.center
        circle2.position = profileWrapperView.center

        let radius = (profileButton.bounds.width / 2)
        circle1.path = UIBezierPath.circlePath(center: .zero, radius: radius * 2.7).cgPath
        circle2.path = UIBezierPath.circlePath(center: .zero, radius: radius * 3.8).cgPath
    }

    private func setupMyWhyLines() {
        let fromPoint = profileWrapperView.center
        let visionPoint = CGPoint(
            x: visionWrapperView.frame.origin.x,
            y: visionWrapperView.frame.origin.y + visionWrapperView.bounds.height
        )
        let weeklyChoicesPoint = CGPoint(
            x: weeklyChoicesWrapperView.frame.origin.x,
            y: weeklyChoicesWrapperView.center.y
        )
        let partnersPoint = CGPoint(
            x: partnersWrapperView.frame.origin.x + (partnersWrapperView.bounds.width * 0.3),
            y: partnersWrapperView.frame.origin.y
        )
        visionLine.path = UIBezierPath.linePath(from: fromPoint, to: visionPoint).cgPath
        weeklyChoicesLine.path = UIBezierPath.linePath(from: fromPoint, to: weeklyChoicesPoint).cgPath
        partnersLine.path = UIBezierPath.linePath(from: fromPoint, to: partnersPoint).cgPath
    }

    // MARK: - actions

    @objc private func visionTapped(_ sender: UIGestureRecognizer) {
        delegate?.myUniverseContentViewDidTapProfile(self)
    }

    @IBAction private func profileButtonPressed(_ sender: UIButton) {
        delegate?.myUniverseContentViewDidTapProfile(self)
    }

    @IBAction private func partnerButtonPressed(_ sender: UIButton) {
        guard let index = partnerButtons.index(of: sender) else { return }
        delegate?.myUniverseContentViewDidTapPartner(self, at: index)
    }

    @IBAction private func weeklyChoiceButtonPressed(_ sender: UIButton) {
        guard let index = weeklyChoiceButtons.index(of: sender) else { return }
        delegate?.myUniverseContentViewDidTapWeeklyChoice(self, at: index)
    }
}

// MARK: - CAShapeLayer

private extension CAShapeLayer {
    convenience init(fillColor: UIColor, strokeColor: UIColor, lineWidth: CGFloat,
                     anchorPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        self.init()
        self.fillColor = fillColor.cgColor
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
    }
}
