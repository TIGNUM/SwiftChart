//
//  MeSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MeSectionViewControllerDelegate: class {
    func didTapSector(sector: Sector?, in viewController: UIViewController)
}

final class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: MeSectionViewModel
    fileprivate let strokeColor = UIColor(white: 1, alpha: 0.2)
    fileprivate var dataCenterPoints = [[CGPoint]]()
    fileprivate var connectionCenterPpoitns = [[CGPoint]]()
    fileprivate let scrollView = UIScrollView(frame: screen)
    fileprivate var profileImageView = UIImageView()
    weak var delegate: MeSectionViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: MeSectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.Default.navy
        setupScrollView()
        addBackgroundImage()
        setupProfileImage()
        drawUniverse()
        addTabRecognizer()
    }

    private func addBackgroundImage() {
        let frame = CGRect(x: screen.minX, y: screen.minY, width: screen.width * 2, height: screen.height)
        let imageView = UIImageView(frame: frame)
        imageView.image = R.image.solarSystemBackground()
        scrollView.addSubview(imageView)
    }

    private func drawUniverse() {
        drawBackCircles(radius: Layout.MeSection.radiusAverageLoad, linesDashPattern: [3, 1])
        drawBackCircles(radius: Layout.MeSection.radiusMaxLoad)
        collectCenterPoints()
        connectDataPoint()
        drawDots()
        addCategoryLabels()
        view.addSubview(profileImageView)
    }

    private func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func didTapSector(recognizer: UITapGestureRecognizer) {
        delegate?.didTapSector(sector: sector(location: recognizer.location(in: view)), in: self)
    }

    func sector(location: CGPoint) -> Sector? {
        let radius = lengthFromCenter(for: location)
        let yn = location.y - profileImageView.center.y
        let xn = location.x - profileImageView.center.x
        let beta = acos(xn / radius)
        let sectorAngle = beta.radiansToDegrees

        for (_, sector) in viewModel.sectors.enumerated() {
            if yn >= 0 {
                if sector.startAngle ... sector.endAngle ~= sectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return viewModel.sectors.last
                }
            } else {
                let mappedSectorAngle = 180 + (180 - sectorAngle)
                if sector.startAngle ... sector.endAngle ~= mappedSectorAngle {
                    return sector
                }

                if sectorAngle < 100 {
                    return viewModel.sectors.first
                }
            }
        }

        return nil
    }

    func lengthFromCenter(for location: CGPoint) -> CGFloat {
        let diffX = pow(location.x - profileImageView.center.x, 2)
        let diffY = pow(location.y - profileImageView.center.y, 2)

        return sqrt(diffX + diffY)
    }
}

// MARK: - Draw

private extension MeSectionViewController {

    func setupScrollView() {
        view = scrollView
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(
            width: (screen.width * 2) - (Layout.MeSection.scrollViewOffset * 4),
            height: screen.height - 84 // TODO: Change it when the tabBar is all setup corectly with bottomLayout.
        )
    }

    func setupProfileImage() {
        profileImageView = UIImageView(frame: Layout.MeSection.profileImageViewFrame)
        profileImageView.image = viewModel.profileImage
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = Layout.MeSection.profileImageWidth * 0.5
        profileImageView.clipsToBounds = true

        profileImageView.layer.shadowColor = UIColor.green.cgColor
        profileImageView.layer.shadowRadius = 10
        profileImageView.layer.shadowOpacity = 0.8
        profileImageView.layer.shadowOffset = .zero
    }

    func drawBackCircles(radius: CGFloat, linesDashPattern: [NSNumber]? = nil) {
        let circlePath = UIBezierPath.circlePath(center: Layout.MeSection.loadCenter, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: .clear,
            strokeColor: strokeColor
        )
        shapeLayer.lineDashPattern = linesDashPattern
        view.layer.addSublayer(shapeLayer)
    }

    func collectCenterPoints() {
        viewModel.sectors.forEach { (sector: Sector) in
            var centerPoints = [CGPoint]()

            sector.spikes.forEach { (spike: Spike) in
                let centerPoint = CGPoint.centerPoint(
                    with: viewModel.radius(for: spike.spikeLoad()),
                    angle: spike.angle,
                    relativeCenter: profileImageView.center
                )

                centerPoints.append(centerPoint)
            }

            dataCenterPoints.append(centerPoints)
            connectionCenterPpoitns.append(centerPoints)
        }
    }

    func drawDots() {
        for (dataIndex, centerPoints) in dataCenterPoints.enumerated() {
            for (centerIndex, center) in centerPoints.enumerated() {
                let sector = viewModel.sector(at: dataIndex)

                guard centerIndex < sector.spikes.count else {
                    return
                }

                let spike = viewModel.spike(for: sector, at: centerIndex )
                let radius = viewModel.radius(for: spike.spikeLoad())

                drawDot(
                    fillColor: viewModel.fillColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type),
                    strokeColor: viewModel.strokeColor(radius: radius, load: spike.spikeLoad(), sectorType: sector.type),
                    center: center,
                    radius: (spike.load * 8),
                    lineWidth: sector.type.lineWidth(load: spike.load)//(spike.load * ((sector.type == .load) ? 8 : 2)) * ((sector.type == .load) ? 2 : 1)
                )
            }
        }
    }

    func drawDot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat, lineWidth: CGFloat) {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: fillColor,
            strokeColor: strokeColor
        )

        shapeLayer.lineWidth = lineWidth
        shapeLayer.shadowColor = strokeColor.cgColor
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowOpacity = 0.9
        shapeLayer.shadowOffset = .zero
        view.layer.addSublayer(shapeLayer)
    }

    func connectDataPoint() {
        addAditionalConnectionPoints()

        connectionCenterPpoitns.shuffled().forEach { (centerPopints: [CGPoint]) in
            for (index, center) in centerPopints.shuffled().enumerated() {
                let nextIndex = (index + 1)

                guard nextIndex < centerPopints.count else {
                    return
                }

                let nextCenter = centerPopints[nextIndex]
                let line = CAShapeLayer.line(from: center, to: nextCenter, strokeColor: strokeColor)
                view.layer.addSublayer(line)
            }
        }
    }

    func addAditionalConnectionPoints() {
        for (sectorIndex, sector) in viewModel.sectors.enumerated() {
            var centerPoints = [CGPoint]()

            for index in stride(from: 0, to: sector.spikes.count, by: 2) {
                let centerPoint = dataCenterPoints[sectorIndex][index]
                centerPoints.append(centerPoint)
                centerPoints.append(Layout.MeSection.connectionCenter)
            }

            connectionCenterPpoitns.append(centerPoints)
        }
    }

    func addCategoryLabels() {
        viewModel.sectors.forEach { (sector: Sector) in
            let categoryLabel = sector.label
            let labelCenter = CGPoint.centerPoint(
                with: viewModel.radius(for: categoryLabel.load),
                angle: categoryLabel.angle,
                relativeCenter: profileImageView.center
            )

            let labelValues = viewModel.labelValues(for: sector)
            let frame = CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: Layout.MeSection.labelHeight)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text.uppercased()
            label.textColor = labelValues.textColor
            label.font = labelValues.font
            label.numberOfLines = 0
            label.textAlignment = .center
            label.frame = CGRect(x: labelCenter.x - labelValues.widthOffset, y: labelCenter.y, width: frame.width, height: Layout.MeSection.labelHeight)
            label.sizeToFit()
            view.addSubview(label)
        }
    }
}
