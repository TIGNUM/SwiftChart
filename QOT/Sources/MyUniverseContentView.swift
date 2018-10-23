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

    @IBOutlet weak var profileBlurView: UIVisualEffectView!
    @IBOutlet weak var profileWrapperView: UIView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var profileButtonOverlay: UIImageView!
    @IBOutlet weak var visionWrapperView: UIView!
    @IBOutlet weak var visionHeadlineLabel: UILabel!
    @IBOutlet weak var visionTextLabel: UILabel!
    @IBOutlet weak var visionTypeLabel: UILabel!
    @IBOutlet weak var weeklyChoicesWrapperView: UIView!
    @IBOutlet weak var weeklyChoicesTitleLabel: UILabel!
    @IBOutlet var weeklyChoiceButtons: [UIButton]!
    @IBOutlet weak var partnersWrapperView: UIView!
    @IBOutlet weak var partnersTitleLabel: UILabel!
    @IBOutlet var partnerButtons: [UIButton]!
    weak var delegate: MyUniverseContentViewDelegate?
    var sectors = [Sector]()
    let visionLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.8)
    let weeklyChoicesLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.8)
    let partnersLine = CAShapeLayer(fillColor: .clear, strokeColor: .white40, lineWidth: 0.8)
    private let circle1 = CAShapeLayer(fillColor: .clear, strokeColor: .whiteLight14, lineWidth: 0.9)
    private let circle2 = CAShapeLayer(fillColor: .clear, strokeColor: .whiteLight8, lineWidth: 0.8)
    private let profileButtonGlowLayer: CAShapeLayer = {
        let layer = CAShapeLayer(fillColor: .clear, strokeColor: .white20, lineWidth: 5)
        layer.addGlowEffect(color: .white)
        return layer
    }()

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
        visionWrapperView.backgroundColor = .clear
        weeklyChoicesWrapperView.backgroundColor = .clear
        partnersWrapperView.backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircles()
        setupMyWhyLines()
        setupProfileButton()
    }

    func setVisionText(_ text: String) {
        visionTextLabel.attributedText = NSAttributedString(string: text,
                                                            letterSpacing: 1.7,
                                                            font: .PTextSmall,
                                                            lineSpacing: 3,
                                                            textColor: .white,
                                                            alignment: .left,
                                                            lineBreakMode: .byTruncatingTail)
    }

    func setVisionHeadline(_ headline: String) {
        visionHeadlineLabel.attributedText = NSAttributedString(string: headline.uppercased(),
                                                                letterSpacing: 1.7,
                                                                font: .H6NavigationTitle,
                                                                lineSpacing: 1.5,
                                                                textColor: .white,
                                                                alignment: .left,
                                                                lineBreakMode: .byTruncatingTail)
    }

    func setupMyData(for sectors: [MyUniverseViewData.Sector]) {
        guard let circle2Circumference = circle2.path?.boundingBox.width else { return }
        let center = profileWrapperView.center
        let maxDistance = circle2Circumference / 2
        let radius = profileWrapperView.bounds.width / 2
        var viewSectors = [Sector]()

        // maths - http://classroom.synonym.com/coordinates-distances-angles-2732.html
//        print("PRINTING CHARTS")
        sectors.forEach { sector in
            // add label for sector
            let midAngle = sector.midAngle()
            let label = UILabel()
            label.attributedText = NSMutableAttributedString(string: sector.title,
                                                             letterSpacing: 2,
                                                             font: UIFont.apercuRegular(ofSize: sector.titleSize),
                                                             textColor: sector.titleColor,
                                                             alignment: .center)
            label.numberOfLines = 0
            addSubview(label)
            label.sizeToFit()
            let padding = (label.bounds.width / 2) +
                ((sector.type == .activity || sector.type == .peakPerformance) ? -14 : 7)
            label.center = CGPoint(x: center.x + cos(midAngle.degreesToRadians) * (maxDistance + padding),
                                   y: center.y + sin(midAngle.degreesToRadians) * (maxDistance + padding))

            // add lines / dots for sector
            var lines = [Sector.Line]()
            for (index, line) in sector.lines.enumerated() {
                let angle = sector.angle(for: index)
                let distance = maxDistance * line.dot.distance
                //                print("angle: \(angle), CHART TYPE: \(line.chartType.rawValue), color: \(line.dot.fillColor), distance: \(line.dot.distance)")
                let cosAngle = cos(angle.degreesToRadians)
                let sinAngle = sin(angle.degreesToRadians)
                let padding: CGFloat = profileButtonGlowLayer.lineWidth
                let minPoint = CGPoint(x: center.x + cosAngle * (radius + line.dot.circumference + padding),
                                       y: center.y + sinAngle * (radius + line.dot.circumference + padding))
                let x: CGFloat = angle < 90 ?
                    max((center.x + cosAngle * distance), minPoint.x) :
                    min((center.x + cosAngle * distance), minPoint.x)
                let y: CGFloat = angle < 180 ?
                    max((center.y + sinAngle * distance), minPoint.y) :
                    min((center.y + sinAngle * distance), minPoint.y)
                let point = CGPoint(x: x, y: y)
                let lineLayer = CAShapeLayer.line(from: center, to: point, strokeColor: .white40)
                let pointLayer = CAShapeLayer.circle(center: .zero,
                                                     radius: line.dot.radius,
                                                     fillColor: line.dot.fillColor,
                                                     strokeColor: line.dot.strokeColor,
                                                     lineWidth: line.dot.lineWidth)
                pointLayer.position = point
                pointLayer.anchorPoint = CGPoint(x: 1, y: 1)
                pointLayer.addGlowEffect(color: line.dot.fillColor)
                lines.append(Sector.Line(chartType: line.chartType,
                                         layer: lineLayer,
                                         point: Sector.Point(layer: pointLayer, radius: line.dot.radius)))
                layer.insertSublayer(lineLayer, below: profileWrapperView.layer)
                layer.addSublayer(pointLayer)
            }
            viewSectors.append(Sector(type: sector.type, label: label, lines: lines))
        }

        // remove old views
        self.sectors.forEach { sector in
            sector.label.removeFromSuperview()
            sector.lines.forEach { line in
                line.layer.removeFromSuperlayer()
                line.point.layer.removeFromSuperlayer()
            }
        }
        // save the reference
        self.sectors = viewSectors
    }

    // MARK: - private

    private func setupProfileButton() {
        let radius = profileButtonOverlay.bounds.width / 2
        profileBlurView.corner(radius: radius)
        profileButton.corner(radius: radius)
        profileButtonOverlay.corner(radius: radius)
        profileButtonGlowLayer.path = UIBezierPath.circlePath(center: .zero, radius: radius).cgPath
        profileButtonGlowLayer.position = profileWrapperView.center
    }

    private func setupCircles() {
        circle1.position = profileWrapperView.center
        circle2.position = profileWrapperView.center
        circle1.path = UIBezierPath.circlePath(center: .zero, radius: bounds.width * 0.26).cgPath
        circle2.path = UIBezierPath.circlePath(center: .zero, radius: bounds.width * 0.4).cgPath
        circle1.lineDashPattern = [3, 1]
    }

    private func setupMyWhyLines() {
        let visionPoint = CGPoint(
            x: visionWrapperView.frame.origin.x + (visionWrapperView.frame.width * 0.2),
            y: visionWrapperView.frame.origin.y + visionWrapperView.bounds.height
        )
        let weeklyChoicesPoint = CGPoint(
            x: weeklyChoicesWrapperView.frame.origin.x + (weeklyChoicesWrapperView.frame.width * 0.05),
            y: weeklyChoicesWrapperView.center.y
        )
        let partnersPoint = CGPoint(
            x: partnersWrapperView.frame.origin.x + (partnersWrapperView.bounds.width * 0.2),
            y: partnersWrapperView.frame.origin.y
        )
        let fromPoint = profileWrapperView.center
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

    convenience init(fillColor: UIColor,
                     strokeColor: UIColor,
                     lineWidth: CGFloat,
                     anchorPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        self.init()
        self.fillColor = fillColor.cgColor
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
    }
}
