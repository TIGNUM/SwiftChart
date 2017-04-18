//
//  MyDataView.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyDataView: UIView {

    // MARK: - Properties

    var profileImageView = UIImageView()
    var profileImageViewOverlay = UIImageView()
    var profileImageViewOverlayEffect = UIImageView()
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

        cleanUp()
        previousBounds = bounds
        drawUniverse(with: sectors, profileImage: profileImage, layout: Layout.MeSection(viewControllerFrame: bounds))
    }
}

// MARK: - Private Helpers / Clean View

private extension MyDataView {

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}

// MARK: - Private Helpers / Draw SolarSystem

private extension MyDataView {

    func drawUniverse(with sectors: [Sector], profileImage: UIImage?, layout: Layout.MeSection) {
        self.sectors = sectors
        self.profileImage = profileImage

        drawBackCircles(layout: layout, radius: layout.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(layout: layout, radius: layout.radiusMaxLoad)
        setupProfileImage(layout: layout, profileImage: profileImage)
        MyUniverseHelper.collectCenterPoints(layout: layout, sectors: sectors, relativeCenter: profileImageView.center)
        drawDataPointConnections(layout: layout, sectors: sectors)
        drawDataPoints(layout: layout, sectors: sectors)
        addSubview(profileImageView)
        addSubview(profileImageViewOverlay)
        addSubview(profileImageViewOverlayEffect)
    }

    func setupProfileImage(layout: Layout.MeSection, profileImage: UIImage?) {
        profileImageView = UIImageView(frame: layout.profileImageViewFrame, image: profileImage)
        profileImageViewOverlay = UIImageView(frame: layout.profileImageViewFrame, image: profileImage?.convertToGrayScale())
        profileImageViewOverlayEffect = UIImageView(frame: layout.profileImageViewFrame, image: nil)
        profileImageViewOverlayEffect.backgroundColor = Color.Default.whiteMedium
        addImageEffect(center: layout.loadCenter)
    }

    func addImageEffect(center: CGPoint) {
        let circleLayer = CAShapeLayer.circle(
            center: center,
            radius: profileImageView.frame.width * 0.5,
            fillColor: .clear,
            strokeColor: Color.MeSection.whiteStrokeLight
        )

        circleLayer.lineWidth = 5
        circleLayer.addGlowEffect(color: .white)
        layer.addSublayer(circleLayer)
    }

    func drawBackCircles(layout: Layout.MeSection, radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circleLayer = CAShapeLayer.circle(
            center: layout.loadCenter,
            radius: radius,
            fillColor: .clear,
            strokeColor: Color.MeSection.whiteStrokeLight
        )

        circleLayer.lineDashPattern = linesDashPattern
        layer.addSublayer(circleLayer)
    }

    func drawDataPointConnections(layout: Layout.MeSection, sectors: [Sector]) {
        let connections = MyUniverseHelper.dataPointConnections(sectors: sectors, layout: layout)
        connections.forEach { (connection: CAShapeLayer) in
            layer.addSublayer(connection)
        }
    }

    func drawDataPoints(layout: Layout.MeSection, sectors: [Sector]) {
        let dataPoints = MyUniverseHelper.dataPoints(sectors: sectors, layout: layout)
        dataPoints.forEach { (dataPoint: CAShapeLayer) in
            layer.addSublayer(dataPoint)
        }
    }
}
