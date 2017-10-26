//
//  MyDataView.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

protocol MyUniverseView: class {
    var previousBounds: CGRect { get set }
    func draw()
}

extension MyUniverseView where Self: UIView {
    func cleanUpAndDraw() {
        guard previousBounds.equalTo(bounds) == false else {
            return
        }

        cleanUp()
        previousBounds = bounds
        draw()
    }

    func cleanUp() {
        removeSubLayers()
        removeSubViews()
    }
}

protocol MyDataViewDelegate: class {
    func myDataView(_ view: MyDataView, pressedProfileButton button: UIButton)
}

final class MyDataView: UIView, MyUniverseView {
    // MARK: - Properties

    var universeDotsLayer = CAShapeLayer()
    var profileImageBackgroundView = UIView()
    var profileImageButton = UIButton()
    var profileImageViewOverlay = UIImageView()
    var profileImageViewOverlayEffect = UIImageView()
    var sectors = [Sector]()
    var myDataViewModel: MyDataViewModel
    var previousBounds = CGRect.zero
    var dataPoints = [ChartDataPoint]()
    weak var delegate: MyDataViewDelegate?

    // MARK: - Init

    init(delegate: MyDataViewDelegate, sectors: [Sector], myDataViewModel: MyDataViewModel, frame: CGRect) {
        self.delegate = delegate
        self.sectors = sectors
        self.myDataViewModel = myDataViewModel

        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        cleanUpAndDraw()
    }

    func draw() {
        drawUniverse(with: sectors, profileImageResource: myDataViewModel.profileImageResource, layout: Layout.MeSection(viewControllerFrame: bounds))
    }
    
    func updateProfileImageResource(_ resource: MediaResource) {
        profileImageButton.setBackgroundImageFromResource(resource, defaultImage: R.image.universe_2state()) { [weak self] (image: UIImage?, error: Error?) in
            if let image = image, let overlay = self?.profileImageViewOverlay {
                DispatchQueue.global(qos: .userInitiated).async {
                    let processed = UIImage.makeGrayscale(image)
                    DispatchQueue.main.async {
                        overlay.image = processed
                    }
                }
            }
        }
    }
    
    func dataPointForPoint(_ point: CGPoint) -> ChartDataPoint? {
        for dataPoint in dataPoints {
            if dataPoint.frame.contains(point) {
                return dataPoint
            }
        }
        return nil
    }
}

// MARK: - Private Helpers / Draw SolarSystem

private extension MyDataView {

    func drawUniverse(with sectors: [Sector], profileImageResource: MediaResource?, layout: Layout.MeSection) {
        self.sectors = sectors

        drawBackCircles(layout: layout, radius: layout.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(layout: layout, radius: layout.radiusMaxLoad)

        setupProfileImage(layout: layout)
        if let profileImageResource = profileImageResource {
            updateProfileImageResource(profileImageResource)
        }
        
        MyUniverseHelper.collectCenterPoints(layout: layout, sectors: sectors, relativeCenter: profileImageButton.center)
        drawDataPointConnections(layout: layout, sectors: sectors)
        drawDataPoints(layout: layout, sectors: sectors)

        addSubview(profileImageBackgroundView)
        addSubview(profileImageButton)
        addSubview(profileImageViewOverlay)
        addSubview(profileImageViewOverlayEffect)
    }
    
    func setupProfileImage(layout: Layout.MeSection) {
        let frame = layout.profileImageViewFrame
        let cornerRadius = (frame.size.width * 0.5)

        profileImageBackgroundView = UIView(frame: frame)
        profileImageBackgroundView.backgroundColor = Color.MeSection.myUniverseBlue
        profileImageBackgroundView.layer.cornerRadius = cornerRadius
        profileImageBackgroundView.clipsToBounds = true
        
        profileImageViewOverlay = UIImageView(frame: frame)
        profileImageViewOverlay.layer.cornerRadius = cornerRadius
        profileImageViewOverlay.clipsToBounds = true
        
        profileImageViewOverlayEffect = UIImageView(frame: frame)
        profileImageViewOverlayEffect.backgroundColor = Color.Default.whiteMedium
        profileImageViewOverlayEffect.layer.cornerRadius = cornerRadius
        profileImageViewOverlayEffect.clipsToBounds = true
        
        profileImageButton = UIButton(type: .custom)
        profileImageButton.frame = frame
        profileImageButton.addTarget(self, action: #selector(profileButtonPressed(_:)), for: .touchUpInside)
        profileImageButton.layer.cornerRadius = cornerRadius
        profileImageButton.clipsToBounds = true
        
        addImageEffect(center: layout.loadCenter)
    }

    func addImageEffect(center: CGPoint) {
        let circleLayer = CAShapeLayer.circle(
            center: center,
            radius: profileImageButton.frame.width * 0.5,
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
            strokeColor: Color.MeSection.backgroundCircle
        )

        circleLayer.lineDashPattern = linesDashPattern
        layer.addSublayer(circleLayer)
    }

    func drawDataPointConnections(layout: Layout.MeSection, sectors: [Sector]) {
        let connections = MyUniverseHelper.dataPointConnections(sectors: sectors, layout: layout, center: profileImageButton.center)
        connections.forEach { (connection: CAShapeLayer) in
            layer.addSublayer(connection)
        }
    }

    func drawDataPoints(layout: Layout.MeSection, sectors: [Sector]) {
        universeDotsLayer = CAShapeLayer()
        universeDotsLayer.backgroundColor = UIColor.yellow.cgColor
        dataPoints = MyUniverseHelper.dataPoints(sectors: sectors, layout: layout)
        dataPoints.forEach { (dataPoint: ChartDataPoint) in
            universeDotsLayer.addSublayer(dataPoint.dot)
        }
        layer.addSublayer(universeDotsLayer)
    }
}

// MARK: - Actions

private extension MyDataView {
    @objc func profileButtonPressed(_ sender: UIButton) {
        delegate?.myDataView(self, pressedProfileButton: sender)
    }
}
