//
//  MyDataView.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

protocol MyDataViewDelegate: class {
    func myDataView(_ view: MyDataView, pressedProfileButton button: UIButton)
}

final class MyDataView: UIView {
    
    // MARK: - Properties

    private let viewModel: MyUniverseViewModel
    private var dataPoints = [ChartDataPoint]()
    private var dataPointConnections = [CAShapeLayer]()
    var universeDotsLayer = CAShapeLayer()
    var profileImageBackgroundView = UIView()
    var profileImageButton = UIButton()
    var profileImageViewOverlay = UIImageView()
    var profileImageViewOverlayEffect = UIImageView()
    var previousBounds = CGRect.zero
    weak var delegate: MyDataViewDelegate?

    // MARK: - Init

    init(delegate: MyDataViewDelegate, viewModel: MyUniverseViewModel, frame: CGRect) {
        self.delegate = delegate
        self.viewModel = viewModel

        super.init(frame: frame)
        
        drawBackground()
        setupProfileImage()
        updateProfileImageResource()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        guard previousBounds.equalTo(bounds) == false else { return }
        previousBounds = bounds
        reload()
    }
    
    func reload() {
        drawUniverse(with: viewModel.sectors)
        bringSubview(toFront: profileImageBackgroundView)
        bringSubview(toFront: profileImageButton)
        bringSubview(toFront: profileImageViewOverlay)
        bringSubview(toFront: profileImageViewOverlayEffect)
    }

    func updateProfileImageResource() {
        let placeholder = R.image.universe_2state()
        profileImageButton.kf.setBackgroundImage(with: viewModel.profileImageURL,
                                                 for: .normal,
                                                 placeholder: placeholder) { [weak self] (image, _, _, _) in
            guard let `self` = self, let image = image else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                let processed = UIImage.makeGrayscale(image)
                DispatchQueue.main.async {
                    self.profileImageViewOverlay.image = processed
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
    
    func drawBackground() {
        let layout = Layout.MeSection(viewControllerFrame: bounds)
        drawBackCircles(layout: layout, radius: layout.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(layout: layout, radius: layout.radiusMaxLoad)
    }

    func drawUniverse(with sectors: [Sector]) {
        let layout = Layout.MeSection(viewControllerFrame: bounds)
        MyUniverseHelper.collectCenterPoints(layout: layout, sectors: sectors, relativeCenter: profileImageButton.center)
        drawDataPointConnections(layout: layout, sectors: sectors)
        drawDataPoints(layout: layout, sectors: sectors)
    }
    
    func setupProfileImage() {
        let layout = Layout.MeSection(viewControllerFrame: bounds)
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
        
        addSubview(profileImageBackgroundView)
        addSubview(profileImageButton)
        addSubview(profileImageViewOverlay)
        addSubview(profileImageViewOverlayEffect)
    }

    func addImageEffect(center: CGPoint) {
        let circleLayer = CAShapeLayer.circle(center: center,
                                              radius: profileImageButton.frame.width * 0.5,
                                              fillColor: .clear,
                                              strokeColor: Color.MeSection.whiteStrokeLight)
        circleLayer.lineWidth = 5
        circleLayer.addGlowEffect(color: .white)
        layer.addSublayer(circleLayer)
    }
    
    func drawBackCircles(layout: Layout.MeSection, radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circleLayer = CAShapeLayer.circle(center: layout.loadCenter,
                                              radius: radius,
                                              fillColor: .clear,
                                              strokeColor: Color.MeSection.backgroundCircle)
        circleLayer.lineDashPattern = linesDashPattern
        layer.addSublayer(circleLayer)
    }

    func drawDataPointConnections(layout: Layout.MeSection, sectors: [Sector]) {
        dataPointConnections.forEach { $0.removeFromSuperlayer() }
        dataPointConnections = MyUniverseHelper.dataPointConnections(sectors: sectors, layout: layout, center: profileImageButton.center)
        dataPointConnections.forEach { layer.addSublayer($0) }
    }

    func drawDataPoints(layout: Layout.MeSection, sectors: [Sector]) {
        dataPoints.forEach { $0.dot.removeFromSuperlayer() }
        universeDotsLayer = CAShapeLayer()
        universeDotsLayer.backgroundColor = UIColor.yellow.cgColor
        dataPoints = MyUniverseHelper.dataPoints(sectors: sectors, layout: layout)
        dataPoints.forEach { universeDotsLayer.addSublayer($0.dot) }
        layer.addSublayer(universeDotsLayer)
    }
}

// MARK: - Actions

private extension MyDataView {
    
    @objc func profileButtonPressed(_ sender: UIButton) {
        delegate?.myDataView(self, pressedProfileButton: sender)
    }
}
