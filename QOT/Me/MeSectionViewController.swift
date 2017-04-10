//
//  MeSectionViewController.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol MeSectionViewControllerDelegate: class {
    func didTapSector(sector: Sector?, for view: UIView, in viewController: UIViewController)
}

final class MeSectionViewController: UIViewController {
    
    // MARK: - Properties

    fileprivate let viewModel: MeSectionViewModel
    fileprivate let strokeColor = UIColor(white: 1, alpha: 0.2)
    fileprivate var dataCenterPoints = [CGPoint]()
    fileprivate var connectionCenterPpoitns = [CGPoint]()
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

        drawUniverse()
        addTabRecognizer()
    }

    private func drawUniverse() {
        setupScrollView()
        view.backgroundColor = .black
        drawBackCircles(radius: Layout.MeSection.radiusAverageLoad, linesDashPattern: [2, 1])
        drawBackCircles(radius: Layout.MeSection.radiusMaxLoad)
        setupProfileImage()
        collectCenterPoints()
        connectDataPoint()
        placeDots()
        addCategoryLabels()
        view.addSubview(profileImageView)
    }

    private func addTabRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSector))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func didTapSector(recognizer: UITapGestureRecognizer) {

        print(sector(location: recognizer.location(in: view))?.title ?? "invalid")
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
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = Layout.MeSection.profileImageWidth * 0.5
        profileImageView.clipsToBounds = true
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
        viewModel.spikes.forEach { (spike: Spike) in
            let centerPoint = CGPoint.centerPoint(
                with: viewModel.radius(for: spike.spikeLoad()),
                angle: spike.angle,
                relativeCenter: profileImageView.center
            )

            dataCenterPoints.append(centerPoint)
            connectionCenterPpoitns.append(centerPoint)
        }
    }

    func placeDots() {
        for (index, center) in dataCenterPoints.enumerated() {
            let spike = viewModel.spikes[index]
            let radius = viewModel.radius(for: spike.spikeLoad())

            placeDot(
                fillColor: viewModel.fillColor(radius: radius, load: spike.spikeLoad()),
                strokeColor: viewModel.strokeColor(radius: radius, load: spike.spikeLoad()),
                center: center,
                radius: (spike.load * 8)
            )
        }
    }

    func placeDot(fillColor: UIColor, strokeColor: UIColor, center: CGPoint, radius: CGFloat) {
        let circlePath = UIBezierPath.circlePath(center: center, radius: radius)
        let shapeLayer = CAShapeLayer.pathWithColor(
            path: circlePath.cgPath,
            fillColor: fillColor,
            strokeColor: strokeColor
        )

        shapeLayer.lineWidth = radius * 2
        view.layer.addSublayer(shapeLayer)
    }

    func connectDataPoint() {
        addAditionalConnectionPoints()

        for (index, center) in connectionCenterPpoitns.shuffled().enumerated() {
            let nextIndex = (index + 1)
            guard nextIndex < connectionCenterPpoitns.count else {
                return
            }

            let nextCenter = connectionCenterPpoitns[nextIndex]
            let line = CAShapeLayer.line(from: center, to: nextCenter, strokeColor: strokeColor)
            view.layer.addSublayer(line)
        }
    }

    func addAditionalConnectionPoints() {
        for index in stride(from: 0, to: viewModel.spikeCount, by: 5) {
            let centerPoint = dataCenterPoints[index]
            connectionCenterPpoitns.append(centerPoint)
            connectionCenterPpoitns.append(Layout.MeSection.connectionCenter)
        }
    }

    func addCategoryLabels() {
        CategoryLabel.allLabels.forEach { (categoryLabel: CategoryLabel) in
            let labelCenter = CGPoint.centerPoint(
                with: viewModel.radius(for: categoryLabel.load),
                angle: categoryLabel.angle,
                relativeCenter: profileImageView.center
            )

            let frame = CGRect(x: labelCenter.x, y: labelCenter.y, width: 0, height: Layout.MeSection.labelHeight)
            let label = UILabel(frame: frame)
            label.text = categoryLabel.text.uppercased()
            label.textColor = Color.MeSection.whiteLabel
            label.font = Font.MeSection.sectorDefault
            label.numberOfLines = 0
            label.textAlignment = .center
            label.sizeToFit()
            view.addSubview(label)
        }
    }
}
