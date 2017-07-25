//
//  MyDataView.swift
//  QOT
//
//  Created by karmic on 11.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

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

    var profileImageButton = UIButton()
    var profileImageViewOverlay = UIImageView()
    var profileImageViewOverlayEffect = UIImageView()
    var sectors = [Sector]()
    var profileImage: UIImage?
    var previousBounds = CGRect.zero
    weak var delegate: MyDataViewDelegate?

    // MARK: - Init

    init(delegate: MyDataViewDelegate, sectors: [Sector], profileImage: UIImage?, frame: CGRect) {
        self.delegate = delegate
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

        cleanUpAndDraw()
    }

    func draw() {
        drawUniverse(with: sectors, profileImage: profileImage, layout: Layout.MeSection(viewControllerFrame: bounds))
    }
    
    func updateProfileImage(_ image: UIImage?) {
        profileImage = image
        profileImageButton.setBackgroundImage(profileImageViewImage(image), for: .normal)
    }
}

// MARK: - Private Helpers / Draw SolarSystem

private extension MyDataView {

    func drawUniverse(with sectors: [Sector], profileImage: UIImage?, layout: Layout.MeSection) {
        self.sectors = sectors
        self.profileImage = profileImage

        drawBackCircles(layout: layout, radius: layout.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(layout: layout, radius: layout.radiusMaxLoad)
        setupProfileImage(layout: layout, profileImage: profileImageViewImage(profileImage))
        MyUniverseHelper.collectCenterPoints(layout: layout, sectors: sectors, relativeCenter: profileImageButton.center)
        drawDataPointConnections(layout: layout, sectors: sectors)
        drawDataPoints(layout: layout, sectors: sectors)
        addSubview(profileImageButton)
        addSubview(profileImageViewOverlay)
        addSubview(profileImageViewOverlayEffect)
    }
    
    func profileImageViewImage(_ image: UIImage?) -> UIImage? {
        return image ?? R.image.universe_2state()
    }
    
    func setupProfileImage(layout: Layout.MeSection, profileImage: UIImage?) {
        var grayscaleProfile: UIImage?
        if let profileImage = profileImage {
            grayscaleProfile = UIImage.makeGrayscale(profileImage)
        }
        profileImageButton = UIButton(type: .custom)
        profileImageButton.frame = layout.profileImageViewFrame
        profileImageButton.setBackgroundImage(profileImage, for: .normal)
        profileImageButton.addTarget(self, action: #selector(profileButtonPressed(_:)), for: .touchUpInside)
        profileImageButton.layer.cornerRadius = (profileImageButton.frame.size.width * 0.5)
        profileImageButton.clipsToBounds = true
        profileImageViewOverlay = UIImageView(frame: layout.profileImageViewFrame, image: grayscaleProfile)
        profileImageViewOverlayEffect = UIImageView(frame: layout.profileImageViewFrame, image: nil)
        profileImageViewOverlayEffect.backgroundColor = Color.Default.whiteMedium
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

// MARK: - Actions

private extension MyDataView {
    @objc func profileButtonPressed(_ sender: UIButton) {
        delegate?.myDataView(self, pressedProfileButton: sender)
    }
}
