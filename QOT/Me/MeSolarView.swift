//
//  MeSolarView.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeSolarView: UIView {

    // MARK: - Properties

    var profileImageView = UIImageView()
    var sectors = [Sector]()
    var profileImage: UIImage?
    var previousBounds = CGRect.zero

    // MARK: - Init

    init(sectors: [Sector], profileImage: UIImage?, frame: CGRect) {
        self.sectors = sectors
        self.profileImage = profileImage

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        guard previousBounds.equalTo(bounds) == false else {
            return
        }

        previousBounds = bounds
        cleanUp()
        let layout = Layout.MeSection(viewControllerFrame: bounds)
        drawUniverse(with: sectors, profileImage: profileImage, layout: layout)
    }
}

// MARK: - Private Helpers / Clean View

private extension MeSolarView {

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}

// MARK: - Private Helpers / Draw SolarSystem

private extension MeSolarView {

    func drawUniverse(with sectors: [Sector], profileImage: UIImage?, layout: Layout.MeSection) {
        self.sectors = sectors
        self.profileImage = profileImage

        drawBackCircles(layout: layout, radius: layout.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(layout: layout, radius: layout.radiusMaxLoad)
        setupProfileImage(layout: layout, profileImage: profileImage)
        MeSolarViewDrawHelper.collectCenterPoints(layout: layout, sectors: sectors, relativeCenter: profileImageView.center)
        drawDataPointConnections(layout: layout, sectors: sectors)
        drawDataPoints(layout: layout, sectors: sectors)
        addSectorLabels(layout: layout, sectors: sectors)
        addSubview(profileImageView)
    }

    func setupProfileImage(layout: Layout.MeSection, profileImage: UIImage?) {
        profileImageView = UIImageView(frame: layout.profileImageViewFrame)
        profileImageView.image = profileImage
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = layout.profileImageWidth * 0.5
        profileImageView.clipsToBounds = true
    }

    func drawBackCircles(layout: Layout.MeSection, radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circlePath = UIBezierPath.circlePath(center: layout.loadCenter, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: Color.MeSection.whiteStrokeLight
        )
        shapeLayer.lineDashPattern = linesDashPattern
        layer.addSublayer(shapeLayer)
    }

    func drawDataPointConnections(layout: Layout.MeSection, sectors: [Sector]) {
        let connections = MeSolarViewDrawHelper.dataPointConnections(sectors: sectors, layout: layout)
        connections.forEach { (connection: CAShapeLayer) in
            layer.addSublayer(connection)
        }
    }

    func drawDataPoints(layout: Layout.MeSection, sectors: [Sector]) {
        let dataPoints = MeSolarViewDrawHelper.dataPoints(sectors: sectors, layout: layout)
        dataPoints.forEach { (dataPoint: CAShapeLayer) in
            layer.addSublayer(dataPoint)
        }
    }

    func addSectorLabels(layout: Layout.MeSection, sectors: [Sector]) {
        sectors.forEach { (sector: Sector) in
            let categoryLabel = sector.label
            let labelCenter = CGPoint().shiftedCenter(
                MeSolarViewDrawHelper.radius(for: categoryLabel.load, layout: layout),
                with: categoryLabel.angle,
                to: profileImageView.center
            )

            let labelValues = MeSolarViewDrawHelper.labelValues(for: sector, layout: layout)
            let frame = CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: Layout.MeSection.labelHeight)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text.uppercased()
            label.textColor = labelValues.textColor
            label.font = labelValues.font
            label.numberOfLines = 0
            label.textAlignment = .center
            label.frame = CGRect(x: labelCenter.x - labelValues.widthOffset, y: labelCenter.y, width: frame.width, height: Layout.MeSection.labelHeight)
            label.sizeToFit()
            addSubview(label)
        }
    }
}
